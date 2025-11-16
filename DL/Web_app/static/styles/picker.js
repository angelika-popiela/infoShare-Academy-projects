$('#testDate').datepicker({
    onSelect: function(dateText, inst) {
        var d = new Date(dateText);
        var d1 = new Date(d.getFullYear(), d.getMonth(), 1)
        var x = $.datepicker.iso8601Week(d) % 52;
        var y = $.datepicker.iso8601Week(d1) % 52;
        $('#label1').text(x-y+1);
    }
});