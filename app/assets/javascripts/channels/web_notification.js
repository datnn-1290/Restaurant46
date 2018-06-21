alert("dsdsds");
App.web_notifications = App.cable.subscriptions.create("WebNotificationsChannel", {
  received: function(data) {
    alert(data);
  },
});
alert("end");
