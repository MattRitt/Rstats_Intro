#Faktorenanalyse # 
# 
# 1 Datensatz und notwendige Pakete laden.
# 2 Variablen der Skala Rechtsextremismus selektieren.
# 3 Korelationsmatrix
# 4 Bartlett Test und Kaiser Meyer Olkin Kriterium
# 5 Bestimmung der Anzahl der Faktoren (u.a. Screeplot)
# 6 Ausführen der Faktorenanalyse
# 7 Reliabilitätsanalyse


#  1 Datensatz und notwendige Pakete laden. -------------------------------


library(foreign)
#das Laufwerk setzen, in welchem der Datensatz liegt!
setwd("M:/Lehre/_WBF_Seminar/R")  
data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)

attach(data)
#mit dem attach Befehl brauchen wir nicht jeweils angeben, welcher Datensatz gemeint ist, ansonsten müssten wir beim Aufrufen der Variablen jeweils Datensatz$Variable schreiben.

#für die folgenden Berechnungen braucht es:

install.packages("psych")
library(psych)
install.packages("psy")
library(psy)
install.packages("nFactors")
library(nFactors)

# 2 Variablen der Skala rassistische Einstellung selektieren. ------------------

# wir brauchen nicht alle 706 Variablen und selektieren nur die 10 Variablen (Items) der Skala.
mydata <- data.frame(px01, px02, px03, px04, px05, px06, px07, px08, px09, px10)
attach(mydata)


#Variablen betrachten
str(mydata)
head(mydata)
summary(mydata)
describe(mydata)

# 3 Korrelationsmatrix ----------------------------------------------------

cor(mydata, use= "pairwise.complete.obs")

# na.omit: Alle Beobachtungen mit missing values aus Data-Frame ausschließen mit
mydata.cleaned <- na.omit(mydata)
cor(mydata.cleaned)


# 4 Bartlett Test und KMO -------------------------------------------------------

# prüft ob die Items ausreichend miteinander korrelieren.

cortest.bartlett(mydata)

# Wenn p<0.05 dann ist von ausreichender Korrelation zwischen den Items auszugehen.

# Kaiser Meyer Olkin Kriterium

KMO(mydata)

# MSA Wert sollte größer 0.5 sein.
# Bei Items kleiner 0.5 item ausschließen!

# 5 Bestimmung der Anzahl der Faktoren (Screeplot) ----------------------

ev <- eigen(cor(mydata.cleaned)) # eigenvalues werden ermittelt
ap <- parallel(subject=nrow(mydata.cleaned),var=ncol(mydata.cleaned),
               rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)


# # 6 Ausführen der Faktorenanalyse ---------------------------------------

mydata.fa <- factanal(mydata.cleaned, factors=3, rotation="varimax")
print(mydata.fa, digits=2, cutoff=.3, sort=TRUE)

# Maximum Likelihood Factor Analysis
# entering raw data and extracting 3 factors,
# with varimax rotation


# im Idealfall lädt jedes Item auf einen Faktor.
# inhaltliche Interpretation notwendig

#Berechnung der Kommunalitäten.
1-mydata.fa$uniqueness

# Kommunalitäten geben an wieviel Varianz von diesen einzelnen Items durch die 
# Faktoren erklärt werden (die Relvanz der Items wird dadurch ersichtlich)

#Screeplot
scree.plot(mydata.fa$correlation)


# 7 Reliabilitätsanalyse
psych::alpha(mydata)

psych::alpha(mydata.cleaned[c("px01", "px02", "px03", "px04", "px05", "px06", "px07", "px08", "px09", "px10")], check.keys=TRUE)

# raw alpha entspricht dem Cronbach-alpha

# Interpretation nach Streiner 2010:
# alpha > 0.6 (noch) akzeptabel
# alpha > 0.7 gut
# alpha > 0.8 sehr gut
# alpha > 0.9 redundante Items?
  


#ausprobieren
#Item 6 rausnehmen
mydata.new <- data.frame(px01, px02, px03, px04, px05, px07, px08, px09, px10)
attach(mydata.new)
mydata.new.cleaned <- na.omit(mydata.new)
#nochmal FA
mydata.fa <- factanal(mydata.new.cleaned, factors=3, rotation="varimax")
print(mydata.fa, digits=2, cutoff=.3, sort=TRUE)
