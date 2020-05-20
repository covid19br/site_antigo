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
    
    if($("#main-title-aba-pills").length) params.push("aba=" + $(".aba-pill > .nav-link.active").attr("card-id"));
    if(typeof default_uf !== 'undefined') params.push("uf=" + $(".dropdown-item.active").attr('uf'));

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
$(".nav-item.aba-pill > .nav-link").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        updateExibition($(this).attr("card-id"));
        if (history.pushState) updateURL(); // checks if history.pushState is available
    }
})

// Dropdown Selection
// Via QUERY REQUEST
if("uf" in urlParams && isUF(urlParams["uf"])) updatePage(urlParams["uf"]);

// Via DEFAULT
else if(typeof default_uf !== 'undefined') updatePage(default_uf); //se a entrada é sem hash atualiza para o municipio default

// JQuery OnClick Update
$(".dropdown-item").click(function () {
    if (!$(this).hasClass("active")) { // se nao eh o item atual
        var current_uf = $(this).attr('uf');
        updatePage(current_uf);
        if (history.pushState) updateURL(); // checks if history.pushState is available
    }
})