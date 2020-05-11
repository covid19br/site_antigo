function updateExibition(current) {
    var selector = "." + current;
    
    //cleans
    $(".card-deck").css( "display", "none" );
    
    //updates
    $(".card-deck"+selector).css( "display", "flex" );
    updateMenu(current);
}

function updateMenu(current) {
    // cleans
    $(".card.menu").removeClass("selected");

    // updates
    var selector = ".card.menu[card-id='" + current +"']" ;
    $(selector).addClass("selected");
}