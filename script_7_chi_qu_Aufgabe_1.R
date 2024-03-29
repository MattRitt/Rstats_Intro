#Aufgabe: 
# Analysieren Sie eine der folgenden Hypothesen. Erstellen Sie dazu jeweils die Nullhypothese und die Alternativhypothese, f�hren Sie den entsprechenden Signifikanztest durch und melden Sie die entsprechende Effektst�rke zur�ck.

#######################################################################

#setup
library(dplyr)
library(foreign)
data<-read.spss("./ALLBUS_2018.sav", use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)
data <- select(data, educ, lm23)
glimpse(data)
attach(data)

# Besprechung der Aufgabe 1

# 1. Gibt es einen Zusammenhang von Personen, die sich im Internet �ber Politik informieren (lm23) und dem Schulabschluss (educ)?

#Nullhypothese: Es gibt keinen Zusammenhang von Personen, die sich im Internet �ber Politik informieren und dem Schulabschluss.
#Alternativhypothese: Es gibt einen Zusammenhang von Personen, die sich im Internet �ber Politik informieren und dem Schulabschluss.
lm23_factor <- factor(lm23, labels = c("ja", "nein"))
educ_factor <- factor(educ, labels = c("Ohne Schulabschluss", "Volks-, Hauptschule", "Mittlere Reife", "Fachhochschulreife", "Hochschulreife", "Anderer Abschluss", "Noch Schueler"))

table(educ_factor)
table(lm23_factor)

table(lm23_factor, educ_factor)
round(prop.table(table(lm23_factor, educ_factor), 1)*100, 2)
summary(table(lm23, educ))
assocstats(table(lm23, educ))

#Interpretation
#Es zeigt sich, dass die Alternativhypothese anzunehmen ist. Mit einem Cramer's V von 0.423 besteht ein mittlerer Effekt. Somit ist von einem Zusammenhang zwischen dem Schulabschluss und der T�tigkeit sich im Internet �ber Politik zu informieren (Chi�=623, df = 6, p<0,05).



################## Voraussetzungen nicht erf�llt! Zellengr��e!
#Transformation sinnvoll, da Auspr�gung 6 "anderer Schulabschluss" und 7 "noch Sch�ler" gering besetzt und ggf. nicht Bestandteil der Fragestellung sind. Werte (6 und 7) werden auf NA gesetzt.

# zun�chst wird eine neue Variable educ_tf erstellt 
educ_tf <- educ
# das ist nur eine Vorsichtsmassnahme, so dass Werte nicht �berschrieben werden, so k�nnen auch neue und alte Variablen verglichen werden.

#Werte 6 und 7 werden auf NA gesetzt.
educ_tf[educ_tf==6] <- NA
educ_tf[educ_tf==7] <- NA
#schauen ob es geklappt hat.
table(educ_tf)
prop.table(table(educ_tf))*100
summary(educ_tf)
table(lm23, educ_tf)
round(prop.table(table(lm23, educ_tf), 1)*100, 2)

#f�r die neue Variable werden Wertelabels vergeben.
educ_tf_factor <- factor(educ_tf, labels = c("ohne Schulabschluss", "Volks/Hauptschule", "Mittlere Reife", "Fachhochschulreife", "Hochschulreife"))
table(educ_tf_factor)
round(prop.table(table(lm23_factor, educ_tf_factor), 1)*100, 2)

#die Variable educ_tf wird dem Datensatz hinzugef�gt:
data$educ_tf <- educ_tf
summary(data)

#das Objekt k�nnte nun auch aus dem Workspace entfernt werden.
rm(educ_tf)           #Objekt aus dem Workspace wird entfernt.
table(data$educ_tf) #Variable educ_tf (aus dem Datensatz) wird angezeigt

summary(table(lm23, educ_tf))
assocstats(table(lm23, educ_tf))

# m�gliche textliche Ergebnisdarstellung. 
# zun�chst die Tabelle mit den relativen H�ufigkeiten im Text einf�gen und beschreiben!
round(prop.table(table(lm23_factor, educ_tf_factor), 1)*100, 2)

# Die Tabelle (vgl. Tab 1) fasst die rel. H�ufigkeiten des Schulabschlusses zusammen, differenziert nach Personen, die sich im Internet �ber Politik informieren und Personen, die dies nicht tun. ... [herausstechende Zahlen  vertextlichen] ...  Dieser Zusammenhang wurde inferenzstatistisch gepr�ft.
# Die Voraussetzung zur Durchf�hrung eines Chi� Tests wurden �berpr�ft. [darlegen dass 2 Katgeroein aufgrund zu geringer Zellengr��e/ Nichtpassung mit Frage rausgenommen wurde un dsich der datenstz um 45 Befragte reduziert]

# Es kann ein statistischer Zusammenhang zwischen Personen, die sich �ber Politik im Internet informieren und Personen, welche das nicht tun hinsichtlich des Schulabschlusses (vgl. Tab XX) nachgewiesen werden (Chi�= 612.8, df = 4, p<.05). Personen, die sich im Internet �ber Politik informieren weisen - statistisch signifikant - einen h�heren Schulabschluss nach. Die Effektst�rke des untersuchten Zusammenhangs liegt nach Cohen (1988) mit einer St�rke von Cramer's V = 0.42 im mittlerem bis starkem Bereich.

