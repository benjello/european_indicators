## @knitr preproc_data
# cr�e une data.frame "procdata" qui contient tous les pays de l'UE, 
# avec les 10 indicateurs jusqu'au dernier point connu, s�par�s entre pays 
# de la zone euro et les autres. 

rm(list = ls())
setwd("C:/Users/Utilisateur/Dropbox/GraphR/six_pack")
library(ggplot2)
library(lubridate)
source("../macroR/getFromEurostat.R")

files <- list("tipsbp10","tipsbp20","tipsbp40",
              "tipsii10","tipsii20","tipsii30","tipsii40",
              "tipser10","tipser20",
              "tipsex10","tipsex20",
              "tipslm10","tipslm20","tipslm40",
              "tipsho10","tipsho20","tipsho30",
              "tipspc10","tipspc20","tipspc30",
              "tipspd10","tipspd20","tipspd30",
              "tipsgo10","tipsgo20",
              "tipsun10","tipsun20","tipsun30",
              "tipsfs10","tipsfs20")

names <- list("Compte courant, % du PIB (moy. 3 ans)","caA","caQ",
              "Position ext. nette de l'investissement, % du PIB","nfaA","nfaQ","nfaIQ",
              "Taux de change effectif r�el (var. 3 ans)","eerZE",
              "Part de march� des exportations (var. 5 ans)","expA",
              "Co�t salarial unitaire nominal (var. 3 ans)","ulcA","ulcQ",
              "Indice prix des logements d�flat� (tx de croissance)","hpA","hpQ",
              "Cr�dit priv�, % du PIB","crA","crQ",
              "Dette priv�e, % du PIB","pdA","pdQ",
              "Dette publique, % du PIB","dQ",
              "Taux de ch�mage (moy. 3 ans)","unA","unQ",
              "Passif du secteur financier (tx de croissance)","Levier du secteur financier (dette/actions)")

rawdata<-data.frame()
rawdatafile <- "./rawseries.Rdata"

if (!file.exists(rawdatafile)){
  for (file in files) {
    data <- getFromEurostat(file)
    rawdata <- rbind(rawdata,data)
    save(rawdata,file = rawdatafile)
  }
} else {
  load(rawdatafile)
}  

finaldata<-rawdata

#on s�lectionne les indicateurs pertinents pour l'analyse
tablename<-list("tipsbp10","tipsii10","tipser10","tipsex10","tipslm10",
                "tipsho10","tipspc10","tipspd10","tipsgo10","tipsun10","tipsfs10")
finaldata<-finaldata[finaldata$variable %in% tablename,]

#on ajoute l'attribut name � la dataframe
finaldata$name<-finaldata$variable
for (i in 1:length(files)){
  finaldata$name[finaldata$variable == paste(files[i])] <- paste(names[i])
}

varnames<-list("caI","nfaI","eerI","expI","ulcI","hpI","crI","pdI","dI","unI","pasI")
for (i in 1:length(files)){
  finaldata$variable[finaldata$variable == paste(tablename[i])] <- paste(varnames[i])
}

country<-finaldata$country[1:28]
#non Euro-area country list
nealist<-list("BG","CZ","DK","HR","HU","LT","LV","PL","RO","SE","UK")
finaldata <- finaldata[finaldata$country %in% country,]
finaldata$isnea <- finaldata$country %in% nealist
#finaldata$isnea<-factor(finaldata$isnea,labels=c("pays en zone euro","pays hors zone euro"))
countryea<-subset(country,!(country %in% nealist))

colnames(finaldata)[3]<-"date"
procdata <- subset(finaldata,year(finaldata$date)>=1999 & year(finaldata$date)<=2012)

title_ind <- list("Compte courant, % du PIB (moy. 3 ans)",
                  "Position ext. nette de l'investissement, % du PIB",
                  "Taux de change effectif r�el (var. 3 ans)",
                  "Part de march� des exportations (var. 5 ans)",
                  "Co�t salarial unitaire nominal (var. 3 ans)",
                  "Indice prix des logements d�flat� (tx de croissance)",
                  "Cr�dit priv�, % du PIB",
                  "Dette priv�e, % du PIB",
                  "Dette publique, % du PIB",
                  "Taux de ch�mage (moy. 3 ans)",
                  "Passif du secteur financier (tx de croissance)")

