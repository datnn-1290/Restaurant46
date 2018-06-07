$(document).ready(function(){
  $input = $('[data-behavior="autocomplete"]');
  var options = {
    getValue: 'name',
    url: function(name) {
      return '/dishes?q=' + name;
    },
    categories: [
    {
      listLocation: 'dishes'
    }],
    list: {
      onChooseEvent: function() {
        var url = $input.getSelectedItemData().url;
        var host = document.location.host + "";
      }
    }
  };
  $input.easyAutocomplete(options);
});
