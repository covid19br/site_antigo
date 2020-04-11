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
    - { title: "+Perguntas", href: "perguntas.html", align: left}
    - { title: "Fontes", href: "fontes.html", align: left}
    - { title: "Na Mídia", href: "midia.html", align: left}
    - { title: "Sobre", href: "sobre.html", align: left}
  favicon: favicon.png
  includes:
   after_body: footer.html
   in_header: header.html
---

### Como epidemias se espalham por um país continental?

<a href="https://guimaraeslabbr.weebly.com/voos.html">
![](fig/voos_brasil.jpg)
</a>

###

A chave pode estar na rede formada por aeroportos e vôos conectando os estados
brasileiros. Portanto, a análise da estrutura dessa rede aérea pode nos ajudar
a entender a propagação do COVID-19 por nosso país.

[<b>Leia mais aqui</b>](https://guimaraeslabbr.weebly.com/voos.html).


