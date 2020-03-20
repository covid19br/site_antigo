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

<h2>Quem somos</h2>

O **Observatório Covid-19 BR** é uma iniciativa independente, fruto da
colaboração entre pesquisadores com o desejo de contribuir para a
disseminação de informação de qualidade baseada em dados atualizados e
análises cientificamente embasadas. Criamos este sítio com códigos de
fonte aberta que nos permite acompanhar o estado atual da epidemia de
Covid-19 no Brasil, incluindo análises estatísticas e previsões.


A interface gráfica foi produzida utilizando-se [R
Markdown](https://rmarkdown.rstudio.com/) e os códigos podem ser
encontrados em nosso [github](https://github.com/covid19br/covid19BR).



<h3>Motivação</h3>

<b>Diante da propagação da COVID-19, doença causada pelo novo
coronavírus, a Organização Mundial da Saúde (OMS) decretou pandemia
mundial no dia 11/03. Segundo a OMS, uma pandemia é a disseminação
mundial de uma nova doença. Com início na China, o coronavírus se
espalhou rapidamente por todos os continentes, contaminando milhares
pessoas e levando diversos governantes a tomarem medidas drásticas
para a contenção da doença. A dinâmica da transmissão de doenças
infecciosas e, em particular, da COVID-19, deve ser compreendida para
que os governos e cidadãos possam tomar as melhores decisões. 

Com modelos matemáticos construídos a partir do conhecimento e dados
disponíveis podemos simular diferentes cenários e identificar
tendências. Como qualquer resultado científico, as descobertas feitas
com modelos matemáticos têm algum nível de incerteza. Mas ainda assim
são de suma importância para o planejamento de políticas
públicas. 

Diante do surto de COVID-19 que já se apresenta no Brasil,
nós, cientistas de diversas áreas, apresentamos aqui análises baseadas
em dados oficiais da propagação do coronavírus no país. Esperamos
contribuir com as autoridades responsáveis e informar a população a
partir de um ponto de vista científico.</b>

<p>

</p>


<h3>Equipe</h3>

* Andrei Michel Sontag (mestrando @ [IFT - UNESP](https://www.ift.unesp.br/) )
    + [CV](http://lattes.cnpq.br/1738716619940707)
    + <a.sontag@unesp.br>
	
* Caroline Franco (doutoranda @ [IFT-UNESP](https://www.ift.unesp.br/))
    + [CV](http://lattes.cnpq.br/1810788882318135)
    + <c.franco@unesp.br>

* Débora Y C Brandt (doutoranda @ [UC Berkeley, Estados Unidos](https://ib.berkeley.edu/) )
    + [CV](http://lattes.cnpq.br/0111799832635782)
    + <deboraycb@gmail.com>

* Flávia Maria Darcie Marquitti (pós doc @ [IFGW e IB - Unicamp](https://www.ifi.unicamp.br/~flaviam/))
    + [CV](http://lattes.cnpq.br/750889398476891)
    + <flaviam@ifi.unicamp.br>

* Laís de Souza Alves (doutoranda @ [IF - UnB](https://www.fis.unb.br/))
    + [CV](http://lattes.cnpq.br/1251914870700498)
    + <laisouzalves@gmail.com>

* Leonardo Souto Ferreira(mestrando @ [IFT - UNESP](https://www.ift.unesp.br/) )
    + [CV](http://lattes.cnpq.br/7427980482483909)
    + <leonardo.souto@unesp.br>

* Marco Antonio Silva Pinheiro (doutorando @ [IFT-UNESP](https://www.ift.unesp.br/))
    + [CV](http://lattes.cnpq.br/3654522236249726)
    + <marco.a.pinheiro@unesp.br>

* Marina Costa Rillo (pós doc @ [Uni Oldenburg, Alemanha](https://uol.de/en/icbm) )
    + [CV](http://lattes.cnpq.br/9213292464230085)
    + <marina.rillo@evobio.eu>

* Paula Lemos-Costa (pós doc @ [University of Chicago](https://lemoscosta.weebly.com/))
    + [CV](http://lattes.cnpq.br/2869271527300181)
    + <plemos@uchicago.edu>
	
* Paulo Guimarães Jr (Miúdo) (professor @ [IB-USP](http://guimaraeslab.weebly.com/))
    + [CV](http://lattes.cnpq.br/9619030543047007)
    + <prguima@ib.usp.br>

* Paulo Inácio Prado (professor @ [IB-USP](http://ecologia.ib.usp.br/let/))
    + [CV](http://lattes.cnpq.br/3884092565521453)
    + <prado@ib.usp.br>

* Rafael Lopes Paixão da Silva (doutorando @ [IFT - UNESP](https://www.ift.unesp.br/) )
    + [CV](http://lattes.cnpq.br/3085324638663546)
    + <rafael.lp.silva@unesp.br>
	
* Renato Coutinho  (professor @ [CMCC-UFABC](http://professor.ufabc.edu.br/~renato.coutinho/))
    + [CV](http://lattes.cnpq.br/1301865568118160)
    + <renato.coutinho@ufabc.edu.br>

* Roberto Kraenkel (professor @ [IFT-UNESP](https://professores.ift.unesp.br/roberto.kraenkel/))
    + [CV](http://lattes.cnpq.br/8497878967418484)
    + <roberto.kraenkel@unesp.br>

* Rodrigo Corder (doutorando @ [ICB-USP](http://ww3.icb.usp.br))
    + [CV](http://lattes.cnpq.br/9741820804547685)
    + <rodrigo.corder@usp.br>

* Silas Poloni Lyra (doutorando @ [IFT-UNESP](https://www.ift.unesp.br/) )
    + [CV](http://lattes.cnpq.br/3162809212291639)
    + <silas.poloni@unesp.br>

* Tatiana P. Portella Zenker (doutoranda @ [Ecologia - USP] )
    + [CV](http://lattes.cnpq.br/8988655613888832)
    + <portellatp@usp.br>

* Vítor Sudbrack (mestrando @ [IFT - UNESP](https://www.ift.unesp.br/) )
    + [CV](http://lattes.cnpq.br/1687206263257247)
    + <vitor.sudbrack@unesp.br>

* Wendell Pereira Barreto 
    + [CV](http://lattes.cnpq.br/0639412837460678)
    + <wendellbarreto@gmail.com>


