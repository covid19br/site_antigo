library(dplyr)
library(ggplot2)
library(ggiraph)
library(geobr)
library(ggthemes)
library(viridis)
library(htmlwidgets)
library(withr)

munSP <- read_municipality(code_muni="SP", year=2018)
drs <- read.csv("../dados/DRS_SP.csv")
munSP$id <- substr(munSP$code_muni, 1, 6)
munSP.drs <- merge(munSP, drs, by="id")

drsSP <- munSP.drs %>%
    group_by(DRS) %>%
    summarise(DRS.nome = first(DRS.nome),
              DRS.nome.nonascii = first(DRS.nome.nonascii))

onclick.mun <- sprintf(
  "window.open(\"%s%s\")",
  "./drs.html?uf=SP-",
  munSP.drs$DRS.nome.nonascii
)
onclick.drs <- sprintf(
  "window.open(\"%s%s\")",
  "./drs.html?uf=SP-",
  drsSP$DRS.nome.nonascii
)

map <- ggplot(munSP.drs) +
    geom_sf_interactive(aes(fill = DRS,
                            tooltip = municipio,
                            data_id = id,
                            onclick = onclick.mun
                            ),
                        size = 0.1, col = "white",
                        show.legend = FALSE) +
    geom_sf_label_interactive(data = drsSP,
                              aes(label = paste(as.roman(DRS), "-", DRS.nome),
                                  onclick = onclick.drs),
                              alpha=0.5, size=2) +
    scale_fill_viridis(option="cividis") +
    theme_map()

girmap <- girafe(ggobj = map)

#print(girmap)
with_dir("../", saveWidget(girmap,
                           file="mapa_DRS_SP.html",
                           selfcontained=FALSE,
                           libdir="./web/libs"))
