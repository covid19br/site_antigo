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

<h2>Fontes dos dados</h2>

Utilizamos os registros das notificações de casos de COVID-19
divulgadas diatiamente pelo Ministério da Saúde na 
[Plataforma IVIS](http://plataforma.saude.gov.br/novocoronavirus/).

A cada atualização na plataforma um programa automático de recupareção
de dados nos envia os novos registros e dispara a atualização das
análise e gráficos neste site.


<h2>Outras fontes e iniciativas semelhantes</h2>

Lista em construção, as iniciativas se multiplicam:

* [CMMID COVID repository](https://cmmid.github.io/topics/covid19/), Centre for Mathematical Modelling of Infectious Diseases, Londo School of Hygiene and Tropical Medicine.
* [Jonh Hopkins Coronavirus Resource Center](https://coronavirus.jhu.edu/map.html)
* [Site sobre epidemia de COVID-19 da Organização Mundial da Saúde](https://www.who.int/health-topics/coronavirus)



