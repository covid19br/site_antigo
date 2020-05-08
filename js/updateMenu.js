/* Functions */
function updateExibition(current) {
    const selector = "." + current;
    
    //cleans
    $(".card-deck").css( "display", "none" );
    $(".card-columns").css( "display", "none" );
    
    //updates
    $(".card-deck"+selector).css( "display", "flex" );
    $(".card-columns"+selector).css( "display", "block" );
}

function updateMenu(current) {
    // cleans
    $(".card.menu").removeClass("selected");

    // updates
    var selector = ".card.menu[card-id='" + current +"']" ;
    $(selector).addClass("selected");
}

/* Main */
updateExibition($(".card.menu.selected").attr("card-id"));

// JQuery OnClick Update
$(".card.menu").click(function () {
    // se nao eh o item atual
    if (!$(this).hasClass("selected")) {
        const current = $(this).attr("card-id");
        updateMenu(current);
        updateExibition(current);
        // esconde os outros
        // aparece o do link
    }
})