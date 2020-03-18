---
title: "Observatório COVID-19 BR"
output: 
 flexdashboard::flex_dashboard:
  orientation: columns
  vertical_layout: scroll
  source: embed
  source_code: "https://github.com/covid19br/covid19br.github.io"
  social: menu
  css: styles.css
  navbar:
      - { title: "Início", href: "index.html", align: left}
      - { title: "+Info", href: "informacoes.html", align: left}
      - { title: "Fontes", href: "fontes.html", align: left}
      - { title: "Sobre", href: "sobre.html", align: left}
  favicon: favicon.png
 includes:
  after_body: footer.html
  in_header: header.html
---

# Fontes



