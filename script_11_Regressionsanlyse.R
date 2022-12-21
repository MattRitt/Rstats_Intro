# Regressionsanalyse mit R -----------------------------------------------
# Skript Matthias Ritter

# Inhalt
# Datensatz laden und Übersicht der Variablen
# einfache lineare Regression
# weitere Werte der Regression anzeigen lassen
# multiple lineare Regression
# Modellgüte


#  Datensatz laden und Übersicht der Variablen ----------------------------

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
# zunächst Plot zur Übersicht.

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

# Regressionsanalysen werden mit dem Befehl lm() (linear model) ausgeführt. 
# In unserem Bsp. ist das Einkommen (di01a) als abhängige Variable und Alter (age) die unabhängige Variable.

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

#es können auch einzelne Werte berechnet werden. Hier wird das Einkommen für eine 30jährige Person berechnet.
predict(model, list(age=30))

# Berechnung der Regression mit standardisierten Variablen, dann erhält man auch standardisierte Regressionskoeffizienten
lm(scale(di01a) ~ scale(age))

#bei bivariater Regression entspricht das standardisierte Regressionsgewicht der Korrelation zwischen beiden Variablen.

cor(di01a, age, use = "complete.obs")

#der quadrierte Wert des Regressionsgewichts entspricht (bei der einfachen linearen Regression dem R²)
0.0547444^2

# # multiple lineare Regression -------------------------------------------

# linearer Zshg. zwischen mehreren Prädiktoren wird berechnet.
# die Prädiktoren werden im Modell (gegenseitig) "kontrolliert"
# wird ebenfalls mit lm() durchgeführt die einzelnen Prädiktoren werden mit einem + verknüpft.

mult.model <- lm(di01a ~ age + sex + eastwest + ls01)
mult.model
summary(mult.model)

#Berechnung der stand. Betakoeffizienten.
mult.model <- lm(scale(di01a) ~ scale(age)+ scale(sex) + scale(eastwest) + scale(ls01))

# Modellannahmen prüfen -------------------------------------------------

#1 Linearität?
#2 Normalverteilung der Residuen
#3 Homoskedastizität (Ist die Varianz der Residuen über alle Ausprägungen der Prädiktoren hinweg gleich?)
#4 Ausreißer? (können einen großen Einfluss haben)
#5 Mulitkollinearität (sind die Prädiktoren untereinander nur gering korreliert?)
#(6 Unabhängigkeit der Residuen (sind Residuen unkorreliert?))

# 1 Linearität?
# zunächst bivariate Plots von av und (allen) Uv überprüfen
hist(di01a)
# ggf. kein linearer Zshg im Rentenalter modellierbar!
# sind alle relevanten Variablen enthalten? (educ oder iscd11 hinzufügen!?)

Arbeiter_innen <- subset(mydata, subset=age<65)
model_arb <- lm(di01a ~ age, data=Arbeiter_innen)
summary(model_arb)

# 2 Überprüfung der Normalverteilung der Residuen.

hist(resid(mult.model))
qqnorm(resid(mult.model))
qqline(resid(mult.model))
qqnorm(resid(model_arb))
qqline(resid(model_arb))

# 3 Homoskedastizität
par(mfrow= c(2,2))
plot(mult.model)
boxplot(di01a)

# Befehl, dass das Grafikfenster ausgeblendet wird, bzw. die Vierteilung aufgehoben wird.
dev.off()

# 4 Ausreißer
#werden in den Diagrammen jeweils angegeben. Diese sollten rausgenommen werden.

mydata[467, "di01a"]

#einzelnen Fall (Zeile) löschen

x <- c(467, 233, 1089)
mydata <- data[-467,]


#5 Mulitkollinearität (sind die Prädiktoren untereinander nur gering korreliert?)
# Ausmaß der Mulitkollinearität wird über die Toleranz und Variance Inflation Factor (VIF) quantitifziert.
#Toleranz hat einen Wertebereich von 0 bis 1 und sollte nahe bei 1 liegen und nicht kleiner als 0.10 
# der VIF sollte bei eins liegen und nicht größer als 10 sein.
#Der VIF ist der Kehrwert der Toleranz. 
install.packages("carData")
library(car)
vif(mult.model)

