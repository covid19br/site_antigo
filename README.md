# covid19br.github.io
Repositório do site [Observatório Covid-19 BR](https://covid19br.github.io/). 

Aqui você encontra os códigos para calcular as projeções e gerar os gráficos, assim como os dados usados. Se for alterar qualquer coisa no repositório, siga o tutorial abaixo.

### Sumário
  
  [Pré-requisitos](#Pré-requisitos)<br>
  [Instalação do R 3.6.3 e RStudio](#Instalação-do-R-3.6.3-e-RStudio)<br>
  [Instalação das bibliotecas em R](#Instalação-das-bibliotecas-em-R)<br>
  [Como baixar e executar](#Como-baixar-e-executar)<br>
  [Criando novos gráficos](#Criando-novos-gráficos)<br>
  [Atualizando e criando novas páginas em html](#Atualizando-e-criando-novas-páginas)<br>
          
## Pré-requisitos

Para rodar o programa, primeiro, clone o repositório em seu computador com `git clone`. Em seguida, serão necessárias instalações para que o programa compile.

Provavelmente você vai precisar instalar:

  - A versão 3.6.3 (atual) do R
  - Rstudio
  - Bibliotecas de R
  
  Tutoriais e links estão disponíveis a seguir.

## Instalação do R 3.6.3 e RStudio

Instruções de instalação do R podem ser encontradas [aqui](https://cran.r-project.org/). É necessária a versão mais recente do R para executar o código. Se ja possui o R, verifique a versão com o comando
```bash
$ R --version
```
E atualize o R.

Para instalar o Rstudio, primeiro, entre [aqui](https://rstudio.com/products/rstudio/download/) e baixe o Rstudio Desktop

[Outras instruções](https://uvastatlab.github.io/phdplus/installR.html) caso a instalação não funcione

## Instalação das bibliotecas em R

A instalação da maioria das bibliotecas se resolve com `install.packages("package_name")`, em R. No entanto, a Orca, usada para renderizar os plots interativos, não pode ser instalada assim. Para usar a Orca, é necessário anaconda. Veja [aqui](https://docs.anaconda.com/anaconda/install/) sobre como instalar Anaconda, e [aqui](https://github.com/plotly/orca) sobre como instalar Orca.

Ao instalar o conda e ativá-lo, seu prompt aparecerá assim:

```bash
(base) user@user: 
```

Quando rodamos o comando `$ orca`, o output esperado é

```bash
Plotly`s image-exporting utilities

  Usage: orca [--version] [--help] <command> [<args>]

  Available commands:
  - graph [or plotly-graph, plotly_graph]
    Generates an image of plotly graph from inputted plotly.js JSON attributes.
    For more info, run `orca graph --help`.
  - serve [or server]
    Boots up a server with one route per available export component
    For more info, run `orca serve --help`.
```

Se houver erros na instalação do orca por conda, tente executar os seguintes comandos, em `bash`:

```bash
$ conda install -c conda-forge nodejs
$ npm install -g electron@1.8.4 orca
```

Para instalar o restante das bibliotecas necessárias, execute o arquivo "./_src/install_packages.R". São as bibliotecas a seguir:
```r
install.packages("ggplot2")
install.packages("tidyverse")
install.packages("knitr")
install.packages("plotly")
install.packages("tidyr")
install.packages("dplyr")
install.packages("widgetframe")
install.packages("rmarkdown")
install.packages("zoo")
install.packages("EpiEstim")
install.packages("lubridate")
install.packages("readr")
```

Se por acaso precisar instalar novas bibliotecas, lembre-se de adicionar aqui e no arquivo.

## Como baixar e executar

Para executar o programa, rode o `update.R` da linha de comando, mas antes, verifique a instalação das dependências necessárias.

```bash
$ Rscript update.R
```

Alguns avisos aparecem após a execução, e ela demora um pouco. Espere terminar, e se não houver erros, os arquivos `.html` estarão atualizados, e podem ser vistos diretamente no navegador.

É importante que ele seja compilado no terminal, pois precisa do Orca, e este não funciona compilado por `source`. É possível utilizar o terminal do RStudio.

## Criando novos gráficos
Após terminar de criar um gráfico novo, para que ele seja incluído no html, o primeiro passo é fazer com que ele seja transformado em imagem ".svg" e um código ".html" com ggplotly (que garante a interatividade do gráfico no site).

No arquivo `render_graphs.R`, simplesmente adicione o nome do seu gráfico à lista de gráficos a serem renderizados:
```r
## No arquivo render_graphs.R
# Graphs
plots <- makeNamedList(..., seu.gráfico.ggplot) # Graficos a serem atualizados
```
IMPORTANTE: ele deve ser um ggplot. Ele deve ser codado no arquivo `plots.R`.

## Atualizando e criando novas páginas
O arquivo `template.html` é um bom ponto de partida para criação de novas páginas. Ele inclui as barras de navegação superiores e inferiores pré-fabricadas, bem como a estrutura principal do corpo.
A estrutura do site é composta por quatro principais grupos:

### 1. Barra Superior
A barra superior é o elemento flutuante que inclui o logo, o menu de estados e o menu de paginas do site.

#### Adicionando itens no menu dos estados
Inclua os dados do estado no código a seguir e use-o para substituir `<!-- ESTADOS.ITEM -->` no arquivo .html:
```
<a class="dropdown-item" href="./siglaAqui.html">Nome do Estado</a>
<!-- ESTADOS.ITEM -->
```

#### Adicionando itens no menu principal
Inclua os dados da página no código a seguir e use-o para substituir `<!-- MENU.ITEM -->` no arquivo .html: 
```
<li class="nav-item">
  <a class="nav-link" href="./ITEM.html">ITEM</a>
</li>
<!-- MENU.ITEM -->
```
No arquivo .hmtl do próprio item, o código deve ser o seguinte para correta indicação da página ativa:
```
<li class="nav-item active">
  <a class="nav-link" href="./ITEM.html">ITEM</a>
</li>
<!-- MENU.ITEM -->
```

#### Alterando o logo do observatório
Busque por `<!-- OBSERV.LOGO.IMAGEM -->` e substitua o conteúdo de `src=""` pelo arquivo .svg desejado.

### 2. Título Principal
Este grupo inclui o título principal da página e a data de atualização.
#### Alterando o título da página
Busque por `<!-- PAGE.TITLE -->` e substitua o conteúdo após `<h1 class="display">` pelo título desejado.

### 3. Cards de conteúdo
Os cards armazenam todas as informações importantes do corpo da página. Conforme mais cards de conteúdo são adicionados sua disposição é atualizada automáticamente.

#### Criando um card
A estrutura básica de um card é formada por:
```
<!-- NEW.CARD -->

<!-- Identificador do card -->
<div class="card">
  <div class="card-body">        
    <!-- CONTEÚDO AQUI -->
  </div>
</div>

<!-- NEW.CARD -->
```
Cada card distinto deve conter um identificador distinto em `<!-- Identificador do card -->` para facilitar sua edição.

Basta adicionar os componentes desejados em `<!-- CONTEÚDO AQUI -->` de acordo com os códigos pré-fabricados a seguir:
##### 1. Títulos dos cards
Títulos são identificados por `<!-- CARD.HEADER -->` *Atenção!* Títulos também devem ser inclusos no **conteúdo** do card.
##### 1.1 Título com ícone
Modifique o **ícone** buscando por `<!-- CARD.TITLE.ICON -->` e substituindo `NOME_DO_ARQUIVO.svg`. O ícone deve ser uma imagem em .svg.

Modifique o **título** buscando por `<!-- CARD.TITLE.TEXT -->` e substituindo `TITULO DO CARD`

Modifique a **descrição** do card buscando por `<!-- CARD.TITLE.DESCRIPTION -->` e substituindo `BREVE DESCRICAO`
```
<!-- CARD.HEADER -->
<div class="media">
  <img src="./img/NOME_DO_ARQUIVO.svg" width=64px alt="DESCRIÇÃO ACESSÍVEL" class="card-icon"> <!-- CARD.TITLE.ICON -->
  <div class="media-body">
    <h5 class="card-title">TITULO DO CARD</h5> <!-- CARD.TITLE.TEXT -->
    <p class="card-text">BREVE DESCRICAO</p> <!-- CARD.TITLE.DESCRIPTION -->
  </div>
</div>
```

##### 1.2 Título sem ícone
Modifique o **título** buscando por `<!-- CARD.TITLE.TEXT -->` e substituindo `TITULO DO CARD`
```
<!-- CARD.HEADER -->
<h5 class="card-title mb-3">TITULO DO CARD</h5> <!-- CARD.TITLE.TEXT -->
```

##### 2. Conteúdo
Existem múltiplos elementos de conteúdo que podem ser combinados livremente em um card:

##### 2.1.1 Data de atualização (automatica)
Ao compilar o arquivo `update.R` a hora é atualizada automaticamente. Insira o código a seguir para exibir o horário da última atualização dos gráficos:
```
<!-- CARD.DATE -->
<p class="card-date"><small class="updateDate">Última atualização: </small></p>
```

##### 2.1.2 Data de atualização (manual)
Se necessário, modifique uma data de atualização manual buscando por `<!-- CARD.DATE.MANUAL -->` ou insira uma nova com o código a seguir:
```
<!-- CARD.DATE.MANUAL -->
<p class="card-date"><small>Última atualização: DD/MM/AAAA HH:MM</small></p>
```

##### 2.2 Imagem estática com legenda
Modifique uma imagem estática e sua legenda buscando por `<!-- CARD.IMAGE -->` ou insira uma nova com o código a seguir:
```
<!-- CARD.IMAGE -->
<img src="./fig/NOME_DO_ARQUIVO.jpg" class="card-img-top" alt="DESCRIÇÃO ACESSÍVEL"> 
<p class="card-text legenda"><small>BREVE LEGENDA AQUI</small></p> <!-- CARD.IMAGE.LEGENDA -->
```

##### 2.3 Gráfico GGPlot interativo
Modifique um GGPlot interativo buscando por `<!-- CARD.GGPLOT -->` ou insira um novo utilizando:
```
<!-- CARD.GGPLOT -->
  <div data-src="./graphs/IDENTIFICADOR.DO.GRAFICO.html" class="codegena_iframe" data-css="background:url('./img/loading.gif') white center center no-repeat;border:0px;"  data-responsive="true">
    <img src=./graphs/IDENTIFICADOR.DO.GRAFICO.svg class="placeholder_svg" width="100%">
  </div>
<script src="./js/async-iframe.js"></script>
```
Nota: `IDENTIFICADOR.DO.GRAFICO` deve ser substituído pelo mesmo identificador utilizado na geração do gráfico em `render_graphs.R`
Nota 2: Para correto funcionamento na página `estados.html`, os gráficos devem ser salvos no R com seguinte nomenclatura:
```
IDENTIFICADOR.GRÁFICO.UF
```
Porém ao incluí-los no código HTML é necessário omitir o código UF:
```
IDENTIFICADOR.GRÁFICO
```

##### 2.4 Legenda de gráfico
Modifique a legenda de um gráfico buscando por `<!-- CARD.GGPLOT.LEGEND -->` ou insira uma nova utilizando:
```
<!-- CARD.GGPLOT.LEGEND -->
<div class="card-chartLegend">
  <small class="chartLegendSquare" id="COR_DA_LEGENDA">LEGENDA 1</small>
  <small class="chartLegendSquare" id="COR_DA_LEGENDA">LEGENDA 2</small>
</div>
```
Para manter boa visualização online, cada linha pode conter apenas duas legendas. Para adicionar mais legendas adicione um novo bloco.

A cor da legenda pode ser alterada substituindo `COR_DA_LEGENDA` por:
```
legendGrey
legendBlue
legendLightBlue
legendDarkBlue
legendPurple
legendPink
legendRed
legendOrange
legendYellow
legendGreen
legendTeal
```

##### 2.5 Texto justificado
Modifique o texto de um card buscando por `<!-- CARD.TEXT -->` (ou pelo próprio texto) ou insira um novo bloco utilizando:
```
<!-- CARD.TEXT -->
<p class="text-justify">
  Você deve escrever o seu texto aqui. O texto exibido será justificado.
  Apesar de estar em outra linha, não há quebra de linha aqui. Caso precise de uma quebra
  de linha, inclua outro bloco de texto.
</p>
```

##### 2.6 Assinatura
Modifique uma assinatura buscando por `<!-- CARD.SIGNATURE -->` ou insira uma nova utilizando:
```
<!-- CARD.SIGNATURE -->
<div class="blockquote-footer text-right">Observatório COVID-19</div>
```

##### 2.7 Botão com link para outra página
Modifique um botão buscando por `<!-- CARD.BUTTON -->` ou insira um novo utilizando:
```
<!-- CARD.BUTTON -->
<a href="LINK PARA A PÁGINA" target="_blank"><button class="btn btn-primary mt-1" type="button">
  TEXTO DO BOTÃO
</button></a>
```

##### 2.8 Botão com texto escondido
Modifique um botão que revela texto escondido buscando por `<!-- CARD.BUTTON.EXPAND -->` ou insira um novo utilizando:
```
<!-- CARD.BUTTON.EXPAND -->
<button class="btn btn-primary" type="button" data-toggle="collapse" data-target="#collapseGraph" aria-expanded="false" aria-controls="collapseGraph">
    TEXTO DO BOTÃO ▾
</button>
<!-- CARD.BUTTON.EXPAND.CONTENT -->
<div class="collapse mt-2" id="collapseGraph">
    <!-- CONTEÚDO ESCONDIDO AQUI-->
</div>
```
Em `<!-- CONTEÚDO ESCONDIDO AQUI-->` é possível inserir qualquer tipo de conteúdo descrito aqui: texto, imagens, assinaturas e etc.

##### 2.9 Equação matemática
No final do template está comentado os scripts para equação matemática. No seu arquivo, descomente-os.

```
<!-- SCRIPT PARA USAR MATHJAX E ESCREVER EQUAÇÕES
    <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3.0.1/es5/tex-mml-chtml.js"></script> -->
```

Para escrever a equação `\( EQUAÇÃO NA FORMA LATEX AQUI \) `

##### 2.10 Tabelas automáticas
No arquivo template.html o script necessário para utilizar tabelas criadas no R está comentado. Descomente-o apenas em páginas cujo uso de tabelas é necessário.
```
<!-- SCRIPT PARA USAR TABELAS 
    <script src="js/updateTable.js"></script> -->
```
Adicione o seguinte código em seu card na posição em que gostaria que a tabela. Substitua TABELA.html pelo nome da sua tabela gerada em R.
```
<!-- CARD.AUTO.TABLE -->
<include src="./tables/TABELA.html">Carregando...</include>
```

#### Adicionando cards em uma página
Substitua qualquer `<!-- NEW.CARD -->` pelo código do seu card de acordo com a posição desejada.

#### Mudando a quantidade de colunas
A quantidade de colunas é ajustada automáticamente de acordo com a tela do dispositivo para permitir melhor navegação mobile. No entanto, caso deseje alterar manualmente
o numero de colunas para telas a partir de 1200px de largura basta buscar por `<!-- COLUMNS.NUM -->` e substituir `<div class="card-columns">` pela tag desejada:
```
<div class="card-columns two"> <!-- Duas colunas -->
<div class="card-columns one"> <!-- Uma coluna -->
```
Este caso particular é utilizado para otimizar as páginas específicas de estados em telas de alta resolução.

### 4. Barra inferior
A barra inferior é o elemento fixo no final da página e pode conter múltiplos itens.
#### Adicionando texto
Substitua `<!-- FOOTER.ITEM -->` pelo texto desejado usando as tags `<div>`
```
<div class="footer-content">Seu texto aqui</div>
<!-- FOOTER.ITEM -->
```
#### Adicionando texto com ícones
Como o site inclui a [biblioteca Ionicons](https://ionicons.com) é possível adicionar ícones seguidos de texto na barra inferior.

Substitua `<!-- FOOTER.ITEM -->` pelo seguinte código, personalizando o texto e o ícone:
```
<div class="footer-content"> 
  <ion-icon name="logo-github"></ion-icon>
  <p class="mb-0 ml-1"><a href="Seu link aqui" target="_blank" class="text-reset">Seu texto aqui</a></p>
</div>
<!-- FOOTER.ITEM -->
```
Para trocar o ícone basta substituir `<ion-icon name="logo-github"></ion-icon>` pelo código do ícone desejado, obtido em [Ionicons](https://ionicons.com)

### Lembre-se
Alterações nas barras superior e inferior devem ser incluidas em todos os arquivos .html para garantir consistência na navegação.