title_co <- list("Autriche","Belgique","Bulgarie","Chypre","Tch�coslovaquie","Allemagne",
                 "Danemark","Estonie","Gr�ce","Espagne","Finlande","France","Croatie","Hongrie",
                 "Irlande","Italie","Lituanie","Luxembourg","Lettonie","Malte",
                 "Pays-Bas","Pologne","Portugal","Roumanie","Su�de","Slovanie",
                 "Slovaquie","Grande-Bretagne")

fig.cap_ind <- c("Compte courant, pourcent. du PIB (moy. 3 ans)","Position ext. nette de l'investissement, pourcent. du PIB","Taux de change effectif r�el (var. 3 ans)","Part de march� des exportations (var. 5 ans)","Co�t salarial unitaire nominal (var. 3 ans)","Indice prix des logements d�flat� (tx de croissance)","Cr�dit priv�, pourcent. du PIB","Dette priv�e, pourcent. du PIB","Dette publique, pourcent. du PIB","Taux de ch�mage (moy. 3 ans)","Passif du secteur financier (tx de croissance)")
fig.cap_co <- c("Indicateurs de surveillance macro�conomique - Autriche","Indicateurs de surveillance macro�conomique - Belgique","Indicateurs de surveillance macro�conomique - Bulgarie","Indicateurs de surveillance macro�conomique - Chypre","Indicateurs de surveillance macro�conomique - R�p. tch�que","Indicateurs de surveillance macro�conomique - Allemagne","Indicateurs de surveillance macro�conomique - Danemark","Indicateurs de surveillance macro�conomique - Estonie","Indicateurs de surveillance macro�conomique - Gr�ce","Indicateurs de surveillance macro�conomique - Espagne","Indicateurs de surveillance macro�conomique - Finlande","Indicateurs de surveillance macro�conomique - France","Indicateurs de surveillance macro�conomique - Croatie","Indicateurs de surveillance macro�conomique - Hongrie","Indicateurs de surveillance macro�conomique - Irlande","Indicateurs de surveillance macro�conomique - Italie","Indicateurs de surveillance macro�conomique - Lituanie","Indicateurs de surveillance macro�conomique - Luxembourg","Indicateurs de surveillance macro�conomique - Lettonie","Indicateurs de surveillance macro�conomique - Malte","Indicateurs de surveillance macro�conomique - Pays-Bas","Indicateurs de surveillance macro�conomique - Pologne","Indicateurs de surveillance macro�conomique - Portugal","Indicateurs de surveillance macro�conomique - Roumanie","Indicateurs de surveillance macro�conomique - Su�de","Indicateurs de surveillance macro�conomique - Slovanie","Indicateurs de surveillance macro�conomique - Slovaquie","Indicateurs de surveillance macro�conomique - Gde-Bretagne")


## @knitr byco
#cr�e les 28 graphs des indicateurs par pays
library(scales)
source("../macroR/facetAdjust.R")

