library(dplyr)


# Esta funcion crea el bash para correr en la consola de linux cada corrida de CPT
# x_predictors = predictores de la TSM generados con el codigo de las areas predictoras (ruta)
# y_predicting = archivos de cada departamento (ruta)
# dir_output = directorio de salida donde se guardan los resultados 
# modes = archivo de configuraciones, en las filas se tinen: 
# x_modes, y_modes, cca_modes, trasformation (corregir esto si esta mal)
run_cpt<-function (x_predictors, y_predicting, dir.output, dir.output.GF, name){
  # cmd corresponde al bash que se guarda automaticamente con los outputs  
  cmd <- "@echo off
  
  (
  echo 611
  echo 1
  echo %X_PREDICTORS%
  echo 30
  echo -30
  echo 0
  echo 359
  echo 1
  echo 5
  echo 2
  echo %Y_PREDICTING%
  echo 13
  echo -4
  echo -79
  echo -67
  echo 1
  echo 5
  echo 1
  echo 3
  echo 9
  echo 1
  echo 7
  echo 32
  echo 554
  echo 2
  echo 541
  echo 112
  echo %RESULT_GI%
  echo 312
  echo 23
  echo 1
  echo 451
  echo 452
  echo 454
  echo 455
  echo 413
  echo 1
  echo %Pearson%
  echo 111
  echo 401
  echo %Canonical%
  echo 203
  echo %RESULT_PROB%
  echo 0
  echo 0
  ) | CPT_batch.exe"
  
 
  cmd<-gsub("%X_PREDICTORS%",x_predictors,cmd)
  cmd<-gsub("%Y_PREDICTING%",y_predicting,cmd)
  cmd<-gsub("%RESULT_GI%",paste0(dir.output.GF,"/GI_",name,".txt"),cmd)
  cmd<-gsub("%Pearson%",paste0(dir.output.GF,"/Pcor_",name,".txt"),cmd)
  cmd<-gsub("%Canonical%",paste0(dir.output.GF,"/CanonicalC_",name,".txt"),cmd)
  cmd<-gsub("%RESULT_PROB%",paste0(dir.output.GF,"/ForecastProb_",name,".txt"),cmd)
  
  write(cmd,paste0( dir.output, "/text",name,".bat"))
  system(paste0( dir.output, "/text",name,".bat"), ignore.stdout = T, show.output.on.console = F)
  
#  if(file.exists(paths = paste0(dir.output.G, "text.bat")) == TRUE){
#    file.remove(paste0(dir.output.G, "text.bat")) }
  
}



# root - donde se encuentra toda la informacion de entrada 
#        y se desea la de salida 
root <- "C:/Users/AESQUIVEL/Google Drive/leo_jefer_Files/Climate_Preliminar/cpt_data/"
setwd(root)
getwd()

crop <- "Maize"

initial_conditions <- paste0(root, "SST/", crop)
locations_folder <- paste0(root, "deparments")
# directorio donde se guardan todas las salidas 
dir.output.G <-  paste0("C:/Users/AESQUIVEL/Google Drive/leo_jefer_Files/Climate_Preliminar/cpt_data/Results/", crop)
### En este directorio se van a guardar los bash para correr el programa 
dir.output <- "C:/Users/AESQUIVEL/Desktop/outputs"

crop.table <- read.delim("clipboard")



# Esta funcion corre cpt y guarda los archivos para todos los trimestres en un departamento
for(i in 1:dim(crop.table)[1]){
  # cree un directorio con el nombre del departamento en caso de ser necesario
  
month <- crop.table$First_Month[i] - 2 ;  if(month<=0)month=month + 12
cat(paste0(" Initial Condition (", crop.table$Township[i], " - " , month, "):\n ", month.abb[month]))


season <- (month)+(0:6)
if(sum(season>12)>0)season[which(season>12)]=season[which(season>12)]-12
if(sum(season<1)>0)season[which(season<1)]=season[which(season<1)]+12


names <-sapply(season[-1], FUN  = function(s){last <- seq(s, s + 2)
last <- ifelse(test = last== 13, yes = 1, no = last) ; last <- ifelse(test = last== 14, yes = 2, no = last)
trim <- paste(substring(month.abb, 1, 1)[last], collapse = '') 
return(trim)}, simplify = FALSE)  %>% unlist()

x <- paste0(crop.table$Township[i], "_initial_", month.abb[month])

  if(dir.exists(paths = paste0(dir.output.G,"/", x)) == FALSE){dir.create(path = paste0(dir.output.G,"/", x))}
  
  # y: direccion del archivo de estaciones
  y_predicting <- paste0( locations_folder, "/", crop.table$Department[i],".txt")
  # x: direccion de los archivos de la tsm
  x_predictors <- list.files(path =  paste0( initial_conditions, "/", x, "/"), full.names = TRUE)
  
 name <- paste0(substring(crop.table$Crop[i],1,1), 1:6,  "_", crop.table$Township[i], "_", names, "_month_", month.abb[month])
 dir.output.GF <- paste0(dir.output.G,"/", x)
  
  # Corre cpt y guarda los archivos para todos los trimestres de un departamento
  mapply(run_cpt, x_predictors, y_predicting, dir.output, dir.output.GF, name, SIMPLIFY = FALSE)
  
}
gc(reset = TRUE)

