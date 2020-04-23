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

### E como as epidemias se espalham por dentro de um estado?

<a href="https://preprints.scielo.org/index.php/scielo/preprint/view/49">
![](fig/sppp_orig.jpg)
</a>

###

Neste relatório, associamos dados da rede de fluxos rodoviários
e da demografia das microrregiões paulistas com os casos confirmados
de COVID-19 atualizados em 04/04/2020 para gerar informações
estratégicas sobre a propagação geográfica da pandemia de SARS-CoV-2
no Estado de São Paulo. Identificamos microrregiões que podem atuar
como núcleos propagadores da epidemia ou que têm alta vulnerabilidade
a receber pessoas infectadas. Desta forma, atualizamos a identificação das microrregiões mais vulneráveis à propagação geográfica da pandemia do novo coronavírus (SARS-CoV-2) no estado de SP.

[<b>Leia o relatório na íntegra aqui para o Estado de São Paulo.</b>](https://preprints.scielo.org/index.php/scielo/preprint/view/49)


[<b>Leia o relatório na íntegra aqui para os Estados do Nordeste.</b>](https://preprints.scielo.org/index.php/scielo/preprint/view/35/version/39)


[<b>Leia o relatório na íntegra aqui para os Estados do Sul.</b>](https://preprints.scielo.org/index.php/scielo/preprint/view/128)
