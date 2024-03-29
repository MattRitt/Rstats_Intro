# Regressionsanalyse mit R -----------------------------------------------
# Skript Matthias Ritter

# Inhalt
# Datensatz laden und �bersicht der Variablen
# einfache lineare Regression
# weitere Werte der Regression anzeigen lassen
# multiple lineare Regression
# Modellg�te


#  Datensatz laden und �bersicht der Variablen ----------------------------

library(foreign)
setwd("M:/Lehre/_WBF_Seminar/R")
data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)
attach(data)
#Teildatensatz

mydata <- data.frame(age, sex, eastwest, di01a, ls01)

attach(mydata)
summary(mydata)
head(mydata)
psych::describe(mydata)

# es interessiert der Zusammenhang von Alter auf das Einkommen.
# zun�chst Plot zur �bersicht.

plot(age, di01a) 

plot(age, di01a, 
     type = "p", 
     col = "lightblue", 
     lwd=2, 
     main = "Streudiagramm Alter und Einkommen", 
     xlab="Alter in Jahren",
     ylab="Einkommen in Euro")

boxplot(di01a~age, data=mydata,
        main = "Boxplotdiagramm Alter und Einkommen",
        xlab="Alter in Jahren",
        ylab="Einkommen in Euro")


# einfache lineare Regression -------------------------------------------

# Regressionsanalysen werden mit dem Befehl lm() (linear model) ausgef�hrt. 
# In unserem Bsp. ist das Einkommen (di01a) als abh�ngige Variable und Alter (age) die unabh�ngige Variable.

lm(di01a ~ age)
#y=b0+ b1x +e.
#y=1584 + 3,97*x

#Intercept (b0) und Regressionsgewicht (b1) wird angegeben.

#Regression in ein Objekt speichern.
model <- lm(di01a ~ age)
# die Regressionsgerade wird eingezeichnet.
abline(model, col= "red")
# hier optional, das Grafikfenster wird ausgeblendet.
dev.off()
#Zusfg. des Objekts wird angegeben!
summary(model)

# weitere Werte der Regression anzeigen lassen: -------------------------

#es k�nnen auch einzelne Werte berechnet werden. Hier wird das Einkommen f�r eine 30j�hrige Person berechnet.
predict(model, list(age=30))

# Berechnung der Regression mit standardisierten Variablen, dann erh�lt man auch standardisierte Regressionskoeffizienten
lm(scale(di01a) ~ scale(age))

#bei bivariater Regression entspricht das standardisierte Regressionsgewicht der Korrelation zwischen beiden Variablen.

cor(di01a, age, use = "complete.obs")

#der quadrierte Wert des Regressionsgewichts entspricht (bei der einfachen linearen Regression dem R�)
0.0547444^2

# # multiple lineare Regression -------------------------------------------

# linearer Zshg. zwischen mehreren Pr�diktoren wird berechnet.
# die Pr�diktoren werden im Modell (gegenseitig) "kontrolliert"
# wird ebenfalls mit lm() durchgef�hrt die einzelnen Pr�diktoren werden mit einem + verkn�pft.

mult.model <- lm(di01a ~ age + sex + eastwest + ls01)
mult.model
summary(mult.model)

#Berechnung der stand. Betakoeffizienten.
mult.model <- lm(scale(di01a) ~ scale(age)+ scale(sex) + scale(eastwest) + scale(ls01))

# Modellannahmen pr�fen -------------------------------------------------

#1 Linearit�t?
#2 Normalverteilung der Residuen
#3 Homoskedastizit�t (Ist die Varianz der Residuen �ber alle Auspr�gungen der Pr�diktoren hinweg gleich?)
#4 Ausrei�er? (k�nnen einen gro�en Einfluss haben)
#5 Mulitkollinearit�t (sind die Pr�diktoren untereinander nur gering korreliert?)
#(6 Unabh�ngigkeit der Residuen (sind Residuen unkorreliert?))

# 1 Linearit�t?
# zun�chst bivariate Plots von av und (allen) Uv �berpr�fen
hist(di01a)
# ggf. kein linearer Zshg im Rentenalter modellierbar!
# sind alle relevanten Variablen enthalten? (educ oder iscd11 hinzuf�gen!?)

Arbeiter_innen <- subset(mydata, subset=age<65)
model_arb <- lm(di01a ~ age, data=Arbeiter_innen)
summary(model_arb)

# 2 �berpr�fung der Normalverteilung der Residuen.

hist(resid(mult.model))
qqnorm(resid(mult.model))
qqline(resid(mult.model))
qqnorm(resid(model_arb))
qqline(resid(model_arb))

# 3 Homoskedastizit�t
par(mfrow= c(2,2))
plot(mult.model)
boxplot(di01a)

# Befehl, dass das Grafikfenster ausgeblendet wird, bzw. die Vierteilung aufgehoben wird.
dev.off()

# 4 Ausrei�er
#werden in den Diagrammen jeweils angegeben. Diese sollten rausgenommen werden.

mydata[467, "di01a"]

#einzelnen Fall (Zeile) l�schen

x <- c(467, 233, 1089)
mydata <- data[-467,]


#5 Mulitkollinearit�t (sind die Pr�diktoren untereinander nur gering korreliert?)
# Ausma� der Mulitkollinearit�t wird �ber die Toleranz und Variance Inflation Factor (VIF) quantitifziert.
#Toleranz hat einen Wertebereich von 0 bis 1 und sollte nahe bei 1 liegen und nicht kleiner als 0.10 
# der VIF sollte bei eins liegen und nicht gr��er als 10 sein.
#Der VIF ist der Kehrwert der Toleranz. 
install.packages("carData")
library(car)
vif(mult.model)

