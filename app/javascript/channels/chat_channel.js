import consumer from "channels/consumer";

if (location.pathname.match(/\/movies\/\d+\/chats/)) {
  document.addEventListener("DOMContentLoaded", () => {
    const chats = document.getElementById("chats");
    if (chats) {
      chats.scrollTop = chats.scrollHeight; // スクロール位置を最下部に
    }
  });

  console.log("📡 ChatChannel 読み込み完了");

  const movieId = location.pathname.match(/\d+/)[0];
  console.log(`🎬 サブスクライブする映画ID: ${movieId}`);

  consumer.subscriptions.create(
    { channel: "ChatChannel", movie_id: movieId },
    {
      connected() {
        console.log("✅ ActionCable 接続成功！");
      },

      disconnected() {
        console.log("⚠️ ActionCable 切断");
      },

      received(data) {
        console.log("📩 データ受信:", data); // 受信ログ

        if (!data || !data.chat) {
          console.error("🚨 受信データが不正:", data);
          return;
        }

        const currentUserId = document.body.dataset.currentUserId; // 現在のユーザーIDを取得
        const isMyMessage = data.user.id == currentUserId; // 自分のメッセージかどうか判定

        // ✅ メッセージ HTML を修正（CSS クラスを適用）
        const messageHtml = `
          <div class="chat-message ${isMyMessage ? 'my-message' : 'other-message'}">
            <p class="user-info">${data.user.name}：</p>
            <div class="message-bubble">${data.chat.message}</div>
          </div>`;

        const chatBox = document.getElementById("chats");
        if (chatBox) {
          chatBox.insertAdjacentHTML("beforeend", messageHtml); // 新しいメッセージを追加
          chatBox.scrollTop = chatBox.scrollHeight; // 最新メッセージにスクロール
        } else {
          console.error("🚨 chats 要素が見つかりません");
        }

        const chatForm = document.getElementById("chat-form");
        if (chatForm) {
          chatForm.reset(); // 入力欄をリセット
        } else {
          console.error("🚨 chat-form が見つかりません");
        }
      }
    }
  );
}
