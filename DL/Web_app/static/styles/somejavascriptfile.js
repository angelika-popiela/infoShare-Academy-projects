$(function() {
  $("#datepicker").datepicker({
    showWeek: true,
    firstDay: 1,
    maxDate: 'today',
    beforeShow: function(elem, ui) {
      $(ui.dpDiv).on('click', 'tbody .ui-datepicker-week-col', function() {
      	$(elem).val('Week ' + $(this).text()).datepicker( "hide" );
      });
    }
  });
});

