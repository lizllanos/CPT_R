if(require(ggplot2)==FALSE){install.packages("ggplot2")}
library("ggplot2")

path <- "C:/Users/dagudelo/Desktop/CPT/output" 

all_path <- list.files(path,pattern = "index",full.names = T)

name_files <- basename(all_path)
names_month <- as.numeric(substr(name_files,1,2))
lead <- function(x){ 
  
  month=as.numeric(substr(x,1,2))
  l=substr(x,4,6)
  if(month.abb[month]==l)out <- "LT-Sim"
  else if(month.abb[month-1]==l)out <- "LT-0"
  else out <- "LT-3"
  return(out)
  
}
lead_times<- sapply(name_files,lead,USE.NAMES = F)

data <- lapply(all_path,function(x)read.table(x,skip=3,dec=".",fill=TRUE,stringsAsFactors=FALSE))
pos_good <- lapply(data,function(x)c(which(x[,1]=="Training")-1,dim(x)[1]))
value_good <- Map(function(x,y)as.numeric(x[y,8]),data,pos_good)
 
data_combi <- Map(function(x,y,z) cbind.data.frame(trimester=z,lead=x,goodness=y),lead_times,value_good,names_month)
data_final <- do.call(what = "rbind",args =data_combi)
data_final$lead=factor(data_final$lead,levels(data_final$lead)[c(2,1,3)])

box <- ggplot(data_final, aes(as.factor(trimester), goodness, fill = lead))
box <- box + scale_x_discrete( labels = c("MAM","AMJ","ASO","DEF"))
box <- box + geom_boxplot( width=0.6, position = position_dodge(width = 0.7))
box <- box + labs(y="Goodness index", x="Season",fill="Lead Time")
box

