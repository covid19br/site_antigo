---
title: "Observatório COVID-19 BR"
output:
 flexdashboard::flex_dashboard:
  orientation: column
  vertical_layout: scroll
  theme: cerulean
  self_contained: false
  lib_dir: ../libs
  source_code: "https://github.com/covid19br/covid19br.github.io"
  social: menu
  css: 'styles.css'
  navbar:
    - { title: "Início", href: "index.html", align: left}
    - { title: "+Info", href: "informacoes.html", align: left}
    - { title: "Fontes", href: "fontes.html", align: left}
    - { title: "Na Mídia", href: "midia.html", align: left}
    - { title: "Sobre", href: "sobre.html", align: left}
  favicon: favicon.png
  includes:
   after_body: footer.html
   in_header: header.html
---


### Como o isolamento social influencia a dinâmica de propagação da epidemia?

<a href="https://guimaraeslabbr.weebly.com/COVID19.html">
 ![](fig/rede_prsc.jpg)
</a>

###

Aqui, usamos **um cenário bem simples para ilustrar as vantagens do isolamento social em reduzir a propagação de uma doença
contagiosa**. Nós traduzimos e adaptamos o [modelo de propagação de um
vírus](http://ccl.northwestern.edu/netlogo/models/SpreadofDisease) em
uma rede social feito por Uri Wilensky (Northwestern University).
Para ler mais e simular diferentes cenários, [<b>CLIQUE
AQUI</b>](https://guimaraeslabbr.weebly.com/COVID19.html).



