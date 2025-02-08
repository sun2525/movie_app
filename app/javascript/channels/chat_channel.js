import consumer from "channels/consumer";

if (location.pathname.match(/\/movies\/\d+\/chats/)) {
  document.addEventListener("DOMContentLoaded", () => {
    const chats = document.getElementById("chats");
    if (chats) {
      chats.scrollTop = chats.scrollHeight; // チャットボックスのスクロールを一番下に移動
    }
  });
  
  console.log("ChatChannel 読み込み完了");

  consumer.subscriptions.create({
    channel: "ChatChannel",
    movie_id: location.pathname.match(/\d+/)[0]
  }, {
    connected() {
      console.log("ActionCable 接続成功");
    },

    disconnected() {
      console.log("ActionCable 切断");
    },

    received(data) {
      console.log("データ受信:", data);

      const isMyMessage = data.user.id === parseInt(document.body.dataset.currentUserId);

      const html = `
        <div class="chat-message ${isMyMessage ? 'my-message' : 'other-message'}">
          <p class="user-info">${data.user.name}：</p>
          <div class="message-bubble">${data.chat.message}</div>
        </div>`;

      const chats = document.getElementById("chats");
      if (chats) {
        chats.insertAdjacentHTML("beforeend", html);

        // 最新コメントにスクロール
        chats.scrollTop = chats.scrollHeight;
      } else {
        console.error("chats 要素が見つかりません");
      }

      const chatForm = document.getElementById("chat-form");
      if (chatForm) {
        chatForm.reset();
      } else {
        console.error("chat-form が見つかりません");
      }
    }
  });
}
