function isUF(request) {
    // verifica se existe codigo uf no penultimo index
    for (a = 0; a < locale.length; a++) {
        if (locale[a].uf == request) return (true);
    }

    return (false);
}

function getIndex(uf) {
    if(uf == 'br') return (0);
    for (b = 0; b < locale.length; b++) {
        if (locale[b].uf == uf) return (b);
    }

    // UF not found: returns to SP/BR
    console.log("getIndex(): uf not found "+uf);
    return (0);
}

function getVerbose(uf) {
    for (c = 0; c < locale.length; c++) {
        if (locale[c].uf == uf) return (locale[c].verbose);
    }

    // UF not found: returns to default
    console.log("getVerbose(): uf not found "+uf);
    return (default_verb);
}

function getPreposition(uf) {
    for (d = 0; d < locale.length; d++) {
        if (locale[d].uf == uf) return (locale[d].prep);
    }

    // UF not found: returns to default
    console.log("getPreposition(): uf not found "+uf);
    return ("em");
}

function updatePlaceholder(current_uf) {
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
                new_src = new_src + "." + split_src[i] + "." + current_uf;
                new_svg = new_svg + "." + split_svg[i] + "." + current_uf;
                responsive = new_svg;
            }
            else {
                new_src = new_src + "." + current_uf;
                new_svg = new_svg + "." + current_uf;
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

function updateWidget(current_uf) {
    // Get Widget's SRCs
    var widget_src = $("iframe").attr("src");

    // Process Current Graph's SRC
    var split_src = widget_src.split('.');

    // remove UF
    var new_src = "";

    // change UF
    for (k = 0; k < split_src.length; k++) {
        if (k == (split_src.length - 2)) {
            new_src = new_src + "." + current_uf;
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

function updatePage(current_uf) {
    /* comportamento: atualiza conteudo dinamico de acordo com o municipio id */
    var current_state = getVerbose(current_uf);
    var current_index = getIndex(current_uf);
    var current_prepo = getPreposition(current_uf);

    // titulo
    $("#page-title").text(current_state);

    // dropdown
    $(".dropdown-item").removeClass("active"); // cleans
    $(".dropdown-item").filter(function(){
        return $(this).text() === current_state;
    }).addClass("active"); // updates

    // conteudo dinamico
    // nome do local
    $(".locale").text(current_state);
    $(".locale-prep").text(current_prepo+" "+current_state);
    
    const regex = /"/gi;
    // texto dinamico
    // progressao.html
    if(page_id == "estados") {
        // data e hora
        updateDate('last.update.estado');
        
        // forecast_exp
        var filename = 'data_forecast_exp'
        var extension = '_estados.csv';
        if(current_uf == 'br') extension = '_br.csv';
        else current_index = current_index - 1; // move um index para cima para ignorar o do brasil
        $.get('https://raw.githubusercontent.com/covid19br/covid19br.github.io/master/web/' + filename + extension, function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".forecast_min").text(current_data[1]);
            $(".forecast_max").text(current_data[2]);
            $(".forecast_data").text(current_data[3]);
        });
    }
    // municipios.html
    if(page_id == "municipios") {
        // data e hora
        updateDate("last.update.municipio");

        // forecast_exp (hospital)
        $.get('https://raw.githubusercontent.com/covid19br/covid19br.github.io/master/web/data_forecasr_exp_municipios.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".forecast_min").text(current_data[1]);
            $(".forecast_max").text(current_data[2]);
            $(".forecast_data").text(current_data[3]);
        });

        // tempo_dupli (velocidade)
        $.get('https://raw.githubusercontent.com/covid19br/covid19br.github.io/master/web/data_tempo_dupli_municipio.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".tempo_dupli_min").text(current_data[1]);
            $(".tempo_dupli_max").text(current_data[2]);
        });

        // RE (taxa)
        $.get('https://raw.githubusercontent.com/covid19br/covid19br.github.io/master/web/data_Re_municipio.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".re_min").text(current_data[1]);
            $(".re_max").text(current_data[2]);
            if(current_data[1] >= 1) $(".re_analise").text("O limite mínimo do intervalo de confiança está acima de um, indicando que a epidemia continua em expansão rápida.");
            else if(current_data[2] < 1) $(".re_analise").text("No entanto, o limite máximo do intervalo de confiança está abaixo de um, indicando que a epidemia está em declínio");
            else $(".re_analise").text("O limiar de 1 está dentro do intervalo de confiança, ou seja, \(R_e\) pode ser maior ou menor que 1, então a epidemia pode estar em lento declínio ou expansão");
        });
    }

    // grafico
    if(page_id == "estados") { // REMOVER QUANDO MUNICIPIOS TIVER OUTROS MUNICIPIOS
        if ($(".placeholder_svg").length) updatePlaceholder(current_uf) // placeholder image
        else if ($(".responsive_iframe").length)updateWidget(current_uf); // widget
    }

}