# Verificando libraries e instalando elas
if (!requireNamespace("sf", quietly = TRUE)) {
  install.packages("sf")
}
if (!requireNamespace("stringr", quietly = TRUE)) {
  install.packages("stringr")
}

#UNIR ARQUIVOS KML EM UM SÓ
library(sf)
library(stringr)

#SELECIONAR DIRETORIO DE ARQUIVOS KML
setwd(choose.dir())
kml_files<-list.files(getwd(), pattern = "*.kml")
kml_list<- list()

# LOOP - PROCURAR ARQUIVOS
for (arquivo in kml_files) {
  caminho_arquivo <- file.path(getwd(), arquivo)
  df_temporario <- st_read(caminho_arquivo, stringsAsFactors = FALSE)
  kml_list[[arquivo]] <- df_temporario
}
rm(df_temporario,caminho_arquivo,kml_files,arquivo)

# Combinando data frames usando do.call e rbind
kml_sf <- do.call(rbind, kml_list)
rm(kml_list)
row.names(kml_sf)<-NULL
points <- kml_sf[st_geometry_type(kml_sf) %in% c("POINT","MULTIPOINT"), ]
lines <-kml_sf[st_geometry_type(kml_sf) %in% c("LINESTRING","MULTILINESTRING"), ]
polygons <-kml_sf[st_geometry_type(kml_sf) %in% c("POLYGON","MULTIPOLYGON"), ]

# Salvando arquivo
dir.create("RESULTADOS")
setwd("RESULTADOS")
st_write(st_zm(points), 'points.shp')
st_write(st_zm(lines), 'lines.shp')
st_write(st_zm(polygons), 'polygons.shp')