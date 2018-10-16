library(ggplot2)

# Heat maps ---------------------------------------------------------------


# ERSST -------------------------------------------------------------------

data_ersst <- read.table("clipboard", header = T)
data_ersst <- data_ersst[data_ersst$years>2006 & data_ersst$years<2017,]

data_ersst$trimester <- factor(data_ersst$trimester,labels = c("MAM","AMJ","ASO","DEF"))
data_ersst$selection <- factor(data_ersst$selection,labels = c("Optimized", "Complete"))

# data_ersst2 = data_ersst[data_ersst$variable_y=="CHIRPS",]
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


m_cfs <- aggregate(data_cfs$goodness,list(data_cfs$selection, data_cfs$trimester),mean)
md_cfs <- aggregate(data_cfs$goodness,list(data_cfs$selection, data_cfs$trimester),median)
sd_cfs <- aggregate(data_cfs$goodness,list(data_cfs$selection, data_cfs$trimester),sd)

result <- data.frame(m_cfs,md_cfs$x, sd_cfs$x)
d_test <- matrix(NA, 4,4)
for (trim in 1:4){
  dif <- data_cfs$goodness[data_cfs$selection=="Complete" & data_cfs$trimester==unique(data_cfs$trimester)[trim]]-data_cfs$goodness[data_cfs$selection=="Optimized" & data_cfs$trimester==unique(data_cfs$trimester)[trim]]
  test <- wilcox.test(dif, conf.int=T)
  d_test[trim,1:2] <- test$conf.int
  d_test[trim,3] <- test$p.value
  d_test[trim,4] <- test$estimate
  
}



# geom bar ----------------------------------------------------------------

data_bar <- read.table("clipboard", header = T)
data_bar
x11()
ggplot(data_bar, aes(x=trim, y=diff, group=1)) +
  geom_point() +
  geom_errorbar(width=.1, aes(ymin=Li, ymax=Ls), colour="red")+
  labs(x = "Season", y="Difference")
ggsave("interval.tiff")