for (i in 1:length(country)){
  plotdata<-subset(procdata,procdata$country==country[i])
  xlimits<-data.frame()
  plotdata2<-data.frame()
  
  for (j in 1:length(varnames)) {
    
    if (!(varnames[j] %in% unique(plotdata$variable))){
      next
    }
      
    sub<-subset(plotdata,variable==varnames[j])
    testlist<-cbind(sub$value>=6 | sub$value<=-4,
                    sub$value<=-35,
                    sub$value>=5 | sub$value<=-5,
                    sub$value<=-6,
                    sub$value>=9,
                    sub$value>=6,
                    sub$value>=15,
                    sub$value>=160,
                    sub$value>=60,
                    sub$value>=10,
                    sub$value>=16.5)
    testlistnea<-cbind(sub$value>=6 | sub$value<=-4,
                       sub$value<=-35,
                       sub$value>=11 | sub$value<=-11,
                       sub$value<=-6,
                       sub$value>=12,
                       sub$value>=6,
                       sub$value>=15,
                       sub$value>=160,
                       sub$value>=60,
                       sub$value>=10,
                       sub$value>=16.5)
    test <- ifelse(sub$country %in% nealist,testlistnea[,j],testlist[,j])
    x <- as.Date(ifelse(test, as.character(sub$date), NA))
    xg <- as.Date(c(NA, x), origin)
    xd <- c(x,NA)
    xmin <- na.omit(as.Date(ifelse( is.na(xg) & !is.na(xd) , xd , NA), origin))
    xmax <- na.omit(as.Date(ifelse( is.na(xd) & !is.na(xg) , xg , NA), origin))
    xmin[identical(xmin,character(0))]<-NA
    xmin[!(identical(xmin,character(0)))]<-xmin-months(6)
    xmax[identical(xmax,character(0))]<-NA
    xmax[!(identical(xmax,character(0)))]<-xmax+months(6)
    name<-as.character(unique(plotdata[plotdata$variable==varnames[j],"name"]))
    value<-min(sub$value)
    xlim<-data.frame(xmin=xmin,xmax=xmax,variable=as.character(varnames[j]),
                     name=name,value=value)
    xlimits <- rbind(xlimits,xlim)
    sub$value[identical(as.logical(sub$value),rep(NA,length(sub$value)))]<-0
    plotdata2<-rbind(plotdata2,sub)
  }
  xlimits<-subset(xlimits,!(xmin %in% NA))
  
  plotdata<-plotdata2
  plotdata$date <- as.Date(plotdata$date)
  g <- ggplot(data=plotdata,aes(x=date,y=value,color=variable)) +
    geom_line(size=0.8) + xlab(NULL) + ylab(NULL) +
    facet_wrap(~name,ncol=2,scales="free_y") + 
    geom_rect(data=xlimits,aes(NULL,NULL,xmin=xmin,xmax=xmax),
              ymin=-Inf,ymax=+Inf,fill='red',alpha=0.1,linetype=0) +
                scale_x_date(breaks=pretty_breaks(n=2)) +
                #labs(title=(paste("Indicateurs de surveillance macro�conomique",title_co[i],sep=" : "))) +
                theme_bw() + theme(legend.position="none",
                                   #strip.text=element_blank(),
                                   strip.background=element_blank(),
                                   panel.border=element_rect(colour="grey"))
  facetAdjust(g)
}



## @knitr byind
#cr�e les 10 graphs des pays par indicateur
library(gridExtra)
library(scales)

procdata <- subset(procdata,subset=!(procdata$country=="LU" & procdata$variable=="crI"))
procdata$value[procdata$country=="BG" & procdata$variable=="ulcI" & year(procdata$date)==1999]<-NA

mytheme <- theme_bw() + theme(strip.text=element_blank(),
                              strip.background=element_blank(),
                              legend.key=element_rect(colour="white"),
                              plot.margin=unit(c(.5,.5,.5,.5),"lines"),
                              panel.border=element_rect(colour="grey"))

varyminnea <- c(-Inf,-Inf,-Inf,-Inf,12,6,15,160,60,10,16.5)
varymaxnea <- c(-4,-35,-11,-6,Inf,Inf,Inf,Inf,Inf,Inf,Inf)
varymin2nea <- c(6,0,11,0,0,0,0,0,0,0,0)
varymax2nea <- c(Inf,0,Inf,0,0,0,0,0,0,0,0)
varyminea <- c(-Inf,-Inf,-Inf,-Inf,9,6,15,160,60,10,16.5)
varymaxea <- c(-4,-35,-5,-6,Inf,Inf,Inf,Inf,Inf,Inf,Inf)
varymin2ea <- c(6,0,5,0,0,0,0,0,0,0,0)
varymax2ea <- c(Inf,0,Inf,0,0,0,0,0,0,0,0)

