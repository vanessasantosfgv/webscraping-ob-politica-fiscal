#================================================#
# Webscraping - Observatório de Politica Fiscal
#================================================#

library(rvest)
library(dplyr)
library(stringr)
library(xml2)

link_raiz   <- "https://observatorio-politica-fiscal.ibre.fgv.br/?page="
max_paginas <- 10  # Ajuste conforme necessário

titulos <- character()
datas   <- character()
links   <- character()

for (i in 0:max_paginas) {
  try({ # try evita que o código pare se uma página falhar
    link <- paste0(link_raiz, i)
    page <- read_html(link)
    
    novos_titulos <- page %>% html_nodes(".views-field-title a") %>% html_text()
    if(length(novos_titulos) == 0) break # Para se a página estiver vazia
    
    titulos <- c(titulos, novos_titulos)
    datas <- c(datas, page %>% html_nodes(".date-display-single") %>% html_text())
    links <- c(links, page %>% html_nodes(".views-field-title a") %>% html_attr("href") %>% 
               paste0("https://observatorio-politica-fiscal.ibre.fgv.br", .))
  })
}

# Criando a base
df_opf <- data.frame(Link = links, Título = titulos, Data = datas)

# Salvando o arquivo no formato que o GitHub espera (na pasta raiz)
write.csv2(df_opf, "ws_opf.csv", row.names = FALSE)
