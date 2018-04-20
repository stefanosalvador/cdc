$(document).on('turbolinks:load', function() {
  if($('#parser_transactions').length === 0){
    return;
  }
  $('.transaction_dt').datetimepicker({
    locale: 'it'
  });
  $('.transaction_discard').click(function(){
    $(this).closest('.verify_transaction').slideUp();
  });
  $('.form_transaction').submit(function( event ) {
    var form = $(this);
    var submit_button = form.find('.transaction_submit');
    submit_button.attr('disabled', 'disabled');
    var data = form.serializeArray();
    $(data).each(function(i,e){
      if(e.name == 'dt') {
        var date = form.find(".transaction_dt").data("DateTimePicker").date();
        e.value = date.format('X');
      }
    });
    $.ajax({
      url: "/transactions.json",
      type: 'POST',
      data: $.param(data),
      success: function(data) {
        form.closest('.verify_transaction').slideUp();
      }
    });
    event.preventDefault();
  });
});

