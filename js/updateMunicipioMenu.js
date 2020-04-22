function updateExibition(current) {
    const selector = "." + current;
    
    //cleans
    $(".card-deck").css( "display", "none" );
    
    //updates
    $(selector).css( "display", "flex" );
}

function updateMenu(current) {
    // cleans
    $(".card.menu").removeClass("selected");

    // updates
    var selector = ".card.menu[card-id='" + current +"']" ;
    $(selector).addClass("selected");
}