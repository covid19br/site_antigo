var urlParams;
(window.onpopstate = function () {
    var match,
        pl     = /\+/g,  // Regex for replacing addition symbol with a space
        search = /([^&=]+)=?([^&]*)/g,
        decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
        query  = window.location.search.substring(1);

    urlParams = {};
    while (match = search.exec(query))
       urlParams[decode(match[1])] = decode(match[2]);
})();

function updateURL() {
    var query = "?";
    var params = [];
    
    if($("#main-title-aba-pills").length)  params.push("aba="  + $(".aba-pill  > .nav-link.active"     ).attr("card-id"));  // aba query
    if(typeof default_uf  !== 'undefined') params.push("uf="   + $("#locale    > .dropdown-item.active").attr('uf'));       // locale uf query
    if(typeof default_mun !== 'undefined') params.push("mun="  + $("#locale    > .dropdown-item.active").attr('mun'));      // locale mun query
    if($(".acumdia").length)               params.push("q="    + $(".acumdia   > .dropdown-item.active").attr("q"));        // acumdia query

    // assemble query
    for(i = 0; i < params.length; i++) query = query + params[i] + "&";
    
    // updates URL
    window.history.pushState(null, null, query.slice(0, -1));
}

// Abas no Jumbotron
function updateAbas() {
    
    if("aba" in urlParams && ($(".aba-group").hasClass(urlParams["aba"]))) updateExibition(urlParams["aba"]); // Via QUERY REQUEST: verifica se o parametro foi passado e valida
    else updateExibition($(".nav-item.aba-pill > .active").attr("card-id")); //Via DEFAULT: usa o item ativo no html
    
    return null;
}

// Locale Dropdown
function updateLocale() {
    var hasMun = "mun" in urlParams;
    var hasUF  = "uf"  in urlParams;

    if(typeof default_mun !== 'undefined') {
        // existe de municipios na pagina
        if (hasUF && urlParams["uf"].length > 2 && urlParams["uf"].includes('-')) {
            // handles legacy URL
            var legacy_UF, legacy_mun;
            [legacy_UF, legacy_mun] = urlParams["uf"].split('-');
            updatePage(legacy_UF, legacy_mun);
        }
        else if(hasMun && isMun(urlParams["mun"])) {
            // municipio existe
            if( hasUF && isPair(urlParams["uf"], urlParams["mun"]) ) {
                // UF foi enviado e eh valido
                updatePage(urlParams["uf"], urlParams["mun"]); // Via QUERY REQUEST
            }
            else {
                // UF nao foi enviado ou eh invalido ou o par uf//mun nao eh valido
                updatePage(getFirstUF(urlParams["mun"]), urlParams["mun"]); // Via QUERY REQUEST
            }
        }
        else {
            // municipio nao existe
            if(hasUF && isUF(urlParams["uf"])) {
                // pega o primeiro mun se existe uf valido
                updatePage(urlParams["uf"], getFirstMun(urlParams["uf"])); // Via QUERY REQUEST
            }
            else if(typeof default_uf !== 'undefined') {
                // nem mun ou uf sao validos
                updatePage(default_uf, default_mun); // Via DEFAULT
            }
            else {
                console.log("updateLocale(): default_uf not found")
            }
        }
    }
    else {
        if(hasUF && isUF(urlParams["uf"])) updatePage(urlParams["uf"]);    // Via QUERY REQUEST
        else if(typeof default_uf !== 'undefined') updatePage(default_uf); // Via DEFAULT
    } 
}

// Acumulado-Diario Dropdown
function updateDropdowns() {
    if("q" in urlParams && (urlParams["q"] == "acu" || urlParams["q"] == "dia")) updateAcumDia(urlParams["q"]); // Via QUERY REQUEST: verifica se existe o parametro e valida
    else if($(".acumdia > .dropdown-item").length) updateAcumDia($(".acumdia > .dropdown-item.active").attr("q")); // Via DEFAULT: se a entrada é sem hash atualiza pelo ativo
}

// Window load update
$(document).ready ( function(){
    if(typeof locale !== 'undefined')               updateLocale();    // Locale: verifica se a pagina tem dados de locale
    if($("#main-title-aba-pills").length)           updateAbas();      // Abas: verifica se a pagina tem abas
    if($('.dropdown-toggle').not('#titleDropdown')) updateDropdowns(); // Dropdowns: verifica se a pagina tem dropdowns (que nao sejam o de locale)
    if(history.pushState)                           updateURL();       // checks if history.pushState is available
});

// JQuery OnClick Updates
$(".nav-item.aba-pill > .nav-link:not(.disabled)").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        updateExibition($(this).attr("card-id"));
        if (history.pushState) updateURL(); // checks if history.pushState is available
    }
})

$("#locale > .dropdown-item").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        if(typeof default_mun !== 'undefined') updatePage($(this).attr('uf'), $(this).attr('mun'));
        else updatePage($(this).attr('uf'));
        if (history.pushState) updateURL(); // checks if history.pushState is available
    }
})

$(".acumdia > .dropdown-item").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        updateAcumDia($(this).attr("q"));
        if (history.pushState) updateURL(); // checks if history.pushState is available
    }
})

$(".casobi > .dropdown-item").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        updateCasObi($(this).attr("r"));
    }
})