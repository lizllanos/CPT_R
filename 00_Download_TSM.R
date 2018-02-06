########### Packages ###############

if(require(stringr)==FALSE){install.packages("stringr",dependencies = TRUE)}
library("stringr")

######## download TSM CFSV2 ###########

download_CFSV2_CPT=function(firs_year,last_year,i_month,ic,dir_save){
   
  lead <- i_month-ic
  if(lead<0)lead <- lead + 12
  route <- paste0("http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.ENSEMBLE/.OCNF/.surface/.TMP/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.REALTIME_ENSEMBLE/.OCNF/.surface/.TMP/appendstream/350/maskge/S/%280000%201%20",month.abb[ic],"%20",firs_year,"-",last_year,"%29VALUES/L/",lead,".5/",lead+2,".5/RANGE%5BL%5D//keepgrids/average/M/1/24/RANGE%5BM%5Daverage/Y/%2830%29%28-30%29RANGEEDGES/X/%280%29%28359%29RANGEEDGES/-999/setmissing_value/%5BX/Y%5D%5BS/L/add%5Dcptv10.tsv.gz")
  
  trimestrel <- (ic+lead):(ic+lead+2)
  if(sum(trimestrel>12)>0)trimestrel[which(trimestrel>12)]=trimestrel[which(trimestrel>12)]-12
  path_save <- paste0(dir_save,"/",month.abb[ic],"_",paste(month.abb[trimestrel],collapse = "-"),".tsv.gz")
  download.file(route,path_save)
  return(paste("Successful download",path_save))
}

i_month <- c(12,3,4,8,12,3,4,8,12,3,4,8)
ic <- c(11,2,3,7,8,11,12,4,6,9,10,2)
firs_year <- 1981
last_year <- 2016
dir_save <- "D:/OneDrive - CGIAR/Tobackup/Desktop_111717/cpt_batch/tsm/ersst/input"

Map(download_CFSV2_CPT,firs_year,last_year,i_month,ic,dir_save)

######## download TSM ERSST #############

download_ERSST_CPT=function(firs_year,last_year,i_month,l_season,dir_save,m_for){

  trimestrel <- i_month:(i_month+l_season-1)
  if(sum(trimestrel>12)>0)trimestrel[which(trimestrel>12)]=trimestrel[which(trimestrel>12)]-12
  route <- paste0("http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCDC/.ERSST/.version4/.sst/T/%28", month.abb[trimestrel[1]] ,"%20", firs_year ,"%29%28",  month.abb[trimestrel[l_season]] ,"%20", last_year ,"%29RANGEEDGES/T/", l_season ,"/boxAverage/T/12/STEP/Y/%2830%29%28-30%29RANGEEDGES/X/%280%29%28359%29RANGEEDGES/-999/setmissing_value/Y/high/low/RANGE/%5BX/Y%5D%5BT%5Dcptv10.tsv.gz")
  m_for_final=str_pad(m_for, 2, pad = "0")
  path_save <- paste0(dir_save,"/",m_for_final,"_",paste(month.abb[trimestrel],collapse = "-"),".tsv.gz")
  download.file(route,path_save)
  return("Successful download")
  
}
  
trim <- c(12,3,4,8,11,2,3,7,8,11,12,4)
len <- c(3,3,3,3,1,1,1,1,1,1,1,1)
i_for <- c(12,3,4,8,12,3,4,8,12,3,4,8)
firs_year <- 1981
last_year <- 2016
dir_save <- "C:/Users/dagudelo/Desktop/ERSST"

Map(download_ERSST_CPT,firs_year,last_year,trim,len,dir_save,i_for)

######## download Prec CFSv2 #############

download_prec_CPT=function(firs_year,last_year,i_month,ic,dir_save){
  
  lead <- i_month-ic
  if(lead<0)lead <- lead + 12
  
  route <- paste0("http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.ENSEMBLE/.FLXF/.surface/.PRATE/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.REALTIME_ENSEMBLE/.FLXF/.surface/.PRATE/appendstream/S/(0000%201%20",month.abb[ic],"%20",firs_year,"-",last_year,")VALUES/L/",lead,".5/",lead+2,".5/RANGE[L]//keepgrids/average/M/1/24/RANGE[M]average/c://name//water_density/def/998/(kg/m3):c/div/(mm/day)unitconvert/-999/setmissing_value/[X/Y][S/L/add]cptv10.tsv.gz")
  
  trimestrel <- (ic+lead):(ic+lead+2)
  if(sum(trimestrel>12)>0)trimestrel[which(trimestrel>12)]=trimestrel[which(trimestrel>12)]-12
  path_save <- paste0(dir_save,"/",month.abb[ic],"_",paste(month.abb[trimestrel],collapse = "-"),".tsv.gz")
  download.file(route,path_save)
  return(paste("Successful download",path_save))
}

i_month <- c(12,3,4,8,12,3,4,8,12,3,4,8)
ic <- c(11,2,3,7,8,11,12,4,6,9,10,2)
firs_year <- 1981
last_year <- 2016
dir_save <- "C:/Users/lllanos/Desktop/Prec_CFSv2"

Map(download_CFSV2_CPT,firs_year,last_year,i_month,ic,dir_save)

