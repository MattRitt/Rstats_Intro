# Bivariate Statistik##############################
# T-test # 

# setup
# T-Test bei unabhängigen Stichproben
# Vorbereitung (Variablenerstellung und deskriptive Statistik)
# Prüfung der Voraussetzungen
# Testdurchführung
# Effektstärke: Cohen's d


# setup ---------------------------------------

library(dplyr)
library(foreign)
library(ggplot2)
library(mosaic)
library(psych)
library(car)
library(lsr)

# falls ein Paket nicht installiert wurde (bspw. Paket lsr, dann "install.packages("lsr")" ausführen

setwd("M:/Lehre/_WBF_Seminar/R")
data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)

data <- select(data, px01:px10, eastwest, sex, ls01)

data$eastwest.f <- as.factor(data$eastwest)
levels(data$eastwest.f) <- c("West", "Ost") 

head(data$sex)
data$sex.f <- as.factor(data$sex)
levels(data$sex.f) <- c("Mann", "Frau") 
head(data$sex.f)

attach(data)

# T-Test für unabhängigen Stichproben#####################

# ist eine parametrische Methode um Mittelwertunterschiede zwischen zwei Gruppen zu identifizieren.

# Wir werden die Hypothese prüfen, ob es bedeutende Unterschiede zwischen Ost- und Westdeutschland hinsichtlich des Ausmaßes rechtsextremistischer Einstellung gibt.

# Vorbereitung##########################################

# Variablenerstellung und deskriptive Statistik

# zunächst ist die abhängige Variable zu erstellen. (diese ist noch auf Gütekriterien: insbesondere Reliabilität und Dimensionalität zu prüfen, vgl. SoSe)
# Erstellung der Skala rassistische Einstellung.

rass_idx <- px01 + px02 + px03 + px04 + px05 + px06 + px07 + px08 + px09 + px10

data$rass_idx <- rass_idx #Skala wird dem Datensatz hinzugefügt.

# Nun ist zunächst zu überprüfen, ob die Variable erstellt wurde, bzw wie die zentralen Maße der Variabel (rassistischen Einstellung) aussehen.

favstats(rass_idx) # deine 'Lieblingsstatistiken' für die neu erstellte Variable bzw. für den Index rassistische Einstellung werden angezeigt.
favstats(rass_idx ~ eastwest.f) # deskriptive Beschreibung für unsere Hypothese
boxplot(rass_idx ~ eastwest.f) # Visualisierung als Boxplot.

# etwas schicker (hint: für die Hausarbeit) mit ggplot.
p <- ggplot(data, aes(rass_idx)) +
  geom_boxplot() +
  coord_flip() +
  facet_grid(.~eastwest.f) +
  labs(title ="Skala Rassistische Einstellung",
       subtitle= "differenziert nach Befragten in Ost- und Westdeutschland (N=2.895)",
       x="rassistische Einstellung") +
  theme_classic() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())
  
print(p)

# Prüfung der Voraussetzungen ###############################

# Bevor nun der T Test für unabhängige SP durchgeführt werden kann, müssen noch die Voraussetzungen geprüft werden: 
# a Unabhängigkeit der beiden Gruppen,
# b Normalverteilung der abh. Variable und 
# c Gleichheit der Varianzen.

## a Unabhängigkeit der beiden Gruppen ##########
# ist gegeben, die beiden Stichproben weisen keine Abhängigkeit voneinander auf.

## b Test auf Normalverteilung ################## 

# Test auf Normalverteilung der abhängigen Variable!

# mehrere Möglichkeiten zur Testung existieren (statistisch und grafisch). Immer ist ein Test auf Normalverteilung (1) durchzuführen. Dieser sichert die Normalverteilungsannahme jedoch oft nicht ab. Deswegen ist eine Angabe von Wölbung und Schiefe (2) möglich oder eine visuelle Prüfung (3) und - in diesem Fall, der visuellen Prüfung - wenn eine genügend große Stichprobe (wie beim Allbus) existiert, die Begründung mit dem zentralen Grenzwertsatz. Dieser besagt, dass je größer die Stichprobe wird, desto näher wird die Stichprobenverteilung normalverteilt sein. Deshalb können wir Hypothesentests durchführen, auch wenn die Grundgesamtheit nicht normalverteilt ist. (Voraussetzung ist eine "große" Stichprobe, mind. über N=30.)

