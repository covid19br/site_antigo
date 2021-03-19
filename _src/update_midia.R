if(!require(googlesheets4)){install.packages("googlesheets4"); library(googlesheets4)}
if(!require(dplyr)){install.packages("dplyr"); library(dplyr)}
if(!require(stringr)){install.packages("stringr"); library(stringr)}
library(readr)

# update git?
update.git <- FALSE

# private link
doc_link <- read_file('link_midia_source.txt')

# destination file
file.out <- "../midia.html"

# numeração das tabelas:
# 1. tabela principal
# 2. tipos
# 3. backlog

# public access
gs4_deauth()

reports <- read_sheet(doc_link, sheet = 1)
reports.df <- as.data.frame(reports)

reports.df <- reports.df %>%
    filter(! any(is.na(date), is.na(link), is.na(titulo))) %>%
    mutate(data = as.Date(reports.df$date),
           mes = format(reports.df$date, "%B"),
           ano = format(reports.df$date, "%Y")) %>%
    arrange(desc(date))

template_year_begin <- '
              <p class="news-year">
                  <a class="text-reset" data-toggle="collapse" href="#collapseano" role="button"
                      aria-expanded="false" aria-controls="collapseano">
                      ano ▾
                  </a>
              </p>

              <!-- CONTEUDO ano -->
              <div class="collapse show" id="collapseano">
                  <div class="list-group">
'
template_year_end <- '
                  </div>
              </div>
'
template_month_begin <- '
                 <p class="news-month">
                    <a class="text-reset" data-toggle="collapse" href="#collapsemes_ano" role="button"
                        aria-expanded="false" aria-controls="collapsemes_ano">
                        mes ▾
                    </a>
                </p>

                <!-- CONTEUDO mes -->
                <div class="collapse show" id="collapsemes_ano">
                    <div class="list-group">'
template_month_end <- '
                    </div>
                </div>'
template_report <- '
                        <a href="links"
                        target="_blank" rel="noopener"
                        class="list-group-item list-group-item-action flex-column align-items-start">
                        <div class="d-flex w-100 justify-content-between">
                            <h5 class="mb-1"><img src="logo_midia" class="favicon">veiculo</h5>
                            <small>date</small>
                        </div>
                        <p class="mb-1">titulo</p>
                        </a>'

fields <- c("veiculo", "date", "titulo", "link", "logo_midia")
content <- ""
reports.df %>%
    group_by(ano) %>%
    group_walk(function(x, ano) {
        content <<- paste(content,
                         str_replace_all(template_year_begin,
                                         c("ano" = ano[[1]])),
                         sep = "\n")
        x %>%
            group_by(mes) %>%
            group_walk(function(y, mes) {
                content <<- paste(content,
                         str_replace_all(template_month_begin,
                                         c("mes" = mes[[1]],
                                           "ano" = ano[[1]])),
                         sep = "\n")
                for (i in seq(1, nrow(y))) {
                    content <<- paste(content,
                                     str_replace_all(template_report,
                                                     unlist(y[i,tolower(fields)])),
                                     sep = "\n")
                }
                content <<- paste(content,
                         str_replace_all(template_month_end,
                                         c("mes" = mes[[1]],
                                           "ano" = ano[[1]])),
                         sep = "\n")
                         })
        content <<- paste(content,
                         str_replace_all(template_year_end,
                                         c("ano" = ano[[1]])),
                         sep = "\n")
        })

full.content <- read_file(file.out)

new.content <- str_replace(full.content,
                           regex("(<!--AUTOMATIC CONTENT BEGIN-->).*(<!--AUTOMATIC CONTENT END-->)",
                                 dotall = TRUE),
                           paste("\\1", content, "\\2", sep = "\n"))

# expand first year/month
new.content <- str_replace(new.content, regex('(<p class="news-year">\\s*<a class="text-reset" data-toggle="collapse" href="#collapse\\d+" role="button"\\s*aria-expanded=)"false"', dotall = TRUE),
            '\\1"true"')
new.content <- str_replace(new.content, regex('(<p class="news-month">\\s*<a class="text-reset" data-toggle="collapse" href="#collapse\\w+" role="button"\\s*aria-expanded=)"false"', dotall = TRUE),
            '\\1"true"')

if (update.git)
    system("git pull --ff-only")

write_file(new.content, file.out)

if (update.git) {
    emails <- str_trim(read_file('emails.txt'))
    system(paste0("git commit -m ':robot: atualizando reportagens' ",
                  file.out,
                  " && git push",
                  ' && echo -e "Página de reportagens atualizada.\n
O conteúdo novo abaixo aparecerá no site em alguns minutos.\n
Atenciosamente,
Robot mailer\n\n`git diff HEAD~1" | mail -s "Página de reportagens atualizada" ',
                  emails)
    )
}
