# install.packages(c("Rcrawler", "plyr", "tidyverse", "googleCloudStorageR"))

suppressMessages(library(Rcrawler))
suppressMessages(library(plyr))
suppressMessages(library(tidyverse))
# suppressMessages(library(googleCloudStorageR))
# library(bigrquery)


# tiempo_inicio <- Sys.time()

# bq_auth(path = Sys.getenv("MY_SECRET_ACCOUNT"))
# gcs_auth(Sys.getenv("MY_SECRET_ACCOUNT"))

# project <- Sys.getenv("MY_PROJECT")
# dataset <- Sys.getenv("MY_DATASET")
# table   <- Sys.getenv("MY_TABLE")

# DARLE UNA VUELTA PARA DESCARGAR DATOS POR JORNADA
# sql = paste0('SELECT max(jornada) as max_gameday FROM `', project, '.', dataset, '.', table, '`')
# query_results <- bq_table_download(bq_project_query(project, sql))
# max_gameday   <- query_results[['max_gameday']] + 1


############
# PARTIDOS #
############
if(month(Sys.time()) <= 8){
  anyo <- year(Sys.time()) - 1
}else{
  anyo <- year(Sys.time())
}
season      <- seq(2022, anyo, 1)
match_day   <- seq(1, 13, 1)
# season      <- seq(anyo, anyo, 1)
# match_day   <- seq(max_gameday, 50, 1)
game_ids    <- list()
result_ids  <- list()
i <- 1

for(season_number in season){
  for(match_day_number in match_day){
    print(paste("match day number", match_day_number))
    Rcrawler(Website = paste0("https://www.acb.com/resultados-clasificacion/ver/temporada_id/", season_number, "/competicion_id/1/jornada_numero/", match_day_number),
             crawlUrlfilter="/partido/estadisticas/id",
             dataUrlfilter ="/partido/estadisticas/id",
             ExtractXpathPat = c("/html/body/div[1]/div/section/div/section/header/div[1]/h4[1]",
                                 "/html/body/div[1]/div/section/div/section/header/div[1]/h4[2]",
                                 "/html/body/div[1]/div/section/div/section/header/div[4]/div[2]/div[1]",
                                 "/html/body/div[1]/div/section/div/section/header/div[4]/div[2]/div[3]",
                                 "/html/body/div[1]/div/section/div/section/header/div[1]/h2",
                                 "/html/body/div[1]/div/section/div/section/header/div[2]/div[2]/span"),
             PatternsNames = c("local_team",
                               "visit_team",
                               "local_score",
                               "visit_score",
                               "match_day",
                               "date"),
             no_cores = 4, 
             no_conn = 4,
             MaxDepth = 1,
             RequestsDelay = 0.24,
             saveOnDisk = FALSE)
    
    if(dim(INDEX)[1] != 0){
      result_ids[[i]]  <- DATA
      game_ids[[i]]    <- INDEX
      i <- i + 1
    } # else(break)
  }
}

df_game_data  <- do.call(rbind.fill, game_ids) %>% 
                  select(Url) %>% 
                  mutate(match_id = str_replace(Url, "https://www.acb.com/partido/estadisticas/id/", ""))

df_results_data <- do.call(rbind, lapply(result_ids, function(x) do.call(rbind, lapply(x, data.frame))))

df_results_data <- cbind(df_game_data, df_results_data) %>% 
                      select("local_team",
                             "visit_team",
                             "local_score",
                             "visit_score",
                             "match_day",
                             "date",
                             "match_id")

# Apply trimws to all string columns
string_columns <- sapply(df_results_data, is.character)
df_results_data[string_columns] <- lapply(df_results_data[string_columns], trimws)

write.csv(df_results_data, paste0("data/results_season_match_id.csv"), row.names = FALSE)

# write.csv(df_results_data, paste0(here::here(), "/results_season_match_id.csv"), row.names = FALSE)

# Crear un archivo temporal
# temp_file <- tempfile(fileext = ".csv")

# Escribir los datos en el archivo temporal en formato CSV
# write.csv(df_results_data, file = temp_file, row.names = FALSE)

# Replace 'your-bucket' with your actual bucket name
# gcs_upload(temp_file, bucket = Sys.getenv("GCS_DEFAULT_BUCKET"), name = "df_results_data.csv")

# Borrar el archivo temporal
# unlink(temp_file)

# tiempo_fin <- Sys.time()

# Cálculo del tiempo transcurrido
# tiempo_transcurrido <- tiempo_fin - tiempo_inicio
# ~0h:??mins