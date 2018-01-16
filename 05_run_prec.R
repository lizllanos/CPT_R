# Created in: October 2017
# Made by: Lizeth Llanos, Diego Agudelo and Alejandra Esquivel
# Description: This script run the cpt version in batch for windows from R. This will be use for the forecast evaluation in Honduras


# Function Run CPT batch -----------------------------------------------------------


setwd("D:\\OneDrive - CGIAR\\Tobackup\\Desktop_111717\\cpt_batch/prec")
dir.create("output")

run_cpt=function(x,y,trim,GI,pear,afc,prob,roc_a,roc_b,cc,path_run,m_x,m_y,m_cca,t, n_training,x_load, 
                 x_serie,y_load, y_serie,det_forecast,det_forecast_limit,clim, y_for,
                 pear_rt,afc_rt,prob_rt,roc_a_rt,roc_b_rt,det_forecast_rt,det_forecast_limit_rt,n_ret){
    cmd <- "@echo off
  (
  echo 611
  echo 1
  echo %path_x%
  echo 34
  echo -6
  echo -123
  echo -49
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
  echo 6
  echo %y_for%
  echo 532
  echo 1981
  echo %clim%
  echo N
  echo %trim%
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
  echo %n_ret% 
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
  echo 411
  echo %path_x_load%
  echo 412
  echo %path_x_serie%
  echo 421
  echo %path_y_load%
  echo 422
  echo %path_y_serie%
  echo 511
  echo %path_det_forecast%
  echo 513
  echo %path_det_forecast_limit%
    echo 203
    echo %path_prob_rt%
    echo 202
    echo %path_det_forecast_rt%
    echo 204
    echo %path_det_forecast_limit_rt%
    echo 401
    echo %path_cc%
    echo 0
  
    echo 423
    echo 1
    echo %path_pear_rt%
    echo 423
    echo 3
    echo %path_2afc_rt%
    echo 423
    echo 10
    echo %path_roc_b_rt%
    echo 423
    echo 11
    echo %path_roc_a_rt%
   
  
  echo 0
  ) | CPT_batch.exe"
  
  cmd<-gsub("%y_for%",y_for,cmd)
  cmd<-gsub("%clim%",clim,cmd)
  cmd<-gsub("%n_ret%",n_ret,cmd)
  cmd<-gsub("%path_x%",x,cmd)
  cmd<-gsub("%path_y%",y,cmd)
  cmd<-gsub("%path_GI%",GI,cmd)
  cmd<-gsub("%path_pear%",pear,cmd)
  cmd<-gsub("%path_2afc%",afc,cmd)
  cmd<-gsub("%path_roc_b%",roc_b,cmd)
  cmd<-gsub("%path_roc_a%",roc_a,cmd)
  cmd<-gsub("%path_prob%",prob,cmd)
  
  cmd<-gsub("%path_pear_rt%",pear_rt,cmd)
  cmd<-gsub("%path_2afc_rt%",afc_rt,cmd)
  cmd<-gsub("%path_roc_b_rt%",roc_b_rt,cmd)
  cmd<-gsub("%path_roc_a_rt%",roc_a_rt,cmd)
  cmd<-gsub("%path_prob_rt%",prob_rt,cmd)
  
  
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

  cmd<-gsub("%path_det_forecast_rt%",det_forecast_rt,cmd)
  cmd<-gsub("%path_det_forecast_limit_rt%",det_forecast_limit_rt,cmd)
  cmd<-gsub("%trim%",trim,cmd)
  
  write(cmd,path_run)
  system(path_run, ignore.stdout = T, show.output.on.console = T)
  
}



# Run for all the input files -------------------------------------------------
x.files = list.files("input/CFSV2/")

for (i in 1:length(x.files)){
  
  out.name = paste0(sprintf("%02d",which(month.abb==substring(x.files[i],5,7))),"_",substring(x.files[i],1,15),"_")
  trim = ifelse(x.files[i]=="Feb_Aug-Sep-Oct.tsv",1,2)
  clim = ifelse(substring(x.files[i],5,7)=="Dec",2014,2015)
  y_for = ifelse(substring(x.files[i],5,7)=="Dec",2015,2016)
  n_training = ifelse(substring(x.files[i],5,7)=="Dec" | x.files[i]=="Sep_Mar-Apr-May.tsv" | x.files[i]=="Nov_Mar-Apr-May.tsv" |x.files[i]=="Oct_Apr-May-Jun.tsv" |x.files[i]=="Dec_Apr-May-Jun.tsv",33,34)
  n_ret = ifelse(substring(x.files[i],5,7)=="Dec" | x.files[i]=="Sep_Mar-Apr-May.tsv" | x.files[i]=="Nov_Mar-Apr-May.tsv" |x.files[i]=="Oct_Apr-May-Jun.tsv" |x.files[i]=="Dec_Apr-May-Jun.tsv",23,24)
  
  run_cpt(x = paste0("input/CFSV2/",x.files[i]),y="input/honduras_chirps_data.txt", trim=trim,
        GI=paste0("output/",out.name,"goodness_index.txt"),pear=paste0("output/",out.name,"pearson.txt"),afc=paste0("output/",out.name,"kendall.txt"),
        prob=paste0("output/",out.name,"prob.txt"),cc=paste0("output/",out.name,"modos_cc.txt"),path_run=paste0("run_",out.name,".bat"),m_x=10,m_y=10,m_cca=5,t=541,
        x_load=paste0("output/",out.name,"x_load.txt"), x_serie=paste0("output/",out.name,"x_serie.txt"),y_load=paste0("output/",out.name,"y_load.txt"),
        y_serie=paste0("output/",out.name,"y_serie.txt"),det_forecast=paste0("output/",out.name,"det_forecast.txt"),det_forecast_limit=paste0("output/",out.name,"det_forecast_limit.txt"),
        roc_a=paste0("output/",out.name,"roc_a.txt"),roc_b=paste0("output/",out.name,"roc_b.txt"),
        det_forecast_rt=paste0("output/",out.name,"det_forecast_rt.txt"),det_forecast_limit_rt=paste0("output/",out.name,"det_forecast_limit_rt.txt"),
        roc_a_rt=paste0("output/",out.name,"roc_a_rt.txt"),roc_b_rt=paste0("output/",out.name,"roc_b_rt.txt"),
        pear_rt=paste0("output/",out.name,"pearson_rt.txt"),afc_rt=paste0("output/",out.name,"kendall_rt.txt"),prob_rt=paste0("output/",out.name,"prob_rt.txt"),
        n_training = n_training , n_ret = n_ret, clim = clim, y_for =y_for)

  rm(out.name)
  gc(reset = TRUE)
  
}

