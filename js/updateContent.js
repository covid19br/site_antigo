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
    
    if($(".card-menu").length) params.push("aba=" + $(".card.menu.selected").attr("card-id"));
    if(typeof default_uf !== 'undefined') params.push("uf=" + $("#locale > .dropdown-item.active").attr('uf'));
    if($(".acumdia").length) params.push("q=" + $(".acumdia > .dropdown-item.active").attr("q"));

    // assemble query
    for(i = 0; i < params.length; i++) query = query + params[i] + "&";
    
    // updates URL
    window.history.pushState(null, null, query.slice(0, -1));
}

// Menu (Abas)
// Via QUERY REQUEST
if("aba" in urlParams && ($(".card-deck").hasClass(urlParams["aba"]))) updateExibition(urlParams["aba"]); //verifica se o parametro aba foi passado

// Via DEFAULT
else if($(".card-menu").length) updateExibition($(".card.menu.selected").attr("card-id")); //se a entrada é sem hash busca pelo menu selecionado no html

// Via JQuery OnClick Update
$(".card.menu").click(function () {
    if (!$(this).hasClass("selected")) { // se nao eh o item atual
        updateExibition($(this).attr("card-id"));
        if (history.pushState) updateURL(); // checks if history.pushState is available
    }
})

// Locale Dropdown
// Via QUERY REQUEST
if("uf" in urlParams && isUF(urlParams["uf"])) updatePage(urlParams["uf"]);

// Via DEFAULT
else if(typeof default_uf !== 'undefined') updatePage(default_uf); //se a entrada é sem hash atualiza para o municipio default

// JQuery OnClick Update
$("#locale > .dropdown-item").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        updatePage($(this).attr('uf'));
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