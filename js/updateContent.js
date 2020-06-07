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

// Menu (Abas)
// Via QUERY REQUEST
if("aba" in urlParams && ($(".aba-group").hasClass(urlParams["aba"]))) updateExibition(urlParams["aba"]); //verifica se o parametro aba foi passado

// Via DEFAULT
else if($("#main-title-aba-pills").length) updateExibition($(".nav-item.aba-pill > .active").attr("card-id")); //se a entrada é sem query busca pelo menu selecionado no html

// Via JQuery OnClick Update
$(".nav-item.aba-pill > .nav-link:not(.disabled)").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        updateExibition($(this).attr("card-id"));
        if (history.pushState) updateURL(); // checks if history.pushState is available
    }
})

// Locale Dropdown
if(typeof default_mun !== 'undefined') {
    if("mun" in urlParams && "uf" in urlParams && isMun(urlParams["mun"]) && isUF(urlParams["uf"])) updatePage(urlParams["uf"], urlParams["mun"]); // Via QUERY REQUEST
    else if(typeof default_uf !== 'undefined' && typeof default_mun !== 'undefined') updatePage(default_uf, default_mun); // Via DEFAULT
}
else {
    if("uf" in urlParams && isUF(urlParams["uf"])) updatePage(urlParams["uf"]);
    else if(typeof default_uf !== 'undefined') updatePage(default_uf);
} //se a entrada é sem hash atualiza para o municipio default

// JQuery OnClick Update
$("#locale > .dropdown-item").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        if(typeof default_mun !== 'undefined') updatePage($(this).attr('uf'), $(this).attr('mun'));
        else updatePage($(this).attr('uf'));
        if (history.pushState) updateURL(); // checks if history.pushState is available
    }
})

// Acumulado-Diario Dropdown
// Via QUERY REQUEST
if("q" in urlParams && (urlParams["q"] == "acu" || urlParams["q"] == "dia")) updateAcumDia(urlParams["q"]); // verifica se existe o parametro e verifica a legitimidade

// Via DEFAULT
else if($(".acumdia > .dropdown-item").length) updateAcumDia($(".acumdia > .dropdown-item.active").attr("q")); //se a entrada é sem hash atualiza pelo ativo

// JQuery OnClick Update
$(".acumdia > .dropdown-item").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        updateAcumDia($(this).attr("q"));
        if (history.pushState) updateURL(); // checks if history.pushState is available
    }
})

// JQuery OnClick Update
$(".casobi > .dropdown-item").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        updateCasObi($(this).attr("r"));
    }
})