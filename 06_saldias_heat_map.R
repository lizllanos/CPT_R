library(ggplot2)
data_ersst <- read.table("clipboard", header = T)

ggplot(data_ersst, aes(lead, as.factor(trimester), fill = goodness)) + 
  geom_tile(colour = "white") + 
  facet_grid(variable_y~selection) + 
  scale_fill_gradient(low="red", high="green") +scale_y_discrete( labels = c("MAM","AMJ","ASO","DEF"))+
  labs(x="Lead Time",  y="Trimestre", fill="Goodnes Index")

ggsave("heat_map_ersst.tiff")

data_cfs <- read.table("clipboard", header = T)

ggplot(data_cfs, aes(lead, as.factor(trimester), fill = goodness)) + 
  geom_tile(colour = "white") + 
  facet_grid(variable_y~selection) + 
  scale_fill_gradient(low="red", high="green") +scale_y_discrete( labels = c("MAM","AMJ","ASO","DEF"))+
  labs(x="Lead Time",  y="Trimestre", fill="Goodnes Index")

ggsave("heat_map_cfs.tiff")