### 1 Shapiro Wilk Test ######

# Prüfung der Normalverteilungsannahme mit Shapiro Wilk Test
shapiro.test(rass_idx)

# Nullhypothese sagt aus, dass Normalverteilung vorliegt.

# Normalverteilungsannahme ist für beide Gruppen zu prüfen.
# Erstellung eines neuen Datensatz mit Personen nur aus West bzw. nur aus Ost, so dass für jede Gruppe die Annahme untersucht werden kann.

west <- subset(data, eastwest==1)   
ost <-subset(data, eastwest==2)

shapiro.test(west$rass_idx)
shapiro.test(ost$rass_idx)

# Achtung bei der Stichprobengröße des Allbus wird der Shapiro Wilk Test (eigentlich immer) signifikant! 
# signifikant ist in diesem Fall ("nicht gut"), auf der Grundlage des Shapiro-Wilk Test muss davon ausgegangen werden, dass keine Normalverteilung vorliegt.
# Deswegen eher grafische Überprüfung.
# bereits bei sehr geringen Abweichungen wird die Nullhypothese abgelehnt.


### 2 Schiefe und Wölbung ############

# Normalverteilte Variablen haben für die Schiefe (Skewness) den Wert 0 und für die Kurtosis einen Wert von 3.

hist(rass_idx)
# Schiefe: ist Verteilung symmetrisch?
# rechtsschiefe Verteilung!!

# Rechtsschief & linkssteil: "Bodeneffekt" (bspw. wenn Items in einem Test zu "schwer" sind. Verteilung fällt rechts flacher ab als links bzw. umgekehrt steigt sie auf der linken Seite steiler an, daher bezeichnet man das auch als linkssteil

# wenn andere Richtung:                                      .
# Linksschief & rechtssteil "Deckeneffekt": Verteilung fällt links flacher ab als rechts bzw. umgekehrt steigt sie auf der rechten Seite steiler an, daher bezeichnet man das auch als rechtssteil

describe(rass_idx) 
# Symmetrie der Verteilung wird mit skew (Schiefe angegeben)
# rechtsschiefe Verteilungen haben eine positive Schiefe
# linksschiefe Verteilungen haben eine negative Schiefe

# bei describe wird kurtosis mit excess verwechselt.

# Wölbung: ist die Verteilung spitz oder flach?
# Wölbung (Kurtosis einer Normalverteilung hat den Wert 3.) 
# Kurtosis ist mit drei zu subtrahieren, dann ergibt sich der Excess.

# Excess < 0 	flachgipflige Verteilung
# Excess = 0 	normalgipflige Verteilung
# Excess > 0 	steilgipflige Verteilung

install.packages("moments")
library(moments)
skewness(rass_idx, na.rm=T)
kurtosis(rass_idx, na.rm=T)

### 3 Grafische Prüfung ##############

# Grafische Prüfung auf Normalverteilung

# Des Weiteren kann visuell auf Abweichungen von der Normalverteilung geprüft werden, beispielsweise über ein Histogramm mit einer Normalverteilungskurve oder über einen Normal-Probability-Plot.

hist(rass_idx)  # Histogramm der Variable.
#noch mit Normalverteilungskurve.
curve(dnorm(x, mean(rass_idx, na.rm=T), sd(rass_idx, na.rm=T)),add=T)

hist(west$rass_idx) # bzw. für West und Ost
hist(ost$rass_idx)

# eine sehr gebräuchliche Form die Normalverteilungsannahme optisch zu prüfen besteht in der Erstellung eines QQ-Plots, dieses wird erstellt aus den Quantilen der interessierenden Variable in Verbindung mit Quantilen der Normalverteilung. Wenn der Großteil der Punkte auf der Linie sind, kann von einer Normalverteilung ausgegangen werden.

qqnorm(rass_idx, ylab="Quantile Rassismus Index")
qqline(rass_idx, col=2, lwd=5)
?qqline
#ein Großteil der Werte der Verteilung der (abh.) Variable liegt auf der QQ Linie.



## c Gleichheit der Varianzen #########

# Varianzen sollten in beiden Stichproben nahezu gleich sein.

# wird mit Levene Test überprüft.
# Ausgangspunkt wieder die deskriptive Statistik für unsere Hypothese

