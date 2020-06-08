function basename(path) {
    return path.split(/[\\/]/).pop();
}

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

function isMun(request) {
    var b = 0;
    // verifica se existe codigo uf
    for (b = 0; b < locale.length; b++) {
        if (locale[b].mun == request) return (true);
    }

    // UF not found
    console.log("isMun(): mun not found "+request);
    return (false);
}

function isPair(uf, mun) {
    var c = 0;
    for (c = 0; c < locale.length; c++) {
        if (locale[c].mun == mun && locale[c].uf == uf) return (true);
    }

    // pair not found: returns to default
    console.log("isPair(): pair not found "+uf+ " "+mun);
    return (false);
}

function getFirstUF(mun) {
    var d = 0;
    for (d = 0; d < locale.length; d++) {
        if (locale[d].mun == mun) return (locale[d].uf);
    }

    // mun not found: returns to default
    console.log("getFirstUF(): mun not found "+mun);
    return (default_uf);
}

function getFirstMun(uf) {
    var e = 0;
    for (e = 0; e < locale.length; e++) {
        if (locale[e].uf == uf) return (locale[e].mun);
    }

    // mun not found: returns to default
    console.log("getFirstMun(): uf not found "+uf);
    return (default_mun);
}

function getVerbose(mun) {
    var f = 0;
    for (f = 0; f < locale.length; f++) {
        if (locale[f].mun == mun) return (locale[f].verbose);
    }

    // UF not found: returns to default
    console.log("getVerbose(): mun not found "+mun);
    return (default_verb);
}

function getPreposition(mun) {
    var g = 0;
    for (g = 0; g < locale.length; g++) {
        if (locale[g].mun == mun) return (locale[g].prep);
    }

    // UF not found: returns to default
    console.log("getPreposition(): uf not found "+mun);
    return ("em");
}

function hasModelogro(mun) {
    var h = 0;
    for (h = 0; h < locale.length; h++) {
        if (locale[h].mun == mun) return (locale[h].has_modelogro);
    }

    // UF not found: returns to default
    console.log("hasModelogro(): mun not found "+mun);
    return (false);
}

function hasTempoDupli(mun) {
    var i = 0;
    for (i = 0; i < locale.length; i++) {
        if (locale[i].mun == mun) return (locale[i].has_td);
    }

    // UF not found: returns to default
    console.log("hasTempoDupli(): mun not found "+mun);
    return (false);
}

