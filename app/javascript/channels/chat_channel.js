import consumer from "channels/consumer";

if (location.pathname.match(/\/movies\/\d+\/chats/)) {
  console.log("読み込み完了");

  consumer.subscriptions.create("ChatChannel", {  // ✅ "ChatChannel" を正しく指定
    connected() {
      console.log("WebSocket接続成功");
    },

    disconnected() {
      console.log("WebSocket切断");
    },

    received(data) {
      console.log("受信データ:", data);
    }
  });
}
