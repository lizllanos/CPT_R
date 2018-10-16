library(ggplot2)

# Heat maps ---------------------------------------------------------------


# ERSST -------------------------------------------------------------------

data_ersst <- read.table("clipboard", header = T)
data_ersst <- data_ersst[data_ersst$years>2006 & data_ersst$years<2017,]

data_ersst$trimester <- factor(data_ersst$trimester,labels = c("MAM","AMJ","ASO","DEF"))
data_ersst$selection <- factor(data_ersst$selection,labels = c("Optimized", "Complete"))

 data_ersst2 = data_ersst[data_ersst$variable_y=="CHIRPS",]
# data_ersst3 = data_ersst[data_ersst$variable_y=="Observado",]

x11()
ggplot(data_ersst2, aes( as.factor(years),lead, fill = goodness)) + 
  geom_tile(colour = "white") + 
  facet_grid(as.factor(trimester)~selection) + 
  scale_fill_gradient(low="red", high="green") +#scale_y_discrete( labels = c("MAM","AMJ","ASO","DEF"))+
  labs(y="Lead Time",  y=" ", fill="Goodnes Index")

ggsave("heat_map_ersst_chirps.tiff")

# ggplot(data_ersst3, aes( as.factor(years),lead, fill = goodness)) + 
#   geom_tile(colour = "white") + 
#   facet_grid(as.factor(trimester)~selection) + 
#   scale_fill_gradient(low="red", high="green") +#scale_y_discrete( labels = c("MAM","AMJ","ASO","DEF"))+
#   labs(y="Lead Time",  y=" ", fill="Goodnes Index")
# 
# ggsave("heat_map_ersst_obs.tiff")
# 
# 
# # CFSv2 -------------------------------------------------------------------


data_cfs <- read.table("clipboard", header = T)
data_cfs <- data_cfs[data_cfs$years>2006 & data_cfs$years<2017,]

data_cfs$trimester <- factor(data_cfs$trimester,labels = c("MAM","AMJ","ASO","DEF"))
data_cfs$selection <- factor(data_cfs$selection,labels = c("Optimized", "Complete"))

# data_cfs2 = data_cfs[data_cfs$variable_y=="CHIRPS",]
# data_cfs3 = data_cfs[data_cfs$variable_y=="Observado",]


ggplot(data_cfs2, aes( as.factor(years),lead, fill = goodness)) + 
  geom_tile(colour = "white") + 
  facet_grid(as.factor(trimester)~selection) + 
  scale_fill_gradient(low="red", high="green") +#scale_y_discrete( labels = c("MAM","AMJ","ASO","DEF"))+
  labs(y="Lead Time",  y=" ", fill="Goodnes Index")

ggsave("heat_map_cfs_chirps.tiff")

# ggplot(data_cfs3, aes( as.factor(years),lead, fill = goodness)) + 
#   geom_tile(colour = "white") + 
#   facet_grid(as.factor(trimester)~selection) + 
#   scale_fill_gradient(low="red", high="green") +#scale_y_discrete( labels = c("MAM","AMJ","ASO","DEF"))+
#   labs(y="Lead Time",  y=" ", fill="Goodnes Index")
# 
# ggsave("heat_map_cfs_obs.tiff")
# 
# 

# Density plot ------------------------------------------------------------
x11()
ggplot(data_cfs, aes(goodness, fill = selection, colour = selection)) +
  geom_density(alpha = 0.1) +facet_grid(as.factor(trimester)~variable_y)+
  labs(x="Goodness Index",  y="Density", colour="Predictive Area")+ scale_fill_discrete(guide=FALSE)

ggsave("density_cfs.tiff")

x11()
ggplot(data_ersst, aes(goodness, fill = selection, colour = selection)) +
  geom_density(alpha = 0.1) +facet_grid(as.factor(trimester)~variable_y)+
  labs(x="Goodness Index",  y="Density", colour="Predictive Area")+ scale_fill_discrete(guide=FALSE)

ggsave("density_ersst.tiff")


