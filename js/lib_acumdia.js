function updateAcumDia(current) {
    console.log(current);
    var selector = "." + current;
    
    // dropdown
    $(".acumdia > .dropdown-item").removeClass("active"); // cleans
    $(".acumdia > .dropdown-item").filter(function(){
        return $(this).attr('q') === current;
    }).addClass("active");   // update
    $("button.acumdia").text($(".acumdia > .dropdown-item.active").first().text()); // title update

    // content
    // text
    $("div.acumdia-text").css( "display", "none" ); // cleans
    $("div.acumdia-text"+selector).css( "display", "block" ); // updates

    // graphs
}