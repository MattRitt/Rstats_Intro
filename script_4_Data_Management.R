##### Data Manegement mit R ####
## Quantitative Untersuchungen 
## M Ritter

# Intro
# dplyr
  # filter
  # select
  # arrange
  # mutate
  # summarise und 
  # group by.
  # piping
# Aufgabe

# Intro --------------------------------------------------

# wir werden in den folgenden R-Skripten uns auf das tidyverse-Universum beziehen. Tidyverse ist eine Sammlung von open-source Paketen f�r Menschen, die sich mit DataScience oder Statistik auseinandersetzen www.tidyverse.org/. 
# Wir behandeln hier in erster Linie die Pakete dplyr zum Datenmanagement und ggplot zur Visualisierung.
# um gleich alle Pakete zu laden k�nnen Sie 
# install.packages("tidyverse") aufrufen, dann wird eine Vielzahl an n�tzlichen Paketen installiert.

# Alles was in diesem Skript zum Datenmanagement gezeigt wird, kann auch in Base R gemacht werden. Die Befehle sehen dann etwas anders aus/ haben eine andere Grundstruktur, die z.T. als nicht so einfach erachtet wird, dlpyr und co haben eine �hnliche Grundstruktur. 

# install.packages("dplyr") 
library(dplyr)

# noch den Datensatz laden.
library(foreign)
setwd("M:/Lehre/_WBF_Seminar/R")
getwd()

data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)

# schauen ob es geklappt hat.
head(data$ep01)


# dplyr package ----------------------------------------

# das Paket dplyr bezieht sich ausschlie�lich auf Dataframes, es erwartet einen Dataframe als Eingabe und gibt (fast immer) einen Dataframe zur�ck.
# es gibt relativ wenige grundlegende Funktionen, mit denen eine Gro�zahl von Transformationen erstellt werden kann. hier werden 6 vorgestellt.
# filter
# select
# arrange
# mutate
# summarise und 
# group by.
# dar�ber hinaus gibt es eine verkn�pfende Funktion, das sog. piping mit %>%
# mit diesem "Werkzeugkasten" k�nnen komplexe Datentransformationen durchgef�hrt werden.

# filter ()-----------------------------------------------

# 1 Zeilen filtern
# mit filter() werden Zeilen aus einem Dataframe gefiltert, f�r die das gegebene Kriterium zutrifft.
# Zeilen, die zum Filterkriterium passen, bleiben im Datensatz.

filter(data, eastwest==2) 
# angezeigt wird der gesamte Datensatz mit Befragten aus Ostdeutschland.
# die Anweisung sollte in einem neuen Datensatz gespeichert werden. (jeweils passende Namen finden!)
df_ost <- filter(data, eastwest==2) 

# zwei Kriterien: nur Befragte aus Ostdeutschland und �lter als 65.
df_ost_alt <- filter(data, eastwest==2, age>65) 

# weitere Argumente/ Operatoren sind in der Hilfe zu finden.
?filter
# Operatoren
# ==, >, >= etc
# &, |, !, xor()
# is.na()
# between(), near()

# Bereich angeben: Befragte, die zwischen 35 und 50 Jahre alt sind:
df_mittelalt <- filter(data, between(age, 35, 50))

# nur Rentner:innen
df_rentnerinnen <- filter(data, age >= 65, sex == "2")

# zum Vergleich, Befehl in Base-R: 

df_rentnerinnen_bR <- data[data$age >= 65 & data$sex == "2", ]

# Achtung, in base R werden NAs "mitgenommen" in dplyr werden NAs gedropped.

# select() ---------------------------------------

# der select-Befehl liefert die gew�hlten Spalten eines Dataframes (die nicht ausgew�hlten Spalten werden gedropped)
# sinnvoll ist es nur mit den Daten zu arbeiten, die Ihr auch braucht.
# install.packages("dplyr")
library(dplyr)

#Spalte Alter wird ausgew�hlt.
select(data, age)

#Spalte Alter, EastWest werden ausgew�hlt.
df_age_ew <- select(data, age, eastwest, ep01)

#Spalten 3 bis 6 werden ausgew�hlt.
select(data, 3:6)
?select

df_ep0 <- select(data, starts_with("ep0"))
glimpse(df_ep0)

# arrange() ----------------------------------------------

# wird gebraucht um Zeilen zu sortieren, kann zum "schnellen" Anschauen gebraucht werden, der Befehl wird aber auch oft zum Programmieren verwendet.

# nach h�chstem Wert einer Variable wird standardm��ig sortiert
data_arr_ep01 <- arrange(data, ep01)

# nach niedrigstem Wert sortieren: zwei Varianten
data_arr_ep01_desc <- arrange(data, -ep01)
# oder
data_arr_ep01_desc <- arrange(data, desc(ep01))
view(data_arrange_ep01_desc)

#zwei Sortierkriterien
data_arrange_ep01_ew <-arrange(data, ep01, eastwest)

# summarise() --------------------------------------------

# fasst Werte einer Spalte zusammen. Genauer gesagt fasst dieser Befehl eine Spalte zu einer Zahl zusammen anhand einer Funktion wie mean(), sd() oder max()
summarise(data, mean(age, na.rm = T))