for (j in 1:length(varnames)){
  plotdata <- subset(procdata,variable == varnames[j])
  
  finalnea <- subset(plotdata,plotdata$country %in% nealist)
  finalnea$supmedian <- finalnea$value[year(finalnea$date)==2011]>=
    median(finalnea$value[year(finalnea$date)==2011],na.rm=T)
  finalnea$supmedian[is.na(finalnea$supmedian)] <- FALSE
  datasup <- subset(finalnea,supmedian==TRUE)
  datainf <- subset(finalnea,supmedian==FALSE)
  rect <- data.frame(xmin=range(procdata$date)[1],xmax=range(procdata$date)[2],
                     ymin=varyminnea[j],ymax=varymaxnea[j],ymin2=varymin2nea[j],ymax2=varymax2nea[j])
  
  g1 <- ggplot(data=datasup,aes(x=date,y=value,color=country)) + 
    geom_line(size=.8) + xlab(NULL) + ylab(NULL) +
    geom_rect(data=rect,aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),
              fill='red',alpha=0.1,inherit.aes=FALSE,show_guide=FALSE) +
                geom_rect(data=rect,aes(xmin=xmin,xmax=xmax,ymin=ymin2,ymax=ymax2),
                          fill='red',alpha=0.1,inherit.aes=FALSE,show_guide=FALSE) +
                            scale_color_discrete(name="hors \nzone euro \n> m�diane") +
                            scale_x_datetime(breaks=pretty_breaks(n=2),labels=date_format("%Y"),minor_breaks="1 year") +
                            ylim(range(datasup$value,na.rm=T)) + mytheme
  
  g2 <- ggplot(data=datainf,aes(x=date,y=value,color=country)) + 
    geom_line(size=.8) +  xlab(NULL) + ylab(NULL) +
    geom_rect(data=rect,aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),
              fill='red',alpha=0.1,inherit.aes=FALSE,show_guide=FALSE) +
                geom_rect(data=rect,aes(xmin=xmin,xmax=xmax,ymin=ymin2,ymax=ymax2),
                          fill='red',alpha=0.1,inherit.aes=FALSE,show_guide=FALSE) +
                            scale_color_discrete(name="hors \nzone euro \n< m�diane") +
                            scale_x_datetime(breaks=pretty_breaks(n=2),labels=date_format("%Y"),minor_breaks="1 year") +
                            ylim(range(datainf$value,na.rm=T)) + mytheme
  
  finalea <- subset(plotdata,!(plotdata$country %in% nealist))
  finalea$supmedian <- finalea$value[year(finalea$date)==2011]>=
    median(finalea$value[year(finalea$date)==2011],na.rm=T)
  finalea$supmedian[is.na(finalea$supmedian)] <- FALSE
  datasup <- subset(finalea,supmedian==TRUE)
  datainf <- subset(finalea,supmedian==FALSE)
  rect <- data.frame(xmin=range(procdata$date)[1],xmax=range(procdata$date)[2],
                     ymin=varyminea[j],ymax=varymaxea[j],ymin2=varymin2ea[j],ymax2=varymax2ea[j])
  
  g3 <- ggplot(data=subset(finalea,supmedian==TRUE),aes(x=date,y=value,color=country)) + 
    geom_line(size=.8) + xlab(NULL) + ylab(NULL) +
    geom_rect(data=rect,aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),
              fill='red',alpha=0.1,inherit.aes=FALSE,show_guide=FALSE) +
                geom_rect(data=rect,aes(xmin=xmin,xmax=xmax,ymin=ymin2,ymax=ymax2),
                          fill='red',alpha=0.1,inherit.aes=FALSE,show_guide=FALSE) +
                            scale_color_discrete(name="zone euro \n> m�diane") +
                            scale_x_datetime(breaks=pretty_breaks(n=2),labels=date_format("%Y"),minor_breaks="1 year") +
                            ylim(range(datasup$value,na.rm=T)) + mytheme
  
  g4 <- ggplot(data=subset(finalea,supmedian==FALSE),aes(x=date,y=value,color=country)) + 
    geom_line(size=.8) + xlab(NULL) + ylab(NULL) +
    geom_rect(data=rect,aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),
              fill='red',alpha=0.1,inherit.aes=FALSE,show_guide=FALSE) +
                geom_rect(data=rect,aes(xmin=xmin,xmax=xmax,ymin=ymin2,ymax=ymax2),
                          fill='red',alpha=0.1,inherit.aes=FALSE,show_guide=FALSE) +
                            scale_color_discrete(name="zone euro \n< m�diane") +
                            scale_x_datetime(breaks=pretty_breaks(n=2),labels=date_format("%Y"),minor_breaks="1 year") +
                            ylim(range(datainf$value,na.rm=T)) + mytheme
  
  grid.arrange(arrangeGrob(g3,g1,g4,g2,nrow=2,ncol=2))
}
