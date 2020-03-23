---
title: "Observatório COVID-19 BR | Fontes"
output: 
 flexdashboard::flex_dashboard:
  orientation: columns
  vertical_layout: scroll
  self_contained: false
  lib_dir: ../libs
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
divulgadas diariamente pelo 
[Ministério da Saúde](https://coronavirus.saude.gov.br/).

A cada atualização na plataforma um programa automático de recupareção
de dados nos envia os novos registros e dispara a atualização das
análise e gráficos neste site.


<h2>COVID Data Science no Brasil</h2>

Lista em construção, as iniciativas se multiplicam. Se você tem
trabalho na área nos escreva para divulgarmos aqui. E por favor
divulgue o nosso trabalho também.

* [covidbr](https://liibre.github.io/coronabr/), pacote em [R](https://www.r-project.org) para download dos dados oficiais de COVID-19, por Sara Mortara e Andrea Sánchez-Tapia, Jardim Botânico do Rio de Janeiro. 
* [Número de casos confirmados de COVID-19 no Brasil](https://labs.wesleycota.com/sarscov2/br), Wesley Cota, Universidade de Viçosa.


<h2>Outras fontes de dados e de informações</h2>

* [Portal sobre Coronavírus da FIOCRUZ](https://portal.fiocruz.br/coronavirus)
* [CMMID COVID repository](https://cmmid.github.io/topics/covid19/), Centre for Mathematical Modelling of Infectious Diseases, Londo School of Hygiene and Tropical Medicine.
* [Jonh Hopkins Coronavirus Resource Center](https://coronavirus.jhu.edu/map.html)
* [Site sobre epidemia de COVID-19 da Organização Mundial da Saúde](https://www.who.int/health-topics/coronavirus)


<h2>O Observatório Covid-19 BR na mídia</h2>

* [Programa Fantástico](https://globoplay.globo.com/v/8401335/), Rede Globo, 15 de março de 2020.
* ["Contra epidemia de coronavírus, Brasil precisa parar, afirmam especialistas"](https://www1.folha.uol.com.br/equilibrioesaude/2020/03/contra-epidemia-brasil-precisa-parar-afirmam-especialistas.shtml), Folha de São Paulo, 16 de março de 2020.
* ["A ciência da epidemiologia: o caso do coronavírus"](https://www.youtube.com/watch?v=4E0QBcN7Uw8), Programa "Física ao vivo", Sociedade Brasileira de Física, 18 de março e 2020.
* ["Cientistas lançam observatório de Covid-19 no Brasil em tempo real e dizem que casos podem chegar a 1.600 em quatro dias"](https://cadeacura.blogfolha.uol.com.br/?p=1309), Folha e São Paulo, 18 de março de 2020.
* ["Pesquisadores criam site com dados e projeções sobre a Covid-19 no Brasil"](http://www.jornaldaciencia.org.br/edicoes/?url=http://jcnoticias.jornaldaciencia.org.br/7-pesquisadores-criam-site-com-dados-e-projecoes-sobre-a-covid-19-no-brasil/), Jornal da Ciência, 19 de março de 2020.
* ["Para conter o avanço explosivo"](https://revistapesquisa.fapesp.br/2020/03/19/para-conter-o-avanco-explosivo/), Revista Pesquisa FAPESP, 19 de março de 2020
* ["Ritmo de contágio do coronavírus no Brasil está igual ao registrado na Itália e acelerando, apontam universidades"](https://g1.globo.com/bemestar/coronavirus/noticia/2020/03/20/ritmo-de-contagio-do-coronavirus-no-brasil-esta-igual-ao-registrado-na-italia-e-acelerando-aponta-unesp.ghtml), Portal G1, 20 de março de 2020
* ["Tempos excepcionais demandam medidas excepcionais"](https://www1.folha.uol.com.br/opiniao/2020/03/com-o-avanco-da-covid-19-o-brasil-deve-adotar-ja-medidas-drasticas-de-confinamento-sim.shtml), por Roberto Kraenkel, Renato Coutinho e Caroline Franco (equipe do Observatório COVID-19 BR). Folha de São Paulo, 21 de março de 2020.



 




