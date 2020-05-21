function updateMenu(request) {
    // cleans
    $(".nav-item.aba-pill > .nav-link").removeClass("active");
    
    // updates
    var selector = ".nav-item.aba-pill > .nav-link[card-id='" + request +"']" ;
    $(selector).addClass("active");
}

function updateExibition(request) {
    var selector = "." + request;
    
    //cleans
    $(".aba-group").css( "display", "none" );
    
    //updates
    $(".aba-group"+selector).css( "display", "block" );
    updateMenu(request);
}