get_plot<- function(data,type,slider,day) {

day_data <- eval(parse(text=(paste("data %>% dplyr::select(version,",day,")"))))
names(day_data) <- c("version","retention")

	
	if(type=="bar"){
		
		plot <- day_data %>% 
			group_by(version) %>% 
			summarise(mean_retention_by_gate=mean(retention)) %>% 
			ggplot(aes(x=version,y=mean_retention_by_gate,label=round(mean_retention_by_gate,2)*100))+
			geom_bar(width=0.5,aes(fill=version),stat="identity")+
			theme(legend.position="None",
						plot.background = element_blank(),
						panel.background = element_rect(color="white",fill="NA"))+
			ggtitle(label="Retention Mean")+
			scale_y_continuous(labels=scales::percent,limits=c(0,0.45),breaks=seq(0,0.5,by=0.01))+
			geom_text(size = 3, position = position_stack(vjust = 0.5))
		
		return(plot)
		
	}else if(type=="boot"){
		
		boot_sample <- data.frame(gate_30=numeric(),gate_40=numeric())
		
		for(i in 1:slider){
			boot_sample[i, ]  <- day_data[sample(1:nrow(day_data), nrow(day_data), replace = TRUE), ]%>% 
				group_by(version) %>% summarise(mean_gate = mean(retention)) %>% ungroup() %>% spread(version, mean_gate)
		}
		
		plot <- boot_sample %>% 
			gather(key=version,value=value) %>% 
			ggplot(aes(x=value,group=version))+
			geom_density(aes(fill=version),alpha=0.5)+
			theme(legend.position="bottom",
						plot.background = element_blank(),
						panel.background = element_rect(color="white",fill="NA"))+
			ggtitle(label="Retention Bootstrapped Sample Mean")
		
		return(plot)
	}
	
	
	
}
