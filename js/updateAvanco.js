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
            uf: "sp",
            prep: "em",
            verbose: "São Paulo"
        },
        {
            uf: "rj",
            prep: "no",
            verbose: "Rio de Janeiro"
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
            uf: "ap",
            prep: "no",
            verbose: "Amapá"
        },
        {
            uf: "am",
            prep: "no",
            verbose: "Amazonas"
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
            uf: "mt",
            prep: "em",
            verbose: "Mato Grosso"
        },
        {
            uf: "ms",
            prep: "em",
            verbose: "Mato Grosso do Sul"
        },
        {
            uf: "mg",
            prep: "em",
            verbose: "Minas Gerais"
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
            uf: "pr",
            prep: "no",
            verbose: "Paraná"
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
            uf: "rn",
            prep: "no",
            verbose: "Rio Grande do Norte"
        },
        {
            uf: "rs",
            prep: "no",
            verbose: "Rio Grande do Sul"
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
            uf: "to",
            prep: "em",
            verbose: "Tocantins"
        }
    ];

function hasUF(split_src) {
    // verifica se existe codigo uf no penultimo index
    for (i = 0; i < estados.length; i++) {
        if (estados[i].uf == split_src[(split_src.length - 2)]) return (true);
    }

    return (false);
}

function getIndex(uf) {
    if(uf == 'br') return (0);
    for (i = 0; i < estados.length; i++) {
        if (estados[i].uf == uf) return (i-1); // move um index para cima para ignorar o index do brasil
    }

    // UF not found: returns to BR
    return (0);
}

function getVerbose(uf) {
    for (i = 0; i < estados.length; i++) {
        if (estados[i].uf == uf) return (estados[i].verbose);
    }

    // UF not found: returns to default
    console.log("getVerbose(): uf not found "+uf);
    return (def_state_verb);
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
    if (hasUF(split_src)) {
            for (i = 0; i < split_src.length; i++) {
                if (i == (split_src.length - 2)) {
                    new_src = new_src + "." + current_uf;
                    new_svg = new_svg + "." + current_uf;
                }
                else {
                    if (i == 0) {
                        new_src = new_src + split_src[i];
                        new_svg = new_svg + split_svg[i];
                    }
                    else {
                        new_src = new_src + "." + split_src[i];
                        new_svg = new_svg + "." + split_svg[i];
                    }
                }
            }
    }
    else {
            for (i = 0; i < split_src.length; i++) {
                if (i == (split_src.length - 2)) {
                    new_src = new_src + "." + split_src[i] + "." + current_uf;
                    new_svg = new_svg + "." + split_svg[i] + "." + current_uf;
                }
                else {
                    if (i == 0) {
                        new_src = new_src + split_src[i];
                        new_svg = new_svg + split_svg[i];
                    }
                    else {
                        new_src = new_src + "." + split_src[i];
                        new_svg = new_svg + "." + split_svg[i];
                    }
                }
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
    for (i = 0; i < split_src.length; i++) {
        if (i == (split_src.length - 2)) {
            new_src = new_src + "." + current_uf;
        }
        else {
            if (i == 0) {
                new_src = new_src + split_src[i];
            }
            else {
                new_src = new_src + "." + split_src[i];
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
    isBrasil = false;
    if(current_index == 'br') isBrasil = true;

    // titulo
    $("#page-title").text(current_state);

    // dropdown
    $(".dropdown-item").removeClass("active"); // cleans
    var selector = ".dropdown-item:contains(" + current_state + ")"; // updates
    $(selector).addClass("active"); // updates

    // data e hora
    updateDate('last.update.estado');

    // conteudo dinamico
    // nome do estado
    $(".estado").text(current_state);
    
    const regex = /"/gi;
    // forecast_exp
    // variables
    var filename = 'data_forecast_exp'
    var extension = '_estados.csv';
    if(isBrasil) extension = '_br.csv';
    $.get('https://raw.githubusercontent.com/covid19br/covid19br.github.io/webdesign/web/' + filename + extension, function (raw_data) {
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
else updatePage(def_state_id); //se a entrada é sem hash atualiza para o municipio default

// JQuery OnClick Update
$('.dropdown-item').click(function () {
    // se nao eh o item atual
    if (!$(this).hasClass('active')) {
        var current_uf = $(this).attr('href').substring(1);
        updatePage(current_uf);
    }
})
