function isUF(request) {
    var a = 0;
    // verifica se existe codigo uf
    for (a = 0; a < locale.length; a++) {
        if (locale[a].uf == request) return (true);
    }

    // UF not found
    console.log("isUF(): uf not found "+request);
    return (false);
}

function getVerbose(uf) {
    var d = 0;
    for (d = 0; d < locale.length; d++) {
        if (locale[d].uf == uf) return (locale[d].verbose);
    }

    // UF not found: returns to default
    console.log("getVerbose(): uf not found "+uf);
    return (default_verb);
}

function getPreposition(uf) {
    var e = 0;
    for (e = 0; e < locale.length; e++) {
        if (locale[e].uf == uf) return (locale[e].prep);
    }

    // UF not found: returns to default
    console.log("getPreposition(): uf not found "+uf);
    return ("em");
}

function getIndex(uf) {
    var c = 0;
    if(uf == 'br') return (0);
    for (c = 0; c < locale.length; c++) {
        if (locale[c].uf == uf) return (c);
    }

    // UF not found: returns to SP/BR
    console.log("getIndex(): uf not found "+uf);
    return (0);
}

function updatePlaceholder(request_uf) {
    // Get Graph's SRCs
    var graph_src = $(".codegena_iframe").attr("data-src");
    var graph_svg = $(".placeholder_svg").attr("src");
    
    // Process Current Graph's SRC
    var split_src = graph_src.split('.');
    var split_svg = graph_svg.split('.');
    
    // remove UF
    var new_src = "";
    var new_svg = "";
    
    // change UF
    // change UF: fazer funcao
    var split_size = split_svg.length;
    for (i = 1; i < split_size; i++) {
        if (i == (split_size-2)) {
            if(!isUF(split_src[(split_size - 2)])) {
                new_src = new_src + "." + split_src[i] + "." + request_uf;
                new_svg = new_svg + "." + split_svg[i] + "." + request_uf;
                responsive = new_svg;
            }
            else {
                new_src = new_src + "." + request_uf;
                new_svg = new_svg + "." + request_uf;
                responsive = new_svg;
            }
        }
        else {
            new_src = new_src + "." + split_src[i];
            new_svg = new_svg + "." + split_svg[i];
        }
    }

    // Update SRCs
    // HTML Widget
    $(".codegena_iframe").attr("data-src", new_src);
    // SVG Placeholder
    $(".placeholder_svg").attr("src", new_svg);
    // Responsive SVG
    $('source[media="(max-width: 575.98px)"]').attr("srcset",(responsive+".ex.svg"));
    $('source[media="(max-width: 767.98px)"]').attr("srcset",(responsive+".sm.svg"));
    $('source[media="(max-width: 991.98px)"]').attr("srcset",(responsive+".md.svg"));
    $('source[media="(max-width: 1199.98px)"]').attr("srcset",(responsive+".lg.svg"));
}

function updateWidget(request_uf) {
    // Get Widget's SRCs
    var widget_src = $("iframe").attr("src");

    // Process Current Graph's SRC
    var split_src = widget_src.split('.');

    // remove UF
    var new_src = "";

    // change UF
    for (k = 0; k < split_src.length; k++) {
        if (k == (split_src.length - 2)) {
            new_src = new_src + "." + request_uf;
        }
        else {
            if (k == 0) {
                new_src = new_src + split_src[k];
            }
            else {
                new_src = new_src + "." + split_src[k];
            }
        }
    }

    // Update SRCs
    $("iframe").attr("src", new_src);
}

function updatePage(request_uf) {
    /* comportamento: atualiza conteudo dinamico de acordo com o municipio id */
    var current_state = getVerbose(request_uf);
    var current_index = getIndex(request_uf);
    var current_prepo = getPreposition(request_uf);
    var repo_url = 'https://raw.githubusercontent.com/covid19br/covid19br.github.io/master/';

    // titulo
    $("#page-title").text(current_state);

    // dropdown
    $(".main-title>.dropdown>.dropdown-menu>.dropdown-item").removeClass("active"); // cleans
    $(".main-title>.dropdown>.dropdown-menu>.dropdown-item").filter(function(){
        return $(this).text() === current_state;
    }).addClass("active"); // updates

    // conteudo dinamico
    // nome do local
    $(".locale").text(current_state);
    $(".prep").text(current_prepo);
    $(".locale-prep").text(current_prepo + " " + current_state);

    const regex = /"/gi;
    // texto dinamico

    // progressao.html
    // data e hora
    updateDate('last.update.estado');

    // forecast_exp
    var filename = 'data_forecast_exp'
    var extension = '_estados.csv';
    if (request_uf == 'br') extension = '_br.csv';
    else current_index = current_index - 1; // move um index para cima para ignorar o do brasil
    $.get(repo_url + 'web/' + filename + extension, function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[current_index].replace(regex, '').split(" ");
        $(".forecast_min").text(current_data[1]);
        $(".forecast_max").text(current_data[2]);
        $(".forecast_data").text(current_data[3]);
    });

    // grafico
    if ($(".placeholder_svg").length) updatePlaceholder(request_uf) // placeholder image
    else if ($(".responsive_iframe").length) updateWidget(request_uf); // widget
}