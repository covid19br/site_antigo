// Declaration
// "Nome do Estado" <-> "UF"
var estados =
    [
        {
            uf: "SP",
            prep: "em",
            verbose: "São Paulo"
        },
        {
            uf: "RJ",
            prep: "no",
            verbose: "Rio de Janeiro"
        },
        {
            uf: "br",
            prep: "no",
            verbose: "Brasil",
        },
        {
            uf: "AC",
            prep: "no",
            verbose: "Acre"
        },
        {
            uf: "AL",
            prep: "em",
            verbose: "Alagoas"
        },
        {
            uf: "AP",
            prep: "no",
            verbose: "Amapá"
        },
        {
            uf: "AM",
            prep: "no",
            verbose: "Amazonas"
        },
        {
            uf: "BA",
            prep: "na",
            verbose: "Bahia"
        },
        {
            uf: "CE",
            prep: "no",
            verbose: "Ceará"
        },
        {
            uf: "DF",
            prep: "no",
            verbose: "Distrito Federal"
        },
        {
            uf: "ES",
            prep: "em",
            verbose: "Espírito Santo"
        },
        {
            uf: "GO",
            prep: "em",
            verbose: "Goiás"
        },
        {
            uf: "MA",
            prep: "no",
            verbose: "Maranhão"
        },
        {
            uf: "MT",
            prep: "em",
            verbose: "Mato Grosso"
        },
        {
            uf: "MS",
            prep: "em",
            verbose: "Mato Grosso do Sul"
        },
        {
            uf: "MG",
            prep: "em",
            verbose: "Minas Gerais"
        },
        {
            uf: "PA",
            prep: "no",
            verbose: "Pará"
        },
        {
            uf: "PB",
            prep: "na",
            verbose: "Paraíba"
        },
        {
            uf: "PR",
            prep: "no",
            verbose: "Paraná"
        },
        {
            uf: "PE",
            prep: "em",
            verbose: "Pernambuco"
        },
        {
            uf: "PI",
            prep: "no",
            verbose: "Piauí"
        },
        {
            uf: "RN",
            prep: "no",
            verbose: "Rio Grande do Norte"
        },
        {
            uf: "RS",
            prep: "no",
            verbose: "Rio Grande do Sul"
        },
        {
            uf: "RO",
            prep: "em",
            verbose: "Rondônia"
        },
        {
            uf: "RR",
            prep: "em",
            verbose: "Roraima"
        },
        {
            uf: "SC",
            prep: "em",
            verbose: "Santa Catarina"
        },
        {
            uf: "SE",
            prep: "em",
            verbose: "Sergipe"
        },
        {
            uf: "TO",
            prep: "em",
            verbose: "Tocantins"
        }
    ];

function getUFCode(verbose) {
    for (i = 0; i < estados.length; i++) {
        if(estados[i].verbose == verbose) return(estados[i].uf);
    }

    // UF not found: returns to SP
    return("SP");
}

function getVerbose(uf) {
    for (i = 0; i < estados.length; i++) {
        if(estados[i].uf == uf) return(estados[i].verbose);
    }

    // UF not found: returns to SP
    return("SP");
}

function getCurrentUF() {
    var current = $("#page-title").text()
    return(getUFCode(current));
}

function getPreposicao(verbose) {
    for (i = 0; i < estados.length; i++) {
        if(estados[i].verbose == verbose) return(estados[i].prep);
    }

    return("em");
}

function hasUF(split_src) {
    // verifica se existe codigo uf no penultimo index
    for (i = 0; i < estados.length; i++) {
        if(estados[i].uf == split_src[(split_src.length - 2)]) return(true);
    }
    
    return(false);
}

function setActive(active) {
    // cleans
    $(".dropdown-item").removeClass("active");
    
    // updates
    var selector = ".dropdown-item:contains(" + active + ")";
    $(selector).addClass("active");
}

function setRequest(uf) {
    state = getVerbose(uf);

    // Updates text
    $("#page-title").text(state);
    $(".card-state-text").text(getPreposicao(state) + " " + state);

    // Updates dropdown
    setActive(state);
}

function updateWidget() {
    // Get Current State
    const current_uf = getCurrentUF();

    // Get Widget's SRCs
    var widget_src = $("iframe").attr("src");

    // Process Current Graph's SRC
    var split_src = widget_src.split('.');

    // remove UF
    var new_src = "";

    // change UF
    for(i=0; i<split_src.length; i++) {
        if(i == (split_src.length - 2)) {
            new_src = new_src + "." + current_uf;
        }
        else {
            if(i==0) {
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

function updateStatic() {
    // Get Current State
    const current_uf = getCurrentUF();

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
    if(hasUF(split_src)) {
        for(i=0; i<split_src.length; i++) {
            if(i == (split_src.length - 2)) {
                new_src = new_src + "." + current_uf;
                new_svg = new_svg + "." + current_uf;
            }
            else {
                if(i==0) {
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
        for(i=0; i<split_src.length; i++) {
            if(i == (split_src.length - 2)) {
                new_src = new_src + "." + split_src[i] + "." + current_uf;
                new_svg = new_svg + "." + split_svg[i] + "." + current_uf;
            }
            else {
                if(i==0) {
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

/* Main */

// First Load
// Sets requested state on #page-title via hash URL
var requested = $(location).attr('hash').substring(1);
if(requested.length == 2) setRequest(requested);

// Updates states based on #page-title
updateStatic();

// JQuery OnClick Update
$(".dropdown-item").click(function () {
    // se nao eh o item atual
    if(!$(this).hasClass("active")) {
        var state = $(this).text();
        
        // troca o titulo o card-text
        $("#page-title").text(state);
        $(".card-state-text").text(getPreposicao(state) + " " + state);

        // troca o estado ativo
        setActive(state);
    
        // troca os gráficos
        if($(".placeholder_svg").length) updateStatic();

        // atualiza o iframe
        else updateWidget();
    }
})