function updateSRC(selection, src, svg) {
    var selector_html = ".codegena_iframe" +  selection;
    var selector_svg = "picture" +  selection;

    $(selector_html).attr("data-src", src);
    $((selector_svg + ' > img.placeholder_svg')).attr("src", svg.replace(".svg", ".md.svg"));
    $((selector_svg + ' > source[media="(max-width: 575.98px)"]')).attr("srcset",svg.replace(".svg", ".ex.svg"));
    $((selector_svg + ' > source[media="(max-width: 767.98px)"]')).attr("srcset",svg.replace(".svg", ".sm.svg"));
    $((selector_svg + ' > source[media="(max-width: 991.98px)"]')).attr("srcset",svg.replace(".svg", ".md.svg"));
    $((selector_svg + ' > source[media="(max-width: 1199.98px)"]')).attr("srcset",svg.replace(".svg", ".md.svg"));
}

function updateWidgetAcumdia(request_id, current_id, current_uf) {
    var new_src = ""; // prepare strings
    var UF, municipio;
    [UF, municipio] = current_uf.split('-');

    if (request_id == current_id) return;
    else if (request_id == "dia") {
        new_src = "./web/" + page_id + "/" + UF + "/" + municipio + "/plot_nowcast_covid.html";
    }
    else if (request_id == "acu") {
        new_src = "./web/" + page_id + "/" + UF + "/" + municipio + "/plot_nowcast_cum_covid.html";
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
        new_src = "./web/" + page_id + "/" + UF + "/" + municipio + "/plot_nowcast_covid.html";
    }
    else if (request_id == "acu") {
        new_src = "./web/" + page_id + "/" + UF + "/" + municipio + "/plot_nowcast_cum_covid.html";
    }

    var new_svg = new_src.replace("html", "svg");
    
    // Update SRCs
    // HTML Widget
    updateSRC(".acumdia.cov.nowcast", new_src, new_svg);

    updateSRC(".acumdia.srag.nowcast", new_src.replace("covid", "srag"), new_svg.replace("covid", "srag"));
    updateSRC(".acumdia.cov.ob", new_src.replace("_covid", "_ob_covid"), new_svg.replace("_covid", "_ob_covid"));
    updateSRC(".acumdia.srag.ob", new_src.replace("_covid", "_ob_srag"), new_svg.replace("_covid", "_ob_srag"));
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
