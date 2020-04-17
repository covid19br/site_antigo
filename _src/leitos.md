---
title: "Observatório COVID-19 BR"
output: 
 flexdashboard::flex_dashboard:
  orientation: rows
  vertical_layout: scroll
  self_contained: false
  lib_dir: ../libs
  source_code: "https://github.com/covid19br/covid19br.github.io"
  social: menu
  css: styles.css
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


Row  {data-height=400}
---------------------
  
### Em quanto tempo 100% dos leitos de São Paulo estariam ocupados com COVID-19, sem distanciamento social?
  
No início da epidemia no município de São Paulo, a ocupação dos leitos com casos graves confirmados de COVID-19 era de 0.8% dos leitos totais (dados da base oficial de notificações SIVEP-GRIPE), e o número de casos da doença duplicava rapidamente (a cada 2.4 dias, estimado entre os dias 14 e 19 de março). Usando estes dados, nosso modelo mostra que 100% dos leitos disponíveis em São Paulo seriam ocupados por pacientes de COVID-19 em apenas 18 dias (dia 6 de abril) **se nenhuma medida de controle de contágio tivesse sido tomada** e o número de leitos se mantivesse constante (**Fig. 1 e 2**). A simulação de leitos de UTI mostra resultados parecidos: sem nenhuma medida de controle, 100% dos leitos de UTI seriam ocupados somente com pacientes de COVID-19 em apenas 14 dias (**Fig. 3 e 4**).


###

![**Fig. 1**: Previsão da porcentagem de **leitos hospitalares** ocupados por COVID-19 no município de São Paulo entre os dias 15/03 e 13/04 em um cenário sem distanciamento social. A linha e os pontos amarelos são os casos estimados pelo modelo, e os pontos pretos são os dados observados de casos graves hospitalizados entre os dias 14 e 19/03 (dados da base oficial de notificações SIVEP-GRIPE).](fig/leitos_fig1.png){ width=100% }


Row  {data-height=400}
---------------------
  
### Por que modelar um cenário sem distanciamento social?

Nosso modelo representa um cenário do avanço da epidemia de COVID-19 no município de São Paulo, caso as medidas de distanciamento social não tivessem sido tomadas. Apesar de hipotético, este modelo nos permite explorar o que aconteceria no município de São Paulo caso estas medidas não tivessem sido tomadas. Ao comparar os resultados do nosso modelo com a atual ocupação de leitos na cidade de São Paulo, podemos quantificar quantos leitos (e vidas!) as medidas de distanciamento social salvaram (trabalho em andamento). A comparação é importante, por exemplo, para o gestor público ter as condições necessárias para tomar a melhor decisão em termos de administração e de política pública, em especial em um momento de extrema gravidade como é o atual. Nosso modelo, apesar de hipotético, utiliza dados reais de número de leitos e de casos na cidade. Para representar o cenário sem medidas de distanciamento social, estimamos o tempo de duplicação da doença num período anterior a estas medidas em São Paulo (dias 14 a 19 de março, **Fig. 1 e 2**).

###

![**Fig. 2**:  Fig. 1 em escala logarítmica. Previsão da porcentagem (em escala logarítmica) de **leitos hospitalares** ocupados por COVID-19 no município de São Paulo entre os dias 15/03 e 13/04 em um cenário sem distanciamento social. A linha e os pontos amarelos são os casos estimados pelo modelo, e os pontos pretos são os dados observados de casos graves hospitalizados entre os dias 14 e 19/03 (dados da base oficial de notificações SIVEP-GRIPE).](fig/leitos_fig2.png){ width=100% }


Row  {data-height=400}
---------------------

### É arriscado reduzir o isolamento social em municípios com mais de 50% dos leitos disponíveis?

Nosso modelo sugere que sim. Mesmo em cidades onde pacientes com COVID-19 ocupam atualmente uma porcentagem baixa dos leitos, a ocupação total de leitos pode ser atingida muito rapidamente sem medidas preventivas. Medidas preventivas, como o isolamento social, aumentam o tempo de duplicação da doença e, portanto, diminuem a velocidade de ocupação dos leitos de hospitais. Iniciar as medidas preventivas somente quando 50% dos leitos estiverem ocupados pode ser muito tarde, já que o número de hospitalizados por COVID-19 aumenta exponencialmente, e os efeitos de medidas preventivas podem demorar para afetar o número de hospitalizações por COVID-19. 

