/* Data Structures */
const def_mun_id = "sp_sp";
const municipios =
    [
        {
            id: "sp_sp",
            prep: "em",
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
    console.log("getVerbose(): id not found "+id);
    return (def_mun_id);
}

function getPreposition(id) {
    for (i = 0; i < municipios.length; i++) {
        if (municipios[i].id == id) return (municipios[i].prep);
    }

    // UF not found: returns to default
    console.log("getVerbose(): id not found "+id);
    return ("em");
}

function getId(verbose) {
    for (i = 0; i < municipios.length; i++) {
        if (municipios[i].verbose == verbose) return (municipios[i].id);
    }

    // UF not found: returns to default
    console.log("getId(): verbose not found "+verbose);
    return ("São Paulo");
}

/* Functions */
/* 1. Atualiza Municipio */
function updatePage(current_id) {
    /* comportamento: atualiza conteudo dinamico de acordo com o municipio id */
    var current_state = getVerbose(current_id);
    var current_index = getIndex(current_id);
    var current_prepo = getPreposition(current_id);

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
    $(".municipio").text(current_state);
    $(".municipio-prep").text(current_prepo + " " + current_state);

    const regex = /"/gi;
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
        if(current_data[1] >= 1) $(".re_analise").text("Mas mesmo o limite mínimo do intervalo de confiança está acima de um, indicando que a epidemia continua em expansão rápida.");
        else if(current_data[2] < 1) $(".re_analise").text("No entanto, mesmo o limite máximo do intervalo de confiança está abaixo de um, indicando que a epidemia está em declínio");
        else $(".re_analise").text("O limiar de 1 está dentro do intervalo de confiança, ou seja, \(R_e\) pode ser maior ou menor que 1, então a epidemia pode estar em lento declínio ou expansão");
    });
    
}

/* 2. Menu Dinamico */
function updateExibition(current) {
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
        var current_state = $(this).text();
        updatePage(getId(current_state));
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