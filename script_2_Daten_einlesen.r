# Script: Kurs "Quantitative Untersuchungen I in R"
# M. Ritter

# 1 EINLESEN VON (SPSS) DATEN in R
# 2 Datensatz erkunden


rm(list = ls())

# 1 EINLESEN VON (SPSS) DATEN in R
read

# in R existiert der Befehl 'read' um Daten einzulesen,
# dabei sind SPSS Dateien nicht eingeschlossen.

# Um den Datensatz zu laden muss zunächst ein weiteres Package namens "foreign" installiert werden. Packages werden für viele Befehle gebraucht. Mit install.packages werden Pakete installiert, das ist nur einmal notwendig. 

install.packages("foreign")

# Um das Paket zu nutzen, muss es dann auch geladen werden. mit library(packagename) wird das Package geladen (und die Funktion steht zur Verfügung). Das ist jeweils immer wieder zu schreiben, wenn ihr den Befehl nutzt. Das Package kann aber auch über das rechte untere Fenster im Reiter Packages angeklickt werden.

library(foreign)

# nun kann der read-Befehl auch für SPSS Dateien genutzt werden.
# zunächst ist jedoch noch das Arbeitsverzeichnis zu setzen, also das Verzeichnis anzugeben wo der Datensatz liegt.

setwd("M:/Lehre/_WBF_Seminar/R")

# ein weiterer Weg das Arbeitsverzeichnis festzulegen besteht in R Studio darin: Session -> Set Working Directory

# nun kann der Datensatz geladen werden.

read.spss()

data <- read.spss("./ALLBUS_2018.sav")

# alternativ kann der gesamte Dateipfad in den Befehl als erstes Argument eingegeben werden (diese Praxis ist jedoch unüblich).

data

# der Datensatz ist nun geladen, jedoch sind weitere Argumente hinzuzfügen, damit wir den Datensatz auch ansprechend nutzen können.

data <- read.spss("./ALLBUS_2018.sav",use.value.labels=FALSE, use.missings=TRUE, to.data.frame = TRUE)

# Erklärung:
  # alle Variablen werden als Faktor verwendet: mit use.value.labels=F       werden weiterhin Zahlen verwendet. 
  # Umgang mit fehlenden Werten: use.missings=T verwandelt fehlende Werte    in SPSS für R in "not available" (NA) um
  # zum anderen brauchen wir als Objekt ein data frame und keine Liste
  # to.data.frame = TRUE legt fest, dass es sich bei dem neu erstellten      Objekt um einen DataFrame handelt.

# nun sehen wir den Datensatz in der Ausgabe, eine andere Möglichkeit sich den Datensatz anzuschauen besteht, wenn im Fenster oben recht auf den Datensatz (data) geklickt wird.

data

# 2 Datensatz erkunden

# wenn der Datensatz geladen wurde, sollte er nun betrachtet werden. Verschiedene Variante stehen zur Verfügung, hier noch ein paar Befehle dazu.
# der Befehl head() zeigt die ersten sechs Elemente des Objekt an:
head(data)

#den class() und str () Befehl kennen wir bereits.

class(data)
str(data)

# es kann aber auch direkt auf Variablennamen zugegriffen werden, indem ein $ Zeichen nach dem Namen des Datensatzes (bzw. der Liste) eingefügt wird und dann der Variablenname

data$sex
data$age

# oder die ersten 6 Werte von ep01 (Frage nach wirtschaftlicher Lage in D)

head(data$ep01)

# eine erste Übersicht deskriptiver Statistik für jede Variable bekommen wir mit der summary() oder table() Funktion.
summary(data$age)

table(data$ep01)

#mit folgendem Befehl wird das erste (bzw. nachfolgend das fünfte) Element des Objekts (hier dataframe) ausgegeben.

data[1]
data[5]

#das geht auch, indem die Bezeichnung der Variable eingegeben wird
data['za_nr']
data['ep01']


# weiteres für erkunden des Datensatzes
library(dplyr)
glimpse(data)
library(DataExplorer)
plot_intro(data)

# Histrogramm für alle Variablen (dauert zu lang Datensatz zu groß)
# plot_histogram(data) 

####################################################################################
# Laden Sie den ALLBUS Datensatz in ein Objekt namens "allbus"
# Inspizieren Sie den Datensatz. Schauen Sie sich drei Variablen genauer an und nutzen Sie dazu mind. einen der oben aufgeführten Befehle.
#
###################################################################################


