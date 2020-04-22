function updateContent(current) {
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

updateContent($(".card.menu.selected").attr("card-id"));

// JQuery OnClick Update
$(".card.menu").click(function () {
    // se nao eh o item atual
    if (!$(this).hasClass("selected")) {
        const current = $(this).attr("card-id");
        updateMenu(current);
        updateContent(current);
        // esconde os outros
        // aparece o do link
    }
})