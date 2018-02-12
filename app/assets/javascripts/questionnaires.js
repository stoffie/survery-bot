function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(link).parent().before(content.replace(regexp, new_id));
}

$(document).ready(function() {
    $('.remove-fields-for').click(function(e) {
        $(this).siblings('input[type=hidden]').value = '1';
        $(this).parent().css('display', 'none');
        e.preventDefault();
    });
});