favstats(rass_idx ~ eastwest.f) 
# quadrieren der sd entspricht der Varianz.
# Varianzen sehen also relativ ähnlich aus.
# install.packages("car")
# Nullhypothese des Levene Test ist, dass die Varianzen gleich sind, falls der p Wert unter die "Schranke" von 0.05 fällt, ist von Ungleichheit der Varianzen auszugehen.

leveneTest(rass_idx, eastwest.f)
# wir müssen also von unterschiedlichen Varianzen ausgehen.

# an sich wäre nun der Welch Test (für ungleiche Varianzen) durchzuführen, da die Stichptobengröße so groß ist (Grenzwertsatz) und die Differenz der Varianzen nicht all zu groß ist wird doch der t test durchgeführt. Bzw kann im genutzten Paket angegeben werden, dass die Varianzen nicht gleich sind.


# t Test################################################

# Testdurchführung

#Nullhypothese: der Mittelwert rassistischer Einstellung Ost = rassistischer Einstellung West.
# zweiseitiger Test, Richtung wurde nicht vorgegeben!
# Gleichheit der Varianzen wird unterstellt.

t.test(rass_idx~eastwest)

# die Zeile oben reicht für einen zweisetigen Test, um euch die ganzen Einstellungsmöglichkeiten zu zeigen, hier die genutzten Defaultangaben:

t.test(rass_idx~eastwest, mu=0, alternative="two.sided", conf=0.95, var.equal=FALSE, paired=FALSE) # ergibt das gleiche Resultat wie: t.test(rass_idx~eastwest)

#hier ein Beispiel für einen einseitigen Test:
t.test(rass_idx~eastwest, alternative="less", var.equal=TRUE)
t.test(rass_idx~eastwest, alternative="greater", var.equal=TRUE)

# alternative = "greater" is the alternative that x has a larger mean than y

# Effektstärke berechnen ##############

# mit dem T Test erfährt man lediglich ob zwischen den beiden Stichproben ein signifikanter Unterschied besteht. Wenn ein signifikanter Unterschied besteht ist die Frage wie große der Unterschied (Effekt) ist? Es wird Cohen's d verwendet. (das gibt es standardmäßig in R (natürlich) nicht) lsr Paket!

# Cohen's d ergibt sich aus den Mittelwerten der beiden Gruppen geteilt durch die (gepoolte) Standardabweichung.

favstats(rass_idx) 
favstats(rass_idx ~ eastwest.f)

(23.31-21.47)/6.81

# mit Paket:

cohensD(rass_idx~eastwest)

# Interpretation von  CohensD (1988)
# kleiner Effekt 	ab d = 0.2
# mittlerer Effekt 	ab d = 0.5
# großer Effekt 	ab d = 0.8



# Aufgabe ------------------------------------------------------

# Analysieren Sie eine der folgenden Hypothesen. Erstellen Sie dazu jeweils die Nullhypothese und die Alternativhypothese, testen Sie die Voraussetzungen und führen Sie den entsprechenden Signifikanztest durch und melden Sie die entsprechende Effektstärke zurück.

# 1. Männer haben deutlich mehr Einkommen (inc) als Frauen (cohens d>.5).

# 2. Die Lebenszufriedenheit (ls01) unterscheidet sich deutlich zwischen, Personen, die in Deutschland geboren sind und Personen, die nicht in Deutschland geboren sind (dn07).

# Alternativ: Erstellen und analysieren Sie eine eigene Hypothese/ Nehmen Sie gern eine Hypothese aus Ihrer Fragestellung.


# Klausuraufgabe ----------------------------------------------------------

# T-Test zum Unterschied der Lebenszufriedenheit zwischen Männern und Frauen aus ALLBUS 2018.


# setup ---------------------------------------

# Pakete laden, ggf vorher noch alle installieren bspw.
install.packages("foreign")
library(dplyr)
library(foreign)
library(mosaic)
library(psych)
library(car)
library(lsr)

# Daten laden.
setwd("M:/Lehre/_WBF_Seminar/R") # Verzeichnis wo Allbus liegt angeben.
data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)
data <- select(data, sex, ls01) # Variablen auswählen
data$sex.f <- as.factor(data$sex) # Geschlecht als Faktor
levels(data$sex.f) <- c("Mann", "Frau") 
attach(data)

favstats(ls01)
favstats(ls01 ~ sex.f)
boxplot(ls01 ~ sex.f)
leveneTest(ls01, sex.f)
t.test(ls01 ~ sex.f)
cohensD(ls01 ~ sex.f)
