# Bivariate Statistik - Chi Quadrat Test-------------------
# v.a. aus Manderscheid 2017, S. 95 ff

# Setup
# Kontingenz/Kreuztabelle als Ausgangspunkt
# Chi-Quadrat Test
# Effektst�rken: Phi und Cramers V
# �bungsaufgabe 


# Setup -----------------------------------------------------

library(foreign)
library(dplyr)
setwd("M:/Lehre/_WBF_Seminar/R")
data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)

#relevante Variablen ausw�hlen.
data <- select(data, age, sex, eastwest, educ, ep01, land, lm23, pa11)

glimpse(data)
summary(data)
attach(data)

#f�r die bessere Darstellung werden den Variablen ep01 und eastwest die Variablenlabel hinzugef�gt.

data$ep01.factor <- factor(ep01, labels = c("sehr gut", "gut", "teils/teils", "schlecht", "sehr schlecht"))
data$eastwest.factor <- factor(eastwest, labels= c("Alte BL", "Neue BL"))


# Tabelle als Ausgangspunkt ---------------------------------

# eine Tabelle mit den (bedingten) absoluten H�ufigkeiten erh�lt man schnell �ber den Befehl table(variable1, variable2). Die erstgenannte Variable wird in  die Zeilen, die zweitgenannte in die Spalten der Kontingenztabelle gesetzt.


a <- table(eastwest.factor, ep01.factor)

#M�glichkeiten zur Anzeige von Spalten- und Zeilensummen

a <- table(eastwest, ep01) # Tabelle wird als Objekt a definiert.

margin.table((a), 1) # Summe der Zeilen
margin.table((a), 2) # Summe der Spalten

prop.table(table(eastwest.factor, ep01.factor))

#M�glichkeiten der Anzeige von Prozentwerten
prop.table(a)*100 #Gesamtprozentwerte werden angezeigt
prop.table(a, 1) *100 # Zeilenprozentwerte werden angezeigt
prop.table(a, 2) *100 # Spaltenprozentwerte werden angezeigt 

#ggf noch runden
round(prop.table(a)*100, 1)

# Ist die Einsch�tzung der wirtschaftlichen Lage abh�ngig von der Herkunft (alte vs neue Bundesl�nder)?

# �berpr�fung
table(eastwest.factor, ep01.factor)

round(prop.table(table(eastwest.factor, ep01.factor), 1)*100, 2)


# Chi-Quadrat Test --------------------------------------------

### Die statistische Kennziffer Chi-Quadrat (chi�) misst die St�rke von ungerichteten und gerichteten Zusammenh�ngen zweier Merkmale und basiert auf der Differenz zwischen beobachteten und erwarteten H�ufigkeiten (vgl. Diaz-Bone 2013: 82 ff.). Zusammen mit dem Signifikanzwert p-value gibt der Chi-Quadrat Wert damit an, ob zwei Variablen voneinander unabh�ngig sind oder nicht. In R kann Chi-Quadrat mit chisq.test(variable1, variable2) berechnet werden. 

chisq.test(eastwest, ep01)

# Inhaltlich bedeutet das Ergebnis, dass die im Beispiel verwendeten Variablen eastwest und wirtschaftliche Lage (ep01) nicht unabh�ngig voneinander sind, sondern statistisch signifikant miteinander zusammen h�ngen. 
# Der Befehl kann auf zwei Variablen oder auf ein Tabellenobjekt angewendet werden. 

x <- table(eastwest, ep01)
chisq.test(x)

# Die Funktion summary(tabelle) gibt f�r Kontingenztabellen ebenfalls den Chi-Quadrat Wert zusammen mit der Anzahl der Beobachtungen aus. 

summary(table(eastwest, ep01)) # oder auch summary(x)

# Nachteil des Chi-Quadrat Wertes liegt jedoch darin, dass sein Wertebereich nicht standardisiert ist, das hei�t, er sagt nichts �ber die St�rke des Zusammenhangs aus.

# f�r nominalskalierte Daten gibt es mehrere sog. Zusammenhangsma�e.
# Eine �bersicht mehrerer Chi-Quadrat basierter Zusammenhangsma�e kann man sich �ber die Funktion assocstats(tabelle) aus dem Paket vcd erstellen lassen: Phi (2x2)!, der Kontingenzkoeffizient und Cramers V (gr��er 2x2).

# install.packages("vcd")
library(vcd) #ggf. wird ein zus�tzliches Paket geladen
assocstats(x)

#Cramers V geht von 0 bis 1.
#Cramers V ist zu verwenden wenn die Tabelle gr��er als 2x2 ist.
# Bei 2x2 Felder-Tabellen sind die Werte ggf. alle gleich gro�.

# Wenn die Tabelle 2x2 Feldern entspricht ist der Phi-Koeffizient zu nutzen. Dieser ergibt sich aus der Division des Chi-Quadrat Wertes durch die Anzahl der F�lle. Phi kann entsprechend Werte zwischen 0 und 1 annehmen. 
table(eastwest, sex)
summary(table(eastwest, sex))
assocstats(table(eastwest, sex))

# Interpretation von Phi-Koeffizient und Cram�r's V nach Cohen (1988)
# kleiner Effekt 	ab V = 0.1
# mittlerer Effekt 	ab V = 0.3
# gro�er Effekt 	ab V = 0.5



# Aufgabe -------------------------------------------------------
# Analysieren Sie eine der folgenden Hypothesen. Erstellen Sie dazu jeweils die Nullhypothese und die Alternativhypothese, f�hren Sie den entsprechenden Signifikanztest durch und melden Sie die entsprechende Effektst�rke zur�ck.

# 1. Gibt es einen Zusammenhang von Personen, die sich im Internet �ber Politik informieren (lm23) und dem Schulabschluss (educ)?

# 2. Ist die Bef�rwortung von h�rteren Ma�nahmen f�r den Umweltschutz (pa11) zwischen Frauen und M�nnern unabh�ngig?

# 3. Erstellen und analysieren Sie eine eigene Hypothese/ Nehmen Sie gern eine Hypothese ausgehend von "ihrer" deskriptiven Statistik.