function updatePage(request_uf, request_mun) {
    /* comportamento: atualiza conteudo dinamico de acordo com o municipio id */
    var request_mun_verbose = getVerbose(request_mun);
    var request_mun_prepo   = getPreposition(request_mun);
    var repo_url = 'https://raw.githubusercontent.com/covid19br/covid19br.github.io/master/';

    // titulo
    $("#page-title").text(request_mun_verbose);

    // dropdown
    $(".main-title>.dropdown>.dropdown-menu>.dropdown-item").removeClass("active"); // cleans
    $(".main-title>.dropdown>.dropdown-menu>.dropdown-item").filter(function () {
        return $(this).text() === request_mun_verbose;
    }).addClass("active"); // updates

    // conteudo dinamico
    // nome do local
    $(".locale").text(request_mun_verbose);
    $(".prep").text(request_mun_prepo );
    $(".locale-prep").text(request_mun_prepo  + " " + request_mun_verbose);

    const regex = /"/gi;

    // municipios.html e DRS.html

    folder_mun = page_id + "/" + request_uf + "/" + request_mun + "/";
    url_muni = repo_url + "web/" + folder_mun;

    // data e hora
    updateDate(folder_mun + "last.update");

    // forecast_exp_covid (graves)
    $.get(url_muni + 'data_forecast_exp_covid.csv', function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[0].replace(regex, '').split(" ");
        $(".nowcast_covid_min").text(current_data[1]);
        $(".nowcast_covid_max").text(current_data[2]);
        $(".nowcast_data").text(current_data[3]);
    });
    // forecast_exp_srag (graves)
    $.get(url_muni + 'data_forecast_exp_srag.csv', function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[0].replace(regex, '').split(" ");
        $(".nowcast_srag_min").text(current_data[1]);
        $(".nowcast_srag_max").text(current_data[2]);
    });
    // forecast_exp_covid (obitos)
    $.get(url_muni + 'data_forecast_exp_obitos_covid.csv', function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[0].replace(regex, '').split(" ");
        $(".nowcast_ob_covid_min").text(current_data[1]);
        $(".nowcast_ob_covid_max").text(current_data[2]);
        $(".nowcast_ob_data").text(current_data[3]);
    });
    // forecast_exp_srag (obitos)
    $.get(url_muni + 'data_forecast_exp_obitos_srag.csv', function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[0].replace(regex, '').split(" ");
        $(".nowcast_ob_srag_min").text(current_data[1]);
        $(".nowcast_ob_srag_max").text(current_data[2]);
    });
    // tempo_dupli_covid (casos)
    $.get(url_muni + 'data_tempo_dupli_covid.csv', function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[0].replace(regex, '').split(" ");
        $(".tempo_dupli_covid_min").text(current_data[1]);
        $(".tempo_dupli_covid_max").text(current_data[2]);
    });
    // tempo_dupli_srag (casos)
    $.get(url_muni + 'data_tempo_dupli_srag.csv', function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[0].replace(regex, '').split(" ");
        $(".tempo_dupli_srag_min").text(current_data[1]);
        $(".tempo_dupli_srag_max").text(current_data[2]);
    });
    // tempo_dupli_covid (obitos)
    $.get(url_muni + 'data_tempo_dupli_obitos_covid.csv', function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[0].replace(regex, '').split(" ");
        $(".tempo_dupli_ob_covid_min").text(current_data[1]);
        $(".tempo_dupli_ob_covid_max").text(current_data[2]);
    });
    // tempo_dupli_srag (obitos)
    $.get(url_muni + 'data_tempo_dupli_obitos_srag.csv', function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[0].replace(regex, '').split(" ");
        $(".tempo_dupli_ob_srag_min").text(current_data[1]);
        $(".tempo_dupli_ob_srag_max").text(current_data[2]);
    });
    // RE_covid (taxa)
    $.get(url_muni + 'data_Re_covid.csv', function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[0].replace(regex, '').split(" ");
        $(".re_min_covid").text(current_data[1]);
        $(".re_max_covid").text(current_data[2]);
        if (current_data[1] >= 1) $(".re_analise_covid").text("O limite mínimo do intervalo de confiança está acima de um, indicando que a epidemia de continua em expansão rápida.");
        else if (current_data[2] < 1) $(".re_analise_covid").text("No entanto, o limite máximo do intervalo de confiança está abaixo de um, indicando que a epidemia está em declínio");
        else $(".re_analise_covid").text("O limiar de 1 está dentro do intervalo de confiança, ou seja, Re pode ser maior ou menor que 1, então a epidemia pode estar em lento declínio ou expansão");
    });
    // RE_srag (taxa)
    $.get(url_muni + 'data_Re_srag.csv', function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[0].replace(regex, '').split(" ");
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
            if ($(this).hasClass("hospt"))
                var new_src = "./web/projecao_leitos/" + folder_mun + basename($(this).attr("data-src"));
            else
                var new_src = "./web/" + folder_mun + basename($(this).attr("data-src"));
            $(this).attr("data-src", new_src);
        })
        $(".placeholder_svg").each(function () {
            if ($(this).hasClass("hospt"))
                var new_svg = "./web/projecao_leitos/" + folder_mun + basename($(this).attr("src"));
            else
                var new_svg = "./web/" + folder_mun + basename($(this).attr("src"));
            $(this).attr("src", new_svg);
        })
        $("source[media='(max-width: 575.98px)']").each(function () {
            if ($(this).hasClass("hospt"))
                var new_src = "./web/projecao_leitos/" + folder_mun + basename($(this).attr("srcset"));
            else
                var new_src = "./web/" + folder_mun + basename($(this).attr("srcset"));
            $(this).attr("srcset", new_src);
        })
        $("source[media='(max-width: 767.98px)']").each(function () {
            if ($(this).hasClass("hospt"))
                var new_src = "./web/projecao_leitos/" + folder_mun + basename($(this).attr("srcset"));
            else
                var new_src = "./web/" + folder_mun + basename($(this).attr("srcset"));
            $(this).attr("srcset", new_src);
        })
        $("source[media='(max-width: 991.98px)']").each(function () {
            if ($(this).hasClass("hospt"))
                var new_src = "./web/projecao_leitos/" + folder_mun + basename($(this).attr("srcset"));
            else
                var new_src = "./web/" + folder_mun + basename($(this).attr("srcset"));
            $(this).attr("srcset", new_src);
        })
        $("source[media='(max-width: 1199.98px)']").each(function () {
            if ($(this).hasClass("hospt"))
                var new_src = "./web/projecao_leitos/" + folder_mun + basename($(this).attr("srcset"));
            else
                var new_src = "./web/" + folder_mun + basename($(this).attr("srcset"));
            $(this).attr("srcset", new_src);
        })
    }

    // widget interativo
    if ($(".responsive_iframe").length) {
        $(".responsive_iframe > iframe").each(function () {
            if ($(this).hasClass("hospt"))
                var new_src = "./web/projecao_leitos/" + folder_mun + basename($(this).attr("src"));
            else
                var new_src = "./web/" + folder_mun + basename($(this).attr("src"));
            $(this).attr("src", new_src);
        })
    }

    // desabilita modelogro seletivamente (ABA4)
    if (!hasModelogro(request_mun)) {
        // atualiza aba
        if ($(".nav-item.aba-pill > .nav-link[card-id='aba4']").hasClass("active")) updateExibition("aba1");
        if (history.pushState) updateURL();

        // atualiza botao
        $(".nav-item.aba-pill > .nav-link[card-id='aba4']").addClass("disabled").attr("href", "");
        $(".nav-item.aba-pill").has(".disabled").addClass("disabled");
    }
    else {
        $(".nav-item.aba-pill > .nav-link[card-id='aba4']").removeClass("disabled").attr("href", "#");
        $(".nav-item.aba-pill").removeClass("disabled");
    }

    // desabilita Tempo de Duplicacao seletivamente (ABA5)
    if (!hasTempoDupli(request_mun)) {
        // atualiza aba
        if ($(".nav-item.aba-pill > .nav-link[card-id='aba5']").hasClass("active")) updateExibition("aba1");
        if (history.pushState) updateURL();

        // atualiza botao
        $(".nav-item.aba-pill > .nav-link[card-id='aba5']").addClass("disabled").attr("href", "");
        $(".nav-item.aba-pill").has(".disabled").addClass("disabled");
    }
    else {
        $(".nav-item.aba-pill > .nav-link[card-id='aba5']").removeClass("disabled").attr("href", "#");
        $(".nav-item.aba-pill").removeClass("disabled");
    }

    // página sobre SP
    if (request_mun == "Sao_Paulo" & request_uf == "SP")
        $("#sobre-gt-sp").show();
    else
        $("#sobre-gt-sp").hide();


}