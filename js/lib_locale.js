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

function hasModelogro(uf) {
    for (c = 0; c < locale.length; c++) {
        if (locale[c].uf == uf) return (locale[c].has_modelogro);
    }

    // UF not found: returns to default
    console.log("hasModelogro(): uf not found "+uf);
    return (false);
}

function basename(path) {
    return path.split(/[\\/]/).pop();
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
        $.get(repo_url + 'web/' + filename + extension, function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".forecast_min").text(current_data[1]);
            $(".forecast_max").text(current_data[2]);
            $(".forecast_data").text(current_data[3]);
        });

        // grafico
        if ($(".placeholder_svg").length) updatePlaceholder(current_uf) // placeholder image
        else if ($(".responsive_iframe").length) updateWidget(current_uf); // widget
    }

    // municipios.html e DRS.html
    if(page_id == "municipios" || page_id == "DRS") {
        var UF, municipio;
        [UF, municipio] = current_uf.split('-');
        folder_mun = page_id + "/" + UF + "/" + municipio + "/";
        url_muni = repo_url + "web/" + folder_mun;

        // data e hora
        updateDate(folder_mun + "last.update");
        
        // forecast_exp_covid (graves)
        $.get(url_muni + 'data_forecast_exp_covid.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".nowcast_covid_min").text(current_data[1]);
            $(".nowcast_covid_max").text(current_data[2]);
            $(".nowcast_data").text(current_data[3]);
        });
        // forecast_exp_srag (graves)
        $.get(url_muni + 'data_forecast_exp_srag.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".nowcast_srag_min").text(current_data[1]);
            $(".nowcast_srag_max").text(current_data[2]);
        });
        // forecast_exp_covid (obitos)
        $.get(url_muni + 'data_forecast_exp_obitos_covid.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".nowcast_ob_covid_min").text(current_data[1]);
            $(".nowcast_ob_covid_max").text(current_data[2]);
            $(".nowcast_ob_data").text(current_data[3]);
        });
        // forecast_exp_srag (obitos)
        $.get(url_muni + 'data_forecast_exp_obitos_srag.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".nowcast_ob_srag_min").text(current_data[1]);
            $(".nowcast_ob_srag_max").text(current_data[2]);
        });        
        // tempo_dupli_covid (casos)
        $.get(url_muni + 'data_tempo_dupli_covid.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".tempo_dupli_covid_min").text(current_data[1]);
            $(".tempo_dupli_covid_max").text(current_data[2]);
        });
        // tempo_dupli_srag (casos)
        $.get(url_muni + 'data_tempo_dupli_srag.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".tempo_dupli_srag_min").text(current_data[1]);
            $(".tempo_dupli_srag_max").text(current_data[2]);
        });
        // tempo_dupli_covid (obitos)
        $.get(url_muni + 'data_tempo_dupli_obitos_covid.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".tempo_dupli_ob_covid_min").text(current_data[1]);
            $(".tempo_dupli_ob_covid_max").text(current_data[2]);
        });
        // tempo_dupli_srag (obitos)
        $.get(url_muni + 'data_tempo_dupli_obitos_srag.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".tempo_dupli_ob_srag_min").text(current_data[1]);
            $(".tempo_dupli_ob_srag_max").text(current_data[2]);
        });
        // RE_covid (taxa)
        $.get(url_muni + 'data_Re_covid.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".re_min_covid").text(current_data[1]);
            $(".re_max_covid").text(current_data[2]);
            if(current_data[1] >= 1) $(".re_analise_covid").text("O limite mínimo do intervalo de confiança está acima de um, indicando que a epidemia de continua em expansão rápida.");
            else if(current_data[2] < 1) $(".re_analise_covid").text("No entanto, o limite máximo do intervalo de confiança está abaixo de um, indicando que a epidemia está em declínio");
            else $(".re_analise_covid").text("O limiar de 1 está dentro do intervalo de confiança, ou seja, Re pode ser maior ou menor que 1, então a epidemia pode estar em lento declínio ou expansão");
        });
        // RE_srag (taxa)
        $.get(url_muni + 'data_Re_srag.csv', function (raw_data) {
            full_data = raw_data.split("\n");
            current_data = full_data[current_index].replace(regex, '').split(" ");
            $(".re_min_srag").text(current_data[1]);
            $(".re_max_srag").text(current_data[2]);
            if (current_data[1] >= 1) $(".re_analise_srag").text("O limite mínimo do intervalo de confiança está acima de um, indicando que a epidemia de continua em expansão rápida.");
            else if (current_data[2] < 1) $(".re_analise_srag").text("No entanto, o limite máximo do intervalo de confiança está abaixo de um, indicando que a epidemia está em declínio");
            else $(".re_analise_srag").text("O limiar de 1 está dentro do intervalo de confiança, ou seja, Re pode ser maior ou menor que 1, então a epidemia pode estar em lento declínio ou expansão");
        });

        // atualiza os gráficos por departamento//municipio
        // placeholders
        if ($(".placeholder_svg").length) {
            $(".codegena_iframe:not(.responsive_iframe)").each(function () {
                var new_src = "./web/" + folder_mun + basename($(this).attr("data-src"));
                $(this).attr("data-src", new_src);
            })
            $(".placeholder_svg").each(function () {
                var new_svg = "./web/" + folder_mun + basename($(this).attr("src"));
                $(this).attr("src", new_svg);
            })
            $("source[media='(max-width: 575.98px)']").each(function () {
                var new_src = "./web/" + folder_mun + basename($(this).attr("srcset"));
                $(this).attr("srcset", new_src);
            })
            $("source[media='(max-width: 767.98px)']").each(function () {
                var new_src = "./web/" + folder_mun + basename($(this).attr("srcset"));
                $(this).attr("srcset", new_src);
            })
            $("source[media='(max-width: 991.98px)']").each(function () {
                var new_src = "./web/" + folder_mun + basename($(this).attr("srcset"));
                $(this).attr("srcset", new_src);
            })
            $("source[media='(max-width: 1199.98px)']").each(function () {
                var new_src = "./web/" + folder_mun + basename($(this).attr("srcset"));
                $(this).attr("srcset", new_src);
            })
        }

        // widget interativo
        if ($(".responsive_iframe").length) {
            $(".responsive_iframe > iframe").each(function () {
                var new_src = "./web/" + folder_mun + basename($(this).attr("src"));
                $(this).attr("src", new_src);
            })
        }

        // desabilita modelogro seletivamente
        if (!hasModelogro(current_uf)) {
            // atualiza aba
            if ($(".nav-item.aba-pill > .nav-link[card-id='aba2']").hasClass("active")) updateExibition("aba1");
            if (history.pushState) updateURL();

            // atualiza botao
            $(".nav-item.aba-pill > .nav-link[card-id='aba2']").addClass("disabled").attr("href", "");
            $(".nav-item.aba-pill").has(".disabled").addClass("disabled");
        }
        else {
            $(".nav-item.aba-pill > .nav-link[card-id='aba2']").removeClass("disabled").attr("href", "#");
            $(".nav-item.aba-pill").removeClass("disabled");
        }

    }
}