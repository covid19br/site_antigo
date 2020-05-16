function updateWidgetAcumdia(request_id) {
    // Get Widget's SRCs
    var widget_src = "";

    // verifica se o primeiro grafico ja foi ativado. Se sim, pega a versao interativa
    if ($(".acumdia.cov.nowcast > .codegena_iframe > iframe").length) widget_src = $(".acumdia.cov.nowcast > .codegena_iframe > iframe").attr("src");
    else widget_src = $(".codegena_iframe.acumdia.cov.nowcast").attr("data-src");

    if (widget_src.indexOf("nowcast") >= 0) {
        // determina o id do path atual no site
        var current_id = request_id;
        if (widget_src.indexOf("_cum_") >= 0) current_id = "acu";
        else current_id = "dia";
        
        var new_src = "";
        if (request_id == current_id) return;
        else if (request_id == "dia") {
            new_src = widget_src.replace("_cum_", "_");
        }
        else if (request_id == "acu") {
            new_src = widget_src.replace("nowcast_", "nowcast_cum_");
        }
        
        // Update SRCs
        $(".acumdia.cov.nowcast > .codegena_iframe > iframe").attr("src", new_src);
        $(".acumdia.srag.nowcast > .codegena_iframe > iframe").attr("src", new_src.replace("covid", "srag"));
        $(".acumdia.cov.ob > .codegena_iframe > iframe").attr("src", new_src.replace("_covid", "_ob_covid"));
        $(".acumdia.srag.ob > .codegena_iframe > iframe").attr("src", new_src.replace("_covid", "_ob_srag_proaim"));
    }
    else return
}

function updatePlaceholderAcumdia(request_id) {
    // Get Graph's SRCs
    var graph_src = "";
    
    // verifica se o primeiro grafico ja foi ativado. Se sim, pega a versao interativa
    if ($(".codegena_iframe.acumdia.cov.nowcast").length) {
        graph_src = $(".codegena_iframe.acumdia.cov.nowcast").attr("data-src");
    }
    else {
        graph_src = $(".acumdia.cov.nowcast > .codegena_iframe > iframe").attr("src");
    }
    
    // change id
    
    // determina o id do path atual no site
    var current_id = request_id;
    if (graph_src.indexOf("_cum_") >= 0) current_id = "acu";
    else current_id = "dia";
    
    // prepare strings
    var new_src = "";

    if (request_id == current_id) return; // se o requisitado e o atual sao iguais nao precisa atualizar
    else if (request_id == "dia") {
        new_src = graph_src.replace("_cum_", "_");
    }
    else if (request_id == "acu") {
        new_src = graph_src.replace("nowcast_", "nowcast_cum_");
    }

    var new_svg = new_src.replace("html", "svg");
    
    // Update SRCs
    // HTML Widget
    $(".codegena_iframe.acumdia.cov.nowcast").attr("data-src", new_src);
    $(".codegena_iframe.acumdia.srag.nowcast").attr("data-src", new_src.replace("covid", "srag"));
    $(".codegena_iframe.acumdia.cov.ob").attr("data-src", new_src.replace("_covid", "_ob_covid"));
    $(".codegena_iframe.acumdia.srag.ob").attr("data-src", new_src.replace("_covid", "_ob_srag_proaim"));
    // SVG Placeholder
    $(".placeholder_svg.acumdia.cov.nowcast").attr("src", new_svg);
    $(".placeholder_svg.acumdia.srag.nowcast").attr("src", new_svg.replace("covid", "srag"));
    $(".placeholder_svg.acumdia.cov.ob").attr("src", new_svg.replace("_covid", "_ob_covid"));
    $(".placeholder_svg.acumdia.srag.ob").attr("src", new_svg.replace("_covid", "_ob_srag_proaim"));
    /* Responsive SVG
    $('source[media="(max-width: 575.98px)"]').attr("srcset",(responsive+".ex.svg"));
    $('source[media="(max-width: 767.98px)"]').attr("srcset",(responsive+".sm.svg"));
    $('source[media="(max-width: 991.98px)"]').attr("srcset",(responsive+".md.svg"));
    $('source[media="(max-width: 1199.98px)"]').attr("srcset",(responsive+".lg.svg")); */
}

function updateAcumDia(request_id) {
    var selector = "." + request_id;
    
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
    if ($(".placeholder_svg.acumdia").length) updatePlaceholderAcumdia(request_id) // placeholder image
    if ($(".responsive_iframe").length) updateWidgetAcumdia(request_id);
}