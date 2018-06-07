$( document ).ready(function() {
  $("#my-calendar").zabuto_calendar({
    today: true,
  });
});

$(document).ready(function(){
  $(".search-btn").click(function(){
    $(".search-bar").toggle(500);
  });
});
