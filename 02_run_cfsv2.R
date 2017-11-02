# Created in: October 2017
# Made by: Lizeth Llanos, Diego Agudelo and Alejandra Esquivel
# Description: This script run the cpt version in batch for windows from R. This will be use for the forecast evaluation in Honduras


# Function Run CPT batch -----------------------------------------------------------


setwd("C:/Users/lllanos/Desktop/cpt_batch")
dir.create("output")

run_cpt=function(x,y,GI,pear,afc,prob,roc_a,roc_b,cc,path_run,m_x,m_y,m_cca,t, n_training,x_load, x_serie,y_load, y_serie,det_forecast,det_forecast_limit){
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
  echo %mode_x%
  echo 2
  echo %path_y%
  echo 17
  echo 13
  echo -90
  echo -83
  echo 1
  echo %mode_y%
  echo 1
  echo %mode_cca%
  echo 532
  echo 1981
  echo 2015
  echo N
  echo 2
  echo 9
  echo 1
  echo 7
  echo %training%
  echo 554
  echo 2
  echo %transfor%
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
  cmd<-gsub("%mode_x%",m_x,cmd)
  cmd<-gsub("%mode_y%",m_y,cmd)
  cmd<-gsub("%mode_cca%",m_cca,cmd)
  cmd<-gsub("%transfor%",t,cmd)
  cmd<-gsub("%training%",n_training,cmd)
  
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

x.files = list.files("input/CFSV2/")


# Run for all the input files -------------------------------------------------


for (i in 1:length(x.files)){
  out.name = paste0(which(month.abb==substring(x.files[i],5,7)),"_",substring(x.files[i],1,15),"_")
  run_cpt(x = paste0("input/CFSV2/",x.files[i]),y="input/honduras_chirps_data.txt",
        GI=paste0("output/",out.name,"goodness_index.txt"),pear=paste0("output/",out.name,"pearson.txt"),afc=paste0("output/",out.name,"kendall.txt"),
        prob=paste0("output/",out.name,"prob.txt"),cc=paste0("output/",out.name,"modos_cc.txt"),path_run="run.bat",m_x=5,m_y=5,m_cca=3,t=541,
        x_load=paste0("output/",out.name,"x_load.txt"), x_serie=paste0("output/",out.name,"x_serie.txt"),y_load=paste0("output/",out.name,"y_load.txt"), 
        y_serie=paste0("output/",out.name,"y_serie.txt"),det_forecast=paste0("output/",out.name,"det_forecast.txt"),det_forecast_limit=paste0("output/",out.name,"det_forecast_limit.txt"),
        roc_a=paste0("output/",out.name,"roc_a.txt"),roc_b=paste0("output/",out.name,"roc_b.txt"),
        n_training = ifelse(x.files[i]=="Sep_Mar-Apr-May.tsv" | x.files[i]=="Nov_Mar-Apr-May.tsv" |x.files[i]=="Oct_Apr-May-Jun.tsv" |x.files[i]=="Dec_Apr-May-Jun.tsv",34,35))

  rm(out.name)
  gc(reset = TRUE)
  
}

