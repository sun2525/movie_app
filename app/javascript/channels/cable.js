import consumer from "channels/consumer";

function setupChat() {
  const chats = document.getElementById("chats");
  if (chats) {
    chats.scrollTop = chats.scrollHeight;
  }

  console.log("📡 ChatChannel 読み込み完了");

  // **既存の購読を解除（購読の重複防止）**
  if (consumer.subscriptions.subscriptions.length > 0) {
    consumer.subscriptions.subscriptions.forEach((subscription) => subscription.unsubscribe());
  }

  const movieIdMatch = location.pathname.match(/\d+/);
  if (!movieIdMatch) {
    console.error("🚨 映画IDが取得できません");
    return;
  }
  const movieId = movieIdMatch[0];
  console.log(`🎬 サブスクライブする映画ID: ${movieId}`);

  const existingMessages = new Set(); // **既存メッセージの管理**

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
        console.log("📩 データ受信:", data);

        if (!data || !data.chat) {
          console.error("🚨 受信データが不正:", data);
          return;
        }

        // **既存メッセージのチェック**
        if (existingMessages.has(data.chat.id)) {
          console.warn("⚠️ すでに表示されているメッセージなのでスキップ:", data.chat.id);
          return;
        }
        existingMessages.add(data.chat.id);

        const currentUserId = document.body.dataset.currentUserId;
        const isMyMessage = data.user.id == currentUserId;

        const messageHtml = `
          <div class="chat-message ${isMyMessage ? 'my-message' : 'other-message'}">
            ${!isMyMessage ? `
              <a href="/users/${data.user.id}">
                <img src="${data.user.avatar_url || '/assets/default_avatar.png'}" alt="${data.user.name}" class="chat-user-icon">
              </a>
            ` : ''}
            <div class="message-bubble">${data.chat.message}</div>
          </div>`;

        const chatBox = document.getElementById("chats");
        if (chatBox) {
          chatBox.insertAdjacentHTML("beforeend", messageHtml);
          chatBox.scrollTop = chatBox.scrollHeight;
        } else {
          console.error("🚨 chats 要素が見つかりません");
        }

        const chatForm = document.getElementById("chat-form");
        if (chatForm) {
          chatForm.reset();
        } else {
          console.error("🚨 chat-form が見つかりません");
        }
      }
    }
  );
}

// 🚀 Turbo Drive のページ遷移時にも実行
document.addEventListener("turbo:load", setupChat);
