##################################################################
# Korrelationsanalyse # 
# 
# 1 Setup
# 2 Korrelationsanalyse
# 3 Korrelationstest
# 4 Anmerkungen

###################################################################


# 1 Setup -----------------------------------------------------------------

library(foreign)
setwd("M:/Lehre/_WBF_Seminar/R")  
data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)
attach(data)


# 2 Korrelationsanalyse ---------------------------------------------------

# Die Korrelation zwischen zwei Variablen lässt sich mit der cor() Funktion bestimmen.
# hier die "volle" Funktion: cor(x, y, method = c("pearson", "spearman", "kendall"))
# folgend ein Bsp für die Korrelation zwischen Lebenszufriedenheit und Einkommen.

cor(ls01, inc)
# Warum funktioniert es nicht? -> Variablen enthalten missing values.
mosaic::favstats(data$ls01)
mosaic::favstats(data$inc)

cor(ls01, inc, na.rm=T)
?cor()

cor(ls01, inc, use = "complete.obs")

# Interpretation des Korrelationskoeffizienten
# nimmt Werte zwischen -1 und 1 an.
#   
# -1 indiziert eine starke negative Korrelation: Wenn x größer wird, dann reduziert sich x
# 0 indiziert keinen Zusammenhang (Unabhängigkeit der Variablen x und y)
# 1 indiziert eine starke positive Korrelation: Wenn x größer wird, dann vergrößert sich x

# Hinweis: Korrelation zwischen x und y sind gleich große wie zwischen y und x, Reihenfolge ist egal. 
cor(inc, ls01, use = "complete.obs")

# standardmäßig wird der Pearson'sche Korrelationskoeefzient berechnet.

# Spearman'sche Korrelationskoeffizient oder Kendall-tau (für zwei ordinale Variablen)
cor(inc, ls01, method = "spearman", use = "complete.obs")
cor(inc, ls01, method = "kendall", use = "complete.obs")


# Die Effektstärke ist im Rahmen der Korrelation der Korrelationskoeffizient r selbst. 
# Laut Cohen: Statistical Power Analysis for the Behavioral Sciences (1988), S. 79-81 sind die Effektgrenzen:
# 
# ab 0,1 (schwach)
# ab 0,3 (mittel)
# ab 0,5 (stark).


# 3 Korrelationstest ------------------------------------------------------

# Zur Ausfürhung des Signifikanztests ist "lediglich" .test nach cor zu setzen.
# cor.test(x, y, method=c("pearson", "kendall", "spearman"))

cor.test(inc, ls01, use = "complete.obs")
 
# t Wert der T Statistik
# df, Freiheitsgrade
# p-value Signaifikanzniveau
# konfidence interval des Kooefizienten
# sample estimates ist der correlationscoefficient

