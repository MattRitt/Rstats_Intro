# miscellaneous
#

# Inhalt ----------------
# Setup
# labeln von Variablenwerten
# Grafiken mit ggplot2 
# Umgang mit fehlenden Werten
# Mittelwerte ersetzen für eine Variable/ Spalte
# Rekodieren von Variablen in Kategorien
# Variablen umbenennen 

# M Ritter
# Quantitativen Untersuchungen
# WiSe 2021/22


# Intro Datensatz laden.
library(foreign)
setwd("M:/Lehre/_WBF_Seminar/R")

data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)

# schauen ob es geklappt hat.
head(data$ep01)

# Beispielvariablen selektieren
library(tidyverse)
mydata <- select(data, sex, eastwest, hs01, rd01, ls01, age, dw37)


# labeln von Variablenwerten ----------------------------------------------

# Labelling der Variable Geschlecht
mydata$sex.f <- as.factor(mydata$sex)
levels(mydata$sex.f) <- c("Mann", "Frau") 

# Grafiken mit ggplot2 ----------------------------------------------

library(ggplot2)
# von Frau Thomas

pic3 <- ggplot(mydata, aes(x = ls01, y = dw37)) + 
  geom_point() + 
  facet_grid(.~sex.f)+
  theme_dark()

print(pic3)

pic4 <- pic3 + labs(title ="Lebenszufriedenheit vs. Nebenerwerb",
            x = "Lebenszufriedenheit",  
            y = "Nebenerwerb in Stunden pro Woche")

##Damit die Skalierung passt:
last_plot() + scale_x_continuous(breaks=c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
last_plot() + scale_y_continuous(breaks=c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100))

# von Frau Weis

barplot <- ggplot(mydata, aes(rd01)) + 
  geom_bar(aes(fill=sex.f), position="fill", show.legend = F) +
  coord_flip() +
  theme_minimal()

print(barplot)

# wie bekomme ich die Grafik mit relativen Häufigkeiten?
# unter geom kann position="fill" eingefügt werden.
# hier können auch Prozente eingefügt werden
# barplot + scale_y_continuous(labels=percent)

library(scales)
barplot + scale_y_continuous(labels=percent)

barplot + labs(title ="Religionszugehörigkeit",
               subtitle = "anhand des Geschlechts",
               x = "Religionszugehörigkeit",  
               y = "absolute Häufigkeit",
               caption = "N = 3477")

#ja die Grundgesamtheit sind 3477, jedoch gibt es 7 fehlende Werte bei Religionszug.

#wie bekomme ich das raus?
summary(mydata$sex.f)
sum(table(mydata$rd01, mydata$sex.f))


# Umgang mit fehlenden Werten --------------------------------------

# Erkennen von fehlenden Werten (NA).
#Über den Befehl anyNA() bekommt ihr die Aussage ob die Variable NA enthält.

anyNA(mydata$sex)

#Mit is.na() bekommt Ihr eine Übersicht.
is.na(mydata$rd01)

#bei unserem (großen) Datensatz ist diese Übersicht nicht sinnvoll.
#Mit sum(is.na()) wird angegeben, in wie vielen Zeilen des Datensatzes die Variable NA ist (bzw. Angaben bei dieser variable fehlen).

#zählen wieviel fehlen
sum(is.na(mydata$rd01))

# rausfinden, welche cases fehlen:
missingCases <- which(is.na(mydata$rd01)==TRUE)
missingCases

#ansonsten in summary oder über favstats die missings anzeigen lassen.

summary(mydata$rd01)
summary(mydata$sex.f)

# install.packages("mosaic")
# library(mosaic)

mosaic::favstats(mydata$sex)

#hier aufgeteilt nach Geschlecht, das geht über die ~ (Tilde).
mosaic::favstats(mydata$rd01 ~ mydata$sex.f)

# listwise deletion of missing values
# alle Fälle löschen, die mind. einen fehlenden Wert haben.
# hier am besten immer einen neuen Datensatz erstellen!
mydataclean <- na.omit(mydata)
# da dw37 nur sehr weinige Fälle beinhaltet, ggf rausnehmen aus mydata.

# zeigt an welche Fälle NA's haben
mydata[!complete.cases(mydata),]

# einen bestimmten Wert als Missing setzen.
# manchmal müssen Werte in einem Datensatz als Missing defineirt werden. hier beispielhaft soll die 99 als NA definiert werden in der Variable v1
# alle Zeilen (Fälle) die bei der v1 eine 99 haben werden somit als NA definiert.
mydata$v1[mydata$v1==99] <- NA 

#Missing values rausnehmen
mydata$rd01_valid.f <- mydata[!is.na(mydata$rd01.f),]


# Mean Imputation of One Column

#Variable im Datensatz erstellen
mydata$rd01_imp <- mydata$rd01


summary(mydata$rd01_imp)

#Befehl zum Ersetzen der NA's mit dem Mittelwert.(base R)

mydata$rd01_imp[is.na(mydata$rd01_imp)] <- mean(mydata$rd01, na.rm = TRUE)

#anschauen ob es geklappt hat.
summary(mydata$rd01)
summary(mydata$rd01_imp)
mosaic::favstats(mydata$rd01_imp)
mosaic::favstats(mydata$rd01)


# Rekodieren von Variablen in Kategorien --------------------------

# von Frau Bunkowski
mydata <- mutate(mydata, 
                      ls01_kat = case_when(
                      ls01>=8 ~ "Hoch", 
                      ls01>2 & ls01 <8 ~ "Mittel", 
                      ls01<=2 ~ "Gering"))

table(mydata$ls01_kat)

# weitere Variante mit dem car package
# install.packages("car")
# library(car)
?recode

mydata$age_kat <- recode(mydata$age, "18:35='jung'; 36:65='mittel'; 65:100='alt'")
head(mydata$age_kat)
table(mydata$age_kat)



# Variablen umbenennen -----------------------------

# mit rename() aus dplyr
library(dplyr)
head(mydata$age)
newdata <- rename(mydata, alter=age)

# base R Version
names(newdata)[3] <- "Neues Label für Variable 3"