### 

![**Fig. 3**: Previsão da porcentagem de **leitos de UTI** ocupados por COVID-19 no município de São Paulo entre os dias 15/03 e 13/04 em um cenário sem distanciamento social. A linha e os pontos amarelos são os casos estimados pelo modelo.](fig/leitos_fig3.png){ width=100% }
  

Row  {data-height=400}
---------------------

### Quantos leitos existem na cidade de São Paulo?

De acordo com o Cadastro Nacional de Estabelecimentos de Saúde (CNES) [*Ref. 1*], a cidade de São Paulo possui 4.205 leitos de UTI e 28.297 leitos simples para adultos no sistema SUS e privado. Esses leitos estão disponíveis para pacientes com diversos tipos de enfermidades, e não é possível saber até o momento quantos deles estão ocupados por outras doenças que não são COVID-19 ou Síndrome Respiratória Aguda Grave (SRAG). Contudo, sabemos que os gestores dos hospitais estão suspendendo procedimentos eletivos (não urgentes), realocando doentes entre enfermarias e adequando espaços físicos, dentro e fora dos hospitais, para aumentar a disponibilidade de leitos para os casos de COVID-19 (Fonte: Secretaria Municipal de São Paulo). 

### 

![**Fig. 4**:  Fig. 3 em escala logarítmica. Previsão da porcentagem (em escala logarítmica) de **leitos de UTI** ocupados por COVID-19 no município de São Paulo entre os dias 15/03 e 13/04 em um cenário sem distanciamento social. A linha e os pontos amarelos são os casos estimados pelo modelo.](fig/leitos_fig4.png){ width=100% }


Row
---------------------
### Modelo

Usamos um modelo logístico para simular os números de infectados, suscetíveis e hospitalizados por classe etária, de acordo com a distribuição etária da população do município de São Paulo. Utilizamos número de hospitalizados (casos graves) por faixa etária da base oficial de notificações SIVEP-GRIPE entre os dias 14 e 19 de março (período anterior às medidas de quarentena, que entraram em vigor dis 24 de março, *Ref. 2*). Usamos um método de ajuste bayesiano para ajustar os valores dos parâmetros do modelo aos dados observados. 
O tempo de duplicação que melhor se ajustou aos dados observados neste período foi de 2.4 dias. Usamos este valor inicial de tempo de duplicação (2.4 dias) para projetar o número de hospitalizados para os dias subsequentes (20 de março a 13 de abril). A taxa de crescimento da doença, contudo, não é uma constante, e varia no modelo de acordo com o número de não infectados no tempo t. Para a estimativa de número de infectados, utilizamos a distribuição etária de hospitalizados proposta na *Ref. 3*. A conversão de hospitalizados em pessoas que necessitam de leitos de UTI foi feita conforme a distribuição etária de pacientes hospitalizados que necessitam de UTI proposta na *Ref. 4*. Nós não consideramos possíveis mudanças no tempo de duplicação devido às medidas de distanciamento social. Desta forma, nós não consideramos grandes variações e incertezas no tempo de duplicação.

### Referências

[*Ref. 1*] Leitos por Especialidade dos Estabelecimentos de Saúde do CNES - Município de São Paulo. 
http://tabnet.saude.prefeitura.sp.gov.br/cgi/deftohtm3.exe?secretarias/saude/TABNET/cnes/leito.def

[*Ref. 2*] Governo de SP determina quarentena em todo o Estado.  https://www.saopaulo.sp.gov.br/ultimas-noticias/ao-vivo-governo-de-sp-anuncia-novas-medidas-para-combate-ao-coronavirus-no-estado/

[*Ref. 3*] Verity, R., Okell, L.C., Dorigatti, I., *et al.* Estimates of the severity of COVID-19 disease. *medRxiv* 2020.03.09.20033357. DOI: https://doi.org/10.1101/2020.03.09.20033357 

[*Ref. 4*] Severe Outcomes Among Patients with Coronavirus Disease 2019 (COVID-19), United States, February 12 – March 16, 2020. *Morb Mortal Wkly Rep* 2020; 69:343-346. DOI: http://dx.doi.org/10.15585/mmwr.mm6912e2external




