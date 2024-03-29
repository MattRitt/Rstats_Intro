# logistische Regression --------------------------------------------------

# Ziel: Einfluss von unabh�ngigen Variablen auf eine (nominale!)  abh�ngige Variable modellieren. Ermittelt wird eine Wahrscheinlichkeit (0-1) in eine Gruppe (der aV) zu geh�ren.

# 1.  Vorarbeiten 
# 2.	Voraussetzungen pr�fen
# 3.  Testmodell 1
# 4.	Testmodell 2


# 1. Vorarbeiten -------------------------------------------------------------

# aktuellen Working Space clearen.
rm(list = ls())

# Datensatz laden und notwendige Variablen ausw�hlen.
library(foreign)
setwd("M:/Lehre/_WBF_Seminar/R")
data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)
attach(data)
data

#Teildatensatz
mydata <- data.frame(age, ep01, sex, eastwest, di01a, isced97, ls01, px01, px02, px03, px04, px05, px06, px07, px08, px09, px10, pv24)

attach(mydata)
summary(mydata)

# Erstellung der Skala rassistische Einstellung.
rass_idx <- px01 + px02 + px03 + px04 + px05 + px06 + px07 + px08 + px09 + px10
mydata$rass_idx <- rass_idx #Skala wird dem Datensatz hinzugef�gt.

#deskriptive Statistik
psych::describe(mydata)

# deskriptive Statistik und Erstellung der Variable AFD Wahl aus pv24.
psych::describe(pv24)
str(pv24)
hist(pv24)
table(pv24)

#schauen, inwiefern rassistische Einstellung und Wkt der Wahl der AFD zusammenh�ngen.
cor(rass_idx, pv24, use="complete.obs")

#Dichotomisierung der Variable pv24.

library(dplyr)
pv24_dich <- case_when((pv24 <= 5) ~ 0,
                       (pv24 >= 6) ~ 1)
table(pv24_dich)
mydata$pv24_dich <- pv24_dich  #Variable wird dem Datensatz hinzugef�gt.
psych::describe(pv24_dich)

# Achtung, hier wird eigentlich Varianz "verschenkt" eigentlich w�re das hier nicht notwendig, und es k�nnte eine multiple Regression durchgef�hrt werden. Wir wollen hier aber die log. Regression veranschaulichen (aV mit 2 Auspr�gungen

# Vergabe von Variablenlabel und Wertelabel f�r pv24_dich
# install.packages("expss")
install.packages("expss")
library(expss)

var_lab(pv24_dich) = "AFD Wahl"
val_lab(pv24_dich) = num_lab("0 keine AFD Wahl
                              1 AFD Wahl")
str(pv24_dich)
table(pv24_dich)


# 2. Voraussetzungen pr�fen --------------------------------------------------

# av nominal! uv nominal oder intervall/metrisch
# Linearit�t zwischen kont. Pr�diktor und Logit -> log. Interakionsterme in das Modell aufnehmen. sh. Field 2012, S. 344, f�r Seminararbeit nicht notwendig. 
# Unabh�ngigkeit der Residuen
# Multikollinearit�t-> Korrelationen der Pr�diktorvariablen pr�fen.


# Testmodell1 -------------------------------------------------------------

model1 <- glm(pv24_dich ~ rass_idx, data=mydata, family = binomial())
summary(model1)

# schauen ob das Modell f�r sich 'signifikant' ist, also ob die Pr�diktoren im Vergleich zum Nullmodell eine h�here Aussagekraft haben. Das wird mit dem Omnibustest gemacht, welcher auf eine Chi� Verteilung beruht.

#OmnibusTest
modelchi <- model1$null.deviance - model1$deviance
chidf <- model1$df.null - model1$df.residual
chisq.prob <- 1-pchisq(modelchi, chidf)
chisq.prob

# Wenn der Sign.Wert des Omnisbustests unter 0,05 liegt, kann die Analyse fortgestezt werden.

#Berechnung der Odds Ratio und deren Konfidenzintervalle ist wichtig f�r die Interpretation.
exp(cbind(OR = coef(model1), confint(model1)))

# Interpretation: Wenn der Wert auf der Rassismus-Skala um 1 steigt, gibt es eine um 1,14 h�here Chance die AFD zu w�hlen.

#G�tekriterien
#bei der log. Regression k�nnen nicht die (aus der linearen Regression) bekannten Bestimmtsheitsma�e auf der Grundlage der aufgekl�rten Varianz bestimmt werden. Es k�nnen jedoch sog. Pseudo-R Quadrate bestimmt werden, die sich (auch) durch das Wechselverh�ltnis von Null- und Testmodell ergeben. Bestimmt wird das R� von Cox-Snell sowie (darauf aufbauend) das zumeist verwendete R2 von Nagelkerke.

n <- length(model1$residuals)
R2CS <- 1-exp((model1$deviance-model1$null.deviance)/n)
R2N <- R2CS/(1-exp(-(model1$null.deviance/n)))
R2N
# Nagelkerke sollte mind. 0.1 sein, kann bis zu 1 erreichen.
# zwischen 0.1 und 0.3 kann von einer akzeptablen Erkl�rungsg�te gesprochen werden, zwischen 0.3 und 0.5 als gut und ein Nagelkerke �ber 0.5 wird als sehr gut bezeichnet. (Backhaus 2005)


# #Testmodell2 ------------------------------------------------------------

model2 <- glm(pv24_dich~ rass_idx + eastwest + sex, data=mydata, family = binomial())
summary(model2)

#schauen ob das Modell f�r sich 'signifikant' ist, also die Pr�diktoren im Vergleich zum Nullmodell eine h�here Aussagekraft haben. Das wird mit dem Omnibustests gemacht, welcher auf eine Chi� Verteilung beruht.

#OmnibusTest
modelchi <- model2$null.deviance - model2$deviance
chidf <- model2$df.null - model2$df.residual
chisqp <- 1- pchisq(modelchi, chidf)
chisqp

#Berechnung der Odds Ratio und deren Konfidenzintervalle ist wichtig f�r die Interpretation.
exp(cbind(OR = coef(model2), confint(model2)))

# Interpretation: Wenn der Wert auf der Rassismus-Skala um 1 steigt, gibt es eine um 1,14 h�here Chance die AFD zu w�hlen.
# Bei nominalen Daten ist die Referenzkategorie zu beachten:
# 1 entspricht ,alteBL';  2 entspricht ,neueBL'
# in den neuenBL ist die Wkt AFD zu w�hlen 1,67 mal h�her als in den alten BL.
# bei sex entspricht 1 der Kategorie Mann, 2 entspricht Kategorie Frau
# F�r Frauen halbiert sich die Wkt AFD zu w�hlen im Vgl. zu M�nnern.
# oder (meist sinnvoller: das Inverse zu bilden) und dann umgekhert interpretieren.
1/0.52
# M�nner haben im Vergleich zu Frauen eine fast doppelt (OR=1.92) so hohe Wkt AFD zu w�hlen(unabh�ngig von rass. Einstellung und OstWest.)

#G�tekriterien

n <- length(model2$residuals)
R2CS <- 1-exp((model2$deviance-model2$null.deviance)/n)
R2N <- R2CS/(1-exp(-(model2$null.deviance/n)))
R2N

#die Modellg�te liegt im akzeptablen Bereich.

# Nagelkerke sollte mind. 0.1 sein.
# zwischen 0.1 und 0.3 kann von einer akzeptablen Erkl�rungsg�te, zwischen 0.3 und 0.5 als gut und ein Nagelkerke �ber 0.5 wird als sehr gut bezeichnet. (Backhaus 2005)

