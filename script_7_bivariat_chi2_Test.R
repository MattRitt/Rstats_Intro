# Bivariate Statistik - Chi Quadrat Test-------------------
# v.a. aus Manderscheid 2017, S. 95 ff

# Setup
# Kontingenz/Kreuztabelle als Ausgangspunkt
# Chi-Quadrat Test
# Effektstärken: Phi und Cramers V
# Übungsaufgabe 


# Setup -----------------------------------------------------

library(foreign)
library(dplyr)
setwd("M:/Lehre/_WBF_Seminar/R")
data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)

#relevante Variablen auswählen.
data <- select(data, age, sex, eastwest, educ, ep01, land, lm23, pa11)

glimpse(data)
summary(data)
attach(data)

#für die bessere Darstellung werden den Variablen ep01 und eastwest die Variablenlabel hinzugefügt.

data$ep01.factor <- factor(ep01, labels = c("sehr gut", "gut", "teils/teils", "schlecht", "sehr schlecht"))
data$eastwest.factor <- factor(eastwest, labels= c("Alte BL", "Neue BL"))


# Tabelle als Ausgangspunkt ---------------------------------

# eine Tabelle mit den (bedingten) absoluten Häufigkeiten erhält man schnell über den Befehl table(variable1, variable2). Die erstgenannte Variable wird in  die Zeilen, die zweitgenannte in die Spalten der Kontingenztabelle gesetzt.


a <- table(eastwest.factor, ep01.factor)

#Möglichkeiten zur Anzeige von Spalten- und Zeilensummen

a <- table(eastwest, ep01) # Tabelle wird als Objekt a definiert.

margin.table((a), 1) # Summe der Zeilen
margin.table((a), 2) # Summe der Spalten

prop.table(table(eastwest.factor, ep01.factor))

#Möglichkeiten der Anzeige von Prozentwerten
prop.table(a)*100 #Gesamtprozentwerte werden angezeigt
prop.table(a, 1) *100 # Zeilenprozentwerte werden angezeigt
prop.table(a, 2) *100 # Spaltenprozentwerte werden angezeigt 

#ggf noch runden
round(prop.table(a)*100, 1)

# Ist die Einschätzung der wirtschaftlichen Lage abhängig von der Herkunft (alte vs neue Bundesländer)?

# Überprüfung
table(eastwest.factor, ep01.factor)

round(prop.table(table(eastwest.factor, ep01.factor), 1)*100, 2)


# Chi-Quadrat Test --------------------------------------------

### Die statistische Kennziffer Chi-Quadrat (chi²) misst die Stärke von ungerichteten und gerichteten Zusammenhängen zweier Merkmale und basiert auf der Differenz zwischen beobachteten und erwarteten Häufigkeiten (vgl. Diaz-Bone 2013: 82 ff.). Zusammen mit dem Signifikanzwert p-value gibt der Chi-Quadrat Wert damit an, ob zwei Variablen voneinander unabhängig sind oder nicht. In R kann Chi-Quadrat mit chisq.test(variable1, variable2) berechnet werden. 

chisq.test(eastwest, ep01)

# Inhaltlich bedeutet das Ergebnis, dass die im Beispiel verwendeten Variablen eastwest und wirtschaftliche Lage (ep01) nicht unabhängig voneinander sind, sondern statistisch signifikant miteinander zusammen hängen. 
# Der Befehl kann auf zwei Variablen oder auf ein Tabellenobjekt angewendet werden. 

x <- table(eastwest, ep01)
chisq.test(x)

# Die Funktion summary(tabelle) gibt für Kontingenztabellen ebenfalls den Chi-Quadrat Wert zusammen mit der Anzahl der Beobachtungen aus. 

summary(table(eastwest, ep01)) # oder auch summary(x)

# Nachteil des Chi-Quadrat Wertes liegt jedoch darin, dass sein Wertebereich nicht standardisiert ist, das heißt, er sagt nichts über die Stärke des Zusammenhangs aus.

# für nominalskalierte Daten gibt es mehrere sog. Zusammenhangsmaße.
# Eine Übersicht mehrerer Chi-Quadrat basierter Zusammenhangsmaße kann man sich über die Funktion assocstats(tabelle) aus dem Paket vcd erstellen lassen: Phi (2x2)!, der Kontingenzkoeffizient und Cramers V (größer 2x2).

# install.packages("vcd")
library(vcd) #ggf. wird ein zusätzliches Paket geladen
assocstats(x)

#Cramers V geht von 0 bis 1.
#Cramers V ist zu verwenden wenn die Tabelle größer als 2x2 ist.
# Bei 2x2 Felder-Tabellen sind die Werte ggf. alle gleich groß.

# Wenn die Tabelle 2x2 Feldern entspricht ist der Phi-Koeffizient zu nutzen. Dieser ergibt sich aus der Division des Chi-Quadrat Wertes durch die Anzahl der Fälle. Phi kann entsprechend Werte zwischen 0 und 1 annehmen. 
table(eastwest, sex)
summary(table(eastwest, sex))
assocstats(table(eastwest, sex))

# Interpretation von Phi-Koeffizient und Cramér's V nach Cohen (1988)
# kleiner Effekt 	ab V = 0.1
# mittlerer Effekt 	ab V = 0.3
# großer Effekt 	ab V = 0.5



# Aufgabe -------------------------------------------------------
# Analysieren Sie eine der folgenden Hypothesen. Erstellen Sie dazu jeweils die Nullhypothese und die Alternativhypothese, führen Sie den entsprechenden Signifikanztest durch und melden Sie die entsprechende Effektstärke zurück.

# 1. Gibt es einen Zusammenhang von Personen, die sich im Internet über Politik informieren (lm23) und dem Schulabschluss (educ)?

# 2. Ist die Befürwortung von härteren Maßnahmen für den Umweltschutz (pa11) zwischen Frauen und Männern unabhängig?

# 3. Erstellen und analysieren Sie eine eigene Hypothese/ Nehmen Sie gern eine Hypothese ausgehend von "ihrer" deskriptiven Statistik.
