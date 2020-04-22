/* Data Structures */
const def_mun_id = "sp_sp";
const municipios =
    [
        {
            id: "sp_sp",
            verbose: "São Paulo"
        }
    ];

function getIndex(id) {
    for (i = 0; i < municipios.length; i++) {
        if (municipios[i].id == id) return (i); // move um index para cima para ignorar o index do brasil
    }

    // UF not found: returns to BR
    return (0);
}

function getVerbose(id) {
    for (i = 0; i < municipios.length; i++) {
        if (municipios[i].id == id) return (municipios[i].verbose);
    }

    // UF not found: returns to default
    console.log("getVerbose(): id not found");
    return (def_mun_id);
}

function getId(verbose) {
    for (i = 0; i < municipios.length; i++) {
        if (municipios[i].verbose == verbose) return (municipios[i].id);
    }

    // UF not found: returns to default
    console.log("getId(): verbose not found");
    return ("São Paulo");
}

/* Functions */
function jquery_replace(attr, abstract, concrete) {
    $(attr).each(function(index) {
        original_text = $(this).html();
        updated_text = original_text.replace(abstract, concrete);
        $(this).html(updated_text);
    });
}

function updatePage(current_id) {
    /* comportamento: atualiza conteudo dinamico de acordo com o municipio id */
    var current_state = getVerbose(current_id);
    var current_index = getIndex(current_id);
    // titulo
    $("#page-title").text(current_state);

    // dropdown
    // cleans
    $(".dropdown-item").removeClass("active");

    // updates
    var selector = ".dropdown-item:contains(" + current_state + ")";
    $(selector).addClass("active");

    // data e hora
    updateDate("last.update.municipio");

    // conteudo dinamico
    // nome do municipio
    classes_to_update = ['.card-title', '.card-text', '.text-justify'];
    for(i = 0; i < classes_to_update.length; i++) jquery_replace(classes_to_update[i],"$municipio", current_state);

    // forecast_exp (hospital)
    $.get('https://raw.githubusercontent.com/covid19br/covid19br.github.io/webdesign/web/data_forecasr_exp_municipios.csv', function (raw_data) {
        var regex = /"/gi;
        full_data = raw_data.split("\n");
        current_data = full_data[current_index].replace(regex, '').split(" ");
        jquery_replace('.forecast_exp',"$forecast_min", current_data[1]);
        jquery_replace('.forecast_exp',"$forecast_max", current_data[2]);
        jquery_replace('.forecast_exp',"$forecast_data", current_data[3]);
    });

    // tempo_dupli (velocidade)
    $.get('https://raw.githubusercontent.com/covid19br/covid19br.github.io/webdesign/web/data_tempo_dupli_municipios.csv', function (raw_data) {
        var regex = /"/gi;
        full_data = raw_data.split("\n");
        current_data = full_data[current_index].replace(regex, '').split(" ");
        jquery_replace('.tempo_dupli',"$tempo_dupli_min", current_data[1]);
        jquery_replace('.tempo_dupli',"$tempo_dupli_max", current_data[2]);
    });

    // RE (taxa)
    $.get('https://raw.githubusercontent.com/covid19br/covid19br.github.io/webdesign/web/data_Re_municipios.csv', function (raw_data) {
        var regex = /"/gi;
        full_data = raw_data.split("\n");
        current_data = full_data[current_index].replace(regex, '').split(" ");
        jquery_replace('.re',"$re_min", current_data[1]);
        jquery_replace('.re',"$re_max", current_data[2]);
        if(current_data[1] >= 1) jquery_replace('.re',"$re_analise", "Mas mesmo o limite mínimo do intervalo de confiança está acima de um, indicando que a epidemia continua em expansão rápida.");
        else if(current_data[2] < 1) jquery_replace('.re',"$re_analise", "No entanto, mesmo o limite máximo do intervalo de confiança está abaixo de um, indicando que a epidemia está em declínio");
        else jquery_replace('.re',"$re_analise", "O limiar de 1 está dentro do intervalo de confiança, ou seja, $R_e$ pode ser maior ou menor que 1, então a epidemia pode estar em lento declínio ou expansão");
    });
    
}

/* Main */
/* 1. Atualiza Municipio */

// Via HASH REQUEST
var requested = $(location).attr('hash').substring(1);
if (requested.length == 5) updatePage(requested); //xx_xx
// Via DEFAULT
else updatePage(def_mun_id); //se a entrada é sem hash atualiza para o municipio default

// JQuery OnClick Update
$(".dropdown-item").click(function () {
    // se nao eh o item atual
    if (!$(this).hasClass("active")) {
        var current_mun = $(this).text();
        updatePage(getId(current_mun));
    }
})


/* 2. Menu Dinamico */
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