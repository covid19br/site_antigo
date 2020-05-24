function updateWidgetAcumdia(request_id, current_id, current_uf) {
    var new_src = ""; // prepare strings
    var UF, municipio;
    [UF, municipio] = current_uf.split('-');

    if (request_id == current_id) return;
    else if (request_id == "dia") {
        new_src = "./web/municipios/" + UF + "/" + municipio + "/plot_nowcast_covid.html";
    }
    else if (request_id == "acu") {
        new_src = "./web/municipios/" + UF + "/" + municipio + "/plot_nowcast_cum_covid.html";
    }

    // Update SRCs
    $(".acumdia.cov.nowcast > .codegena_iframe > iframe").attr("src", new_src);
    $(".acumdia.srag.nowcast > .codegena_iframe > iframe").attr("src", new_src.replace("covid", "srag"));
    $(".acumdia.cov.ob > .codegena_iframe > iframe").attr("src", new_src.replace("_covid", "_ob_covid"));
    $(".acumdia.srag.ob > .codegena_iframe > iframe").attr("src", new_src.replace("_covid", "_ob_srag"));
}

function updatePlaceholderAcumdia(request_id, current_id, current_uf) {
    var new_src = ""; // prepare strings
    var UF, municipio;
    [UF, municipio] = current_uf.split('-');

    if (request_id == current_id) return;
    else if (request_id == "dia") {
        new_src = "./web/municipios/" + UF + "/" + municipio + "/plot_nowcast_covid.html";
    }
    else if (request_id == "acu") {
        new_src = "./web/municipios/" + UF + "/" + municipio + "/plot_nowcast_cum_covid.html";
    }

    var new_svg = new_src.replace("html", "svg");
    
    // Update SRCs
    // HTML Widget
    $(".codegena_iframe.acumdia.cov.nowcast").attr("data-src", new_src);
    $(".codegena_iframe.acumdia.srag.nowcast").attr("data-src", new_src.replace("covid", "srag"));
    $(".codegena_iframe.acumdia.cov.ob").attr("data-src", new_src.replace("_covid", "_ob_covid"));
    $(".codegena_iframe.acumdia.srag.ob").attr("data-src", new_src.replace("_covid", "_ob_srag"));
    // SVG Placeholder
    $(".placeholder_svg.acumdia.cov.nowcast").attr("src", new_svg);
    $(".placeholder_svg.acumdia.srag.nowcast").attr("src", new_svg.replace("covid", "srag"));
    $(".placeholder_svg.acumdia.cov.ob").attr("src", new_svg.replace("_covid", "_ob_covid"));
    $(".placeholder_svg.acumdia.srag.ob").attr("src", new_svg.replace("_covid", "_ob_srag"));
    // Responsive SVG
    $('source[media="(max-width: 575.98px)"]').attr("srcset",(responsive+".ex.svg"));
    $('source[media="(max-width: 767.98px)"]').attr("srcset",(responsive+".sm.svg"));
    $('source[media="(max-width: 991.98px)"]').attr("srcset",(responsive+".md.svg"));
    $('source[media="(max-width: 1199.98px)"]').attr("srcset",(responsive+".lg.svg"));
}

function updateAcumDia(request_id) {
    var selector = "." + request_id;
    var current_id = $(".acumdia > .dropdown-item.active").attr("q");
    var current_uf = $(".main-title>.dropdown>.dropdown-menu>.dropdown-item.active").attr("uf")

    // DROPDOWN
    // list
    $(".acumdia > .dropdown-item").removeClass("active"); // cleans
    $(".acumdia > .dropdown-item").filter(function(){
        return $(this).attr('q') === request_id;
    }).addClass("active");   // update

    // title
    var request_verbose = $(".acumdia > .dropdown-item.active").first().text();
    $("button.acumdia").text(request_verbose); // title update

    // CONTENT
    // main text
    $(".acumdia-text").css( "display", "none" ); // cleans
    $(".acumdia-text"+selector).css( "display", "block" ); // updates

    // graph titles
    $(".acum_ou_dia").text(request_verbose.toLowerCase());

    // GRAPHS
    if ($(".placeholder_svg.acumdia").length) updatePlaceholderAcumdia(request_id, current_id, current_uf) // placeholder image
    if ($(".responsive_iframe").length) updateWidgetAcumdia(request_id, current_id, current_uf);
}
