$(document).ready(function(){
  $input = $("[data-behavior='autocomplete']");
  var options = {
    getValue: "name",
    url: function(name) {
      return "/search?q=" + name;
    },
    categories: [
    {
      listLocation: "dishes",
      header: "<strong>Dishes</strong>"
    } ],
    list: {
      onChooseEvent: function() {
        var url = $input.getSelectedItemData().url;
        var host = document.location.host + "";
      }
    }
  };
  $input.easyAutocomplete(options);
});