# und warum nicht gleich: mean(data$age, na.rm = T)??
# weil der summarise Befehl in Verbindung mit anderen Funktionen verkn�pft werden kann, insbesondere mit group_by.

# group_by() ---------------------------------------------

# mit dem group_by() Befehl k�nnen Gruppierungen erstellt. Ein group_by() bzw. die Aufteilung in eastwest w�rde den Datensatz in diese beiden Gruppen einteilen.

data_gruppiert_ew <- group_by(data, eastwest)
data_gruppiert_ew 
# zun�chst sehen wir erstmal nicht viel, R teilt uns lediglich mit, dass es zwei Gruppen gibt (Groups: eastwest [2])

# wenn nun ein Mittelwert ausgerechnet wird, werden gruppenspezifische MW angegeben.
summarise(data_gruppiert_ew, mw_pro_gruppe = mean(age, na.rm = T))

# mit der Funktion n() wird die Anzahl der Auspr�gungen gez�hlt und in diesem Fall auch berichtet
summarise(data_gruppiert_ew, mw_pro_gruppe = mean(age, na.rm = T), Anzahl=n())

# group_by() alleine ist nicht n�tzlich. Ihr k�nnt euch das so vorstellen, das R angewiesen wird die nachfolgenden Berechnungen anhand von dieser Gruppeneinteilung durchzuf�hren. N�tzlich wird es also erst, wenn man weitere Funktionen auf den gruppierten Datensatz anwendet.

# mutate -------------------------------------------------

# mit mutate() k�nnen neue Varbiablen berechnet werden.
# die allg. Schreibweise lautet f�r eine Summe von zwei Spalten:
# mutate(data, neue_spalte = spalte1 + spalte2)

# folgend wird exemplarisch das Alter in Tagen (age_d) als neue Variable aus Alter*365 berechnet.

mutate(data, age_d=age*365)

# so kann bspw die (neue) Variable im Datensatz gespeichert werden.
data <- mutate(data, age_d=age*365)

head(data$age_d)

# auch k�nnen mit mutate neue Kategorien erstellt werden, das kann sehr n�tzlich sein, hier in Beispiel mit der Variable ls01 (Lebenszufriedenheit Auspr�gungen 1 bis 10)

data <- mutate(data, 
               ls01_kat = case_when(
                 ls01>=8 ~ "High LS", 
                 ls01>6 & ls01 <8 ~ "Medium LS", 
                 ls01<=6 ~ "Low LS"))
head(data$ls01_kat)
class(ls01_kat)
table(data$ls01_kat)

# falls die NA "mitgenommen" werden sollen, dann bspw, 
# is.na(ls01) ~ "unknown" einf�gen.


# pipe %>%--------------------------------------

#anstelle von 
filter(data, ep01==1)

#kann auch der pipe operator genutzt werden
data %>% filter(ep01==1)

# Vorteil ist, das mit dem pipe operater Befehle miteinander verkettet werden k�nnen.
# hier auch Beispiel: https://bookdown.org/joone/ComputationalMethods/der-pipe-operator.html
# Die "Pfeife" wird mit %>% (Prozent-Gr��er-Prozent) dargestellt. Shortcut: Strg + Shift + M
  
newdata <- data %>% 
  filter(eastwest==2) %>% 
  group_by(isced97) %>%
  summarise(mw = mean(ls01, na.rm = T), Anzahl=n())

print(newdata)

# die pipe kann als "und dann" interpretiert werden.
# zu lesen ist der Code wie folgt:
# es wird ein neuer Dataframe newdata erzeugt
# Nimm den Datensatz 'data' UND DANN
# filtere alle Personen, die aus den alten BL kommen UND DANN
# gruppiere die Werte nach "ep01" UND DANN
# bilde den Mittelwert (pro Gruppe) f�r "age" und gib die H�ufigkeit zur�ck


# cheat sheet f�r dplyr
# https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-transformation.pdf



# Aufgabe bis n�chste Woche------------------------------------

# nutze f�r alle Aufgaben dplyr Funktionen.

# Deine Tante ruft an und fragt wie lange du denn noch studieren willst, du sollst doch endlich Geld verdienen?
# Du willst beweisen, dass es sich lohnt zu studieren. Als Argumentationsgrundlage vergleichst du das Einkommen (di01a) von Personen mit Hochschulabschluss und den anderen Gruppen (educ) in Ostdeutschland.

# 1. Lade den Datensatz, der nur die relevanten Variablen enth�lt und speichere Ihn als "Tante".
# 2. schau dir die F�lle mit niedrigsten und h�chsten Einkommen genauer an.
# 3. Vergleiche das mittlere Einkommen (di01a) zwischen den Berufsabschlussgruppen in Ostdeutschland.
# 4. du denkst dir, dass das Einkommen ja nicht das einzige im Leben ist und willst gern wissen, ob denn die (mittlere) Lebenszufriedenheit auch zwischen den Bildungsgruppen in Ostdeutschland variiert.
# 5. Antworte knapp deiner Tante?




