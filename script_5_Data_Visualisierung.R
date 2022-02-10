##### Visualisierung mit R ####
## Quantitative Untersuchungen 
## M Ritter

# Intro
# ggplot2
# Aufgabe

# Intro --------------------------------------------------

# ggplot ist das bekannteste R-Paket zur Visualisierung von Daten.

install.packages("ggplot2") 
library(ggplot2)


library(tidyverse)
# oder einzeln library(ggplot2) library(dplyr) 

# noch den Datensatz laden.
library(foreign)
setwd("M:/Lehre/_WBF_Seminar/R")
data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)
# schauen ob es geklappt hat.
head(data$ep01)

mydata <- select(data, age, sex, eastwest, di01a, ls01, educ, ep01)

# Faktoren erstellen
glimpse(mydata)

mydata$sex.f <- as.factor(mydata$sex)
levels(mydata$sex.f) <- c("Mann", "Frau") 

mydata$eastwest.f <- as.factor(mydata$eastwest)
levels(mydata$eastwest.f) <- c("West", "Ost") 

mydata$educ.f <- as.factor(mydata$educ)
levels(mydata$educ.f) <- c("OHNE ABSCHLUSS 1", "VOLKS-,HAUPTSCHULE 2", "MITTLERE REIFE 3", "FACHHOCHSCHULREIFE 4", "HOCHSCHULREIFE 5", "ANDERER ABSCHLUSS 6", "NOCH SCHUELER 7")

glimpse(mydata)
levels(mydata$eastwest.f)
str(mydata$eastwest.f)

# ggplot ------------------------------------------------

# am weitesten verbreitete Paket zur Datenvisualisierung.
# baut auf einer Ebenen-Struktur auf.
# 3 Eingaben sind grundlegend: data aesthetics und geometries

# Grundstruktur des Befehls: 
# ggplot(data = <DATA>, mapping = aes(<MAPPING>)) 
# + geom_<NAME_OF_GEOMETRIC_OBJECT>() + ...

# Beispiel anhand eines Scatterplots----------------------

# die drei zentralen Ebenen:
# erste Ebene: Daten
ggplot(mydata) # es erscheint bei Plots nur ein leeres Bild 
# zweite Ebene: aesthetics
ggplot(mydata, aes(x = age, y = di01a)) # die x und y achse wird erstellt
# dritte Ebene: geom
ggplot(mydata, aes(x = age, y = di01a)) +
         geom_point() # die Punkt ('point') werden geplottet.

# Besonderheit im Code: bei ggplot wird das + für die Verkettung verwendet (bei dplyr ist es ja %>%)

# es ist auch das Zwischenspeichern in Objekten möglich.
pic1 <- ggplot(mydata, aes(x = age, y = di01a))
pic1 + geom_point()


# die ersten drei genannten Ebenen data, aes, geom reichen für eine Vielzahl an Grafiken bereits aus.

# weitere Ebenen sind: facets, statistics, coordinates und theme

#facet teilt in mehrere Grafiken ein (abhängig von der gegebenen Variable)
ggplot(mydata, aes(x = age, y = di01a)) +
  geom_point() +
  facet_grid(.~eastwest.f)

# Einteilung ist auch ausgehend von der y-Achse möglich
ggplot(mydata, aes(x = age, y = di01a)) +
  geom_point() +
  facet_grid(eastwest.f~.)

# oder anhand von 2 Variablen 
ggplot(mydata, aes(x = age, y = di01a)) +
  geom_point() +
  facet_grid(eastwest.f~sex.f)


#statistics erzeugt statistische Merkmale innerhalb der Grafik
ggplot(mydata, aes(x = age, y = di01a)) +
  geom_point() +
  facet_grid(eastwest.f~.) +
  stat_smooth()

#mit coord kann auf die Koordinaten Einfluss genommen werden
ggplot(mydata, aes(x = age, y = di01a)) +
  geom_point() +
  facet_grid(eastwest.f~.) +
  stat_smooth() +
  coord_cartesian(xlim=c(18, 35))

