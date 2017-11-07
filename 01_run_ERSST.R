run_cpt=function(x,y,i_fores,path_run,output){
  
  GI=paste0(output,"_goodness_index.txt"); pear=paste0(output,"_pearson.txt"); afc=paste0(output,"_kendall.txt")
  prob=paste0(output,"_prob.txt"); cc=paste0(output,"_modos_cc.txt"); x_load=paste0(output,"_x_load.txt"); x_serie=paste0(output,"_x_serie.txt"); y_load=paste0(output,"_y_load.txt") 
  y_serie=paste0(output,"_y_serie.txt"); det_forecast=paste0(output,"_det_forecast.txt"); det_forecast_limit=paste0(output,"_det_forecast_limit.txt")
  roc_a=paste0(output,"_roc_a.txt");roc_b=paste0(output ,"_roc_b.txt")
  
  cmd <- "@echo off
  (
  echo 611
  echo 545
  echo 1
  echo %path_x% 
  echo 30
  echo -30
  echo 0
  echo 359
  echo 1
  echo 10
  echo 2
  echo %path_y% 
  echo 17
  echo 13
  echo -90
  echo -83
  echo 1
  echo 10
  echo 1
  echo 5
  echo 9
  echo 1
  echo 213
  echo %i_for% 
  echo 3
  echo 3
  echo 532
  echo 1981
  echo 2015
  echo N
  echo 2
  echo 7
  echo 35
  echo 554
  echo 2
  echo 541
  echo 112
  echo %path_GI%
  echo 312 
  echo 24 
  echo 1
  echo 451
  echo 454
  echo 455
  echo 413
  echo 1
  echo %path_pear%
  echo 413
  echo 3
  echo %path_2afc%
  echo 413
  echo 10
  echo %path_roc_b%
  echo 413
  echo 11
  echo %path_roc_a%
  echo 111
  echo 501
  echo %path_prob%
  echo 111
  echo 411
  echo %path_x_load%
  echo 111
  echo 412
  echo %path_x_serie%
  echo 111
  echo 421
  echo %path_y_load%
  echo 111
  echo 422
  echo %path_y_serie%
  echo 111
  echo 511
  echo %path_det_forecast%
  echo 111
  echo 513
  echo %path_det_forecast_limit%
  echo 401
  echo %path_cc%
  echo 0
  echo 0
  ) | CPT_batch.exe"
  
  cmd<-gsub("%path_x%",x,cmd)
  cmd<-gsub("%path_y%",y,cmd)
  cmd<-gsub("%path_GI%",GI,cmd)
  cmd<-gsub("%path_pear%",pear,cmd)
  cmd<-gsub("%path_2afc%",afc,cmd)
  cmd<-gsub("%path_roc_b%",roc_b,cmd)
  cmd<-gsub("%path_roc_a%",roc_a,cmd)
  cmd<-gsub("%path_prob%",prob,cmd)
  cmd<-gsub("%path_cc%",cc,cmd)
  
  
  cmd<-gsub("%i_for%",i_fores,cmd)
  cmd<-gsub("%path_x_load%",x_load,cmd)
  cmd<-gsub("%path_x_serie%",x_serie,cmd)
  cmd<-gsub("%path_y_load%",y_load,cmd)
  cmd<-gsub("%path_y_serie%",y_serie,cmd)
  cmd<-gsub("%path_y_serie%",y_serie,cmd)
  cmd<-gsub("%path_det_forecast%",det_forecast,cmd)
  cmd<-gsub("%path_det_forecast_limit%",det_forecast_limit,cmd)
  
  
  write(cmd,path_run)
  system(path_run, ignore.stdout = T, show.output.on.console = T)
  
}

main_dir <- "C:/Users/dagudelo/Desktop/CPT"
names_x <- list.files(paste0(main_dir,"/input/ERSST"))
output <- paste0(main_dir,"/output/",substring(names_x,1,nchar(names_x)-4))

x <- list.files(paste0(main_dir,"/input/ERSST"),full.names = T)
y <- list.files(paste0(main_dir,"/input/stations"),full.names = T)
i_fores <- sapply(names_x,function(x) as.numeric(substring(x,1,2)))
path_run <- paste0(main_dir,"/",substring(names_x,1,nchar(names_x)-4),".bat") 

Map(run_cpt,x,y,i_fores,path_run,output)
