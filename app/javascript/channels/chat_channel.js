import consumer from "channels/consumer";

if (location.pathname.match(/\/movies\/\d+\/chats/)) {
  consumer.subscriptions.create({
    channel: "ChatChannel",
    movie_id: location.pathname.match(/\d+/)[0]
  }, {
    received(data) {
      const html = `
        <div class="chat-message">
          <p class="user-info">${data.user.name}：</p>
          <p>${data.chat.message}</p>
        </div>`;

      document.getElementById("chats")?.insertAdjacentHTML("beforeend", html);
      document.getElementById("chat-form")?.reset();
    }
  });
}
