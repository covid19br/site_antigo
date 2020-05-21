function updateCasObi(request_id) {
    var selector = "." + request_id;
    
    // DROPDOWN
    // list
    $(".casobi > .dropdown-item").removeClass("active"); // cleans
    $(".casobi > .dropdown-item").filter(function(){
        return $(this).attr('r') === request_id;
    }).addClass("active");   // update

    // title
    var request_verbose = $(".casobi > .dropdown-item.active").first().text();
    $("button.casobi").text(request_verbose); // title update

    // CONTENT
    // main text
    $(".casobi-text").css( "display", "none" ); // cleans
    $(".casobi-text"+selector).css( "display", "block" ); // updates

    // graph titles
    $(".casos_ou_obito").text(request_verbose.toLowerCase());
}