#mit theme() kann auf Standardthemes zurückgegriffen werden
ggplot(mydata, aes(x = age, y = di01a)) +
  geom_point() +
  facet_grid(eastwest.f~.) +
  stat_smooth() +
  coord_cartesian(xlim=c(18, 35)) +
  theme_economist()

# als default gibt es nur ein paar Themes, es können noch weitere Themes geladen werden 
# install.packages("ggthemes")
library(ggthemes)

# was kann noch alles geändert werden?

ggplot(mydata, aes(x = age, y = di01a)) + geom_point()

# cheat sheet von ggplot2 nutzen! 
# https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-visualization.pdf
# unter scatterplot: alpha, color, fill, shape, size, -> können bei der Geometrie noch weitere Werte für die Aesthetics übergeben werden
ggplot(mydata, aes(x=age, y= di01a)) + 
  geom_point(aes(color=ep01))

# das gleiche geht mit den anderen Argumenten: fill, shape, size und alpha.
# oder kann miteinander verknüpft werden.
# ein paar Beispiele.

ggplot(mydata, aes(x=age, y= di01a)) + 
  geom_point(aes(color=ep01, size=5, alpha=0.5))

ggplot(mydata, aes(x=age, y= di01a)) + 
  geom_point(aes(color="red", size=ep01, alpha=0.5))

ggplot(mydata, aes(x=age, y= di01a)) + 
  geom_point(shape=2, aes(color=ep01,alpha=0.7))

# auch andere Farben möglich, zB über color-hex.com


# Barplot ----------------------------------------------

hist(mydata$ep01)
ggplot(mydata, aes(ep01)) + 
  geom_bar()

ggplot(mydata, aes(ep01)) + 
  geom_bar(aes(fill=educ.f))

ggplot(mydata, aes(ep01)) + 
  geom_bar(aes(fill=educ.f)) +
  coord_flip()

# Boxplot -----------------------

# erster Wert der Faktor, dann die (meist) kont. Variable

ggplot(mydata, aes(x=educ.f, y= age)) + 
  geom_boxplot()

ggplot(mydata, aes(x=educ.f, y= age)) + 
  geom_boxplot() + 
  coord_flip() +
  theme_clean()
  
ggplot(mydata, aes(x=educ.f, y= age)) + 
  geom_boxplot(aes(fill=eastwest.f)) +
  labs(title = "Boxplot",
       y="Alter",
       x= "Schulabschluss")


# Beschriftungen ----------------------------------------------
# Labels können via Befehl labs() übergeben werden.

# dazu nehme ich die erste Grafik
pic2 <- ggplot(mydata, aes(x = age, y = di01a)) +
  geom_point()

# Achtung: wenn plots in Objekten gespeichert werden, wird ggf nicht der Plot angezeigt, mit print() kann der Plot aufgerufen werden.
print(pic2)

# Angaben zur Beschrifutng werden mit labs() hinzugefügt
pic3 <- pic2 + labs(title ="Alter vs Einkommen",
            subtitle = "möglicher Untertitel",
            x = "Alter in Jahren",  
            y = "Einkommen in Euro",
            caption = "ggf weitere Anmerkungen")

# wenn eine Andere Annerkung eingefügt werden soll.
pic3 + annotate(geom = "text", x = 20, y = 11000, label = "Hallo")


# etwas für Weihnachten? https://ggplot2tor.com/tutorials/streetmaps

# speichern von Grafiken
ggsave("map.png", width = 6, height = 6)


# Übungen -----------------------

# Aufgabe ggplot
# Nehmt euch die drei Variablen aus der Deskriptionsübung (eigene interessierende Variablen) und führt mit diesen 2 unterschiedliche Plots aus. Differenziert die Plots nach verschiedenen Merkmalen.

# 1. Datensatz mit den interessierenden Variablen erstellen.
# 2. kategoriale/ ordinale Variablen faktorisieren
# 3. insgesamt 2 Plots erstellen:
# mit unterschiedlichen facets,
# mit unterschiedlichen Farben,
# mit Titel und Achsenbeschriftungen,
# in zwei verschiedenen Themes

# oder Map der Heimatstadt/-dorfes