# Resumenes ---------------------------------------------------------------
# m_cfs <- aggregate(data_cfs$goodness,list(data_cfs$selection, data_cfs$trimester),mean)
# md_cfs <- aggregate(data_cfs$goodness,list(data_cfs$selection, data_cfs$trimester),median)
# sd_cfs <- aggregate(data_cfs$goodness,list(data_cfs$selection, data_cfs$trimester),sd)

#result <- data.frame(m_cfs,md_cfs$x, sd_cfs$x)

# Test para cfsv2
data_cfs_c <- data_cfs[data_cfs$variable_y=="CHIRPS",]

d_test_c <- matrix(NA, 4,4)
for (trim in 1:4){
  dif <- data_cfs_c$goodness[data_cfs_c$selection=="Sin_Seleccion" & data_cfs_c$trimester==unique(data_cfs_c$trimester)[trim]]-data_cfs_c$goodness[data_cfs_c$selection=="Con_Seleccion" & data_cfs_c$trimester==unique(data_cfs_c$trimester)[trim]]
  test <- wilcox.test(dif, conf.int=T)
  d_test_c[trim,1:2] <- test$conf.int
  d_test_c[trim,3] <- test$p.value
  d_test_c[trim,4] <- test$estimate
  
}

data_cfs_o <- data_cfs[data_cfs$variable_y=="Observed",]

d_test_o <- matrix(NA, 4,4)
for (trim in 1:4){
  dif <- data_cfs_o$goodness[data_cfs_o$selection=="Sin_Seleccion" & data_cfs_o$trimester==unique(data_cfs_o$trimester)[trim]]-data_cfs_o$goodness[data_cfs_o$selection=="Con_Seleccion" & data_cfs_o$trimester==unique(data_cfs_o$trimester)[trim]]
  test <- wilcox.test(dif, conf.int=T)
  d_test_o[trim,1:2] <- test$conf.int
  d_test_o[trim,3] <- test$p.value
  d_test_o[trim,4] <- test$estimate
  
}

all_cfs_t <- cbind(y = rep(c("CH","Ob" ),each=4),rbind(d_test_c,d_test_o))
rm(d_test_c, d_test_o)

# test para ersst
data_ersst_c <- data_ersst[data_ersst$variable_y=="CHIRPS",]

d_test_c <- matrix(NA, 4,4)
for (trim in 1:4){
  dif <- data_ersst_c$goodness[data_ersst_c$selection=="Sin_Seleccion" & data_ersst_c$trimester==unique(data_ersst_c$trimester)[trim]]-data_ersst_c$goodness[data_ersst_c$selection=="Con_Seleccion" & data_ersst_c$trimester==unique(data_ersst_c$trimester)[trim]]
  test <- wilcox.test(dif, conf.int=T)
  d_test_c[trim,1:2] <- test$conf.int
  d_test_c[trim,3] <- test$p.value
  d_test_c[trim,4] <- test$estimate
  
}

data_ersst_o <- data_ersst[data_ersst$variable_y=="Observed",]

d_test_o <- matrix(NA, 4,4)
for (trim in 1:4){
  dif <- data_ersst_o$goodness[data_ersst_o$selection=="Sin_Seleccion" & data_ersst_o$trimester==unique(data_ersst_o$trimester)[trim]]-data_ersst_o$goodness[data_ersst_o$selection=="Con_Seleccion" & data_ersst_o$trimester==unique(data_ersst_o$trimester)[trim]]
  test <- wilcox.test(dif, conf.int=T)
  d_test_o[trim,1:2] <- test$conf.int
  d_test_o[trim,3] <- test$p.value
  d_test_o[trim,4] <- test$estimate
  
}

all_ersst_t <- cbind(y = rep(c("CH","Ob" ),each=4),rbind(d_test_c,d_test_o))

rm(d_test_c, d_test_o)


# geom bar ----------------------------------------------------------------

data_bar <- read.table("clipboard", header = T)
data_bar
x11()
ggplot(data_bar, aes(x=trimester, y=diff, group=1)) +
  geom_point() +
  geom_errorbar(width=.1, aes(ymin=Li, ymax=Ls), colour="red")+
  labs(x = "Season", y="Difference")+facet_grid(as.factor(variable_y)~variable_x)
ggsave("interval.tiff")
