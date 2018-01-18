
$(document).on('turbolinks:load', function() {
  if($('.transaction').length === 0){
    return;
  }
  
  $('#dt').datetimepicker({
    locale: 'it',
    inline: true,
    sideBySide: true
  });
  
  $("#amount").keypress(function(e){
    console.log(e.key);
  });

  var timestamp = $('#hidden_dt').data('current');
  $('#dt').data("DateTimePicker").date(new Date(timestamp * 1000));
  set_hidden_dt($('#dt').data("DateTimePicker").date());
  $('#dt').on('dp.change', function(event) { set_hidden_dt(event.date); });
  
});

function set_hidden_dt(date){
  if(date !== undefined) { 
    var timestamp = date.format('X');
    $('#hidden_dt').val(timestamp);
  }
}
