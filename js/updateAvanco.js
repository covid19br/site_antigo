const def_state_uf ='br';
const def_state_verb ='Brasil';

const estados =
    [
        {
            uf: "br",
            prep: "no",
            verbose: "Brasil",
        },
        {
            uf: "ac",
            prep: "no",
            verbose: "Acre"
        },
        {
            uf: "al",
            prep: "em",
            verbose: "Alagoas"
        },
        {
            uf: "am",
            prep: "no",
            verbose: "Amazonas"
        },
        {
            uf: "ap",
            prep: "no",
            verbose: "Amapá"
        },
        {
            uf: "ba",
            prep: "na",
            verbose: "Bahia"
        },
        {
            uf: "ce",
            prep: "no",
            verbose: "Ceará"
        },
        {
            uf: "df",
            prep: "no",
            verbose: "Distrito Federal"
        },
        {
            uf: "es",
            prep: "em",
            verbose: "Espírito Santo"
        },
        {
            uf: "go",
            prep: "em",
            verbose: "Goiás"
        },
        {
            uf: "ma",
            prep: "no",
            verbose: "Maranhão"
        },
        {
            uf: "mg",
            prep: "em",
            verbose: "Minas Gerais"
        },
        {
            uf: "ms",
            prep: "em",
            verbose: "Mato Grosso do Sul"
        },
        {
            uf: "mt",
            prep: "em",
            verbose: "Mato Grosso"
        },
        {
            uf: "pa",
            prep: "no",
            verbose: "Pará"
        },
        {
            uf: "pb",
            prep: "na",
            verbose: "Paraíba"
        },
        {
            uf: "pe",
            prep: "em",
            verbose: "Pernambuco"
        },
        {
            uf: "pi",
            prep: "no",
            verbose: "Piauí"
        },
        {
            uf: "pr",
            prep: "no",
            verbose: "Paraná"
        },
        {
            uf: "rj",
            prep: "no",
            verbose: "Rio de Janeiro"
        },
        {
            uf: "rn",
            prep: "no",
            verbose: "Rio Grande do Norte"
        },
        {
            uf: "ro",
            prep: "em",
            verbose: "Rondônia"
        },
        {
            uf: "rr",
            prep: "em",
            verbose: "Roraima"
        },
        {
            uf: "rs",
            prep: "no",
            verbose: "Rio Grande do Sul"
        },
        {
            uf: "sc",
            prep: "em",
            verbose: "Santa Catarina"
        },
        {
            uf: "se",
            prep: "em",
            verbose: "Sergipe"
        },
        {
            uf: "sp",
            prep: "em",
            verbose: "São Paulo"
        },
        {
            uf: "to",
            prep: "em",
            verbose: "Tocantins"
        }
    ];

function hasUF(split_src) {
    // verifica se existe codigo uf no penultimo index
    for (a = 0; a < estados.length; a++) {
        if (estados[a].uf == split_src[(split_src.length - 2)]) return (true);
    }

    return (false);
}

function getIndex(uf) {
    if(uf == 'br') return (0);
    for (b = 0; b < estados.length; b++) {
        if (estados[b].uf == uf) return (b-1); // move um index para cima para ignorar o index do brasil
    }

    // UF not found: returns to SP
    return (0);
}

function getVerbose(uf) {
    for (c = 0; c < estados.length; c++) {
        if (estados[c].uf == uf) return (estados[c].verbose);
    }

    // UF not found: returns to default
    console.log("getVerbose(): uf not found "+uf);
    return (def_state_verb);
}

function getPreposition(uf) {
    for (d = 0; d < estados.length; d++) {
        if (estados[d].uf == uf) return (estados[d].prep);
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
            if(!hasUF(split_svg)) {
                new_src = new_src + "." + split_src[i] + "." + current_uf;
                new_svg = new_svg + "." + split_svg[i] + "." + current_uf;
            }
            else {
                new_src = new_src + "." + current_uf;
                new_svg = new_svg + "." + current_uf;
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
    isBrasil = false;
    if(current_uf == 'br') isBrasil = true;

    // titulo
    $("#page-title").text(current_state);

    // dropdown
    $(".dropdown-item").removeClass("active"); // cleans
    $(".dropdown-item").filter(function(){
        return $(this).text() === current_state;
    }).addClass("active"); // updates

    // data e hora
    updateDate('last.update.estado');

    // conteudo dinamico
    // nome do estado
    $(".estado").text(current_state);
    $(".estado-prep").text(current_prepo+" "+current_state);
    
    const regex = /"/gi;
    // forecast_exp
    // variables
    var filename = 'data_forecast_exp'
    var extension = '_estados.csv';
    if(isBrasil) extension = '_br.csv';
    $.get('https://raw.githubusercontent.com/covid19br/covid19br.github.io/master/web/' + filename + extension, function (raw_data) {
        full_data = raw_data.split("\n");
        current_data = full_data[current_index].replace(regex, '').split(" ");
        $(".forecast_min").text(current_data[1]);
        $(".forecast_max").text(current_data[2]);
        $(".forecast_data").text(current_data[3]);
    });
    // grafico
    if ($(".placeholder_svg").length) updatePlaceholder(current_uf) // placeholder image
    else updateWidget(current_uf); // widget

}

/* Main */
/* 1. Atualiza Estado */

// Via HASH REQUEST
var requested = $(location).attr('hash').substring(1);
if (requested.length == 2) updatePage(requested); //uf
// Via DEFAULT
else updatePage(def_state_uf); //se a entrada é sem hash atualiza para o municipio default

// JQuery OnClick Update
$('.dropdown-item').click(function () {
    // se nao eh o item atual
    if (!$(this).hasClass('active')) {
        var current_uf = $(this).attr('href').substring(1);
        updatePage(current_uf);
    }
})
