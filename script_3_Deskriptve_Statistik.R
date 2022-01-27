##### Deskriptive Statistik mit R ####
## Quantitative Untersuchungen 
## M Ritter

# Intro
# 1 grundlegende deskriptive Statistik
# Übung
# 2 einfache Grafiken und Tabellen mit Base R


#### Intro ####

# zunächst ist unser Datensatz zu laden.
library(foreign)
setwd("M:/Lehre/_WBF_Seminar/R")
data<-read.spss("./ALLBUS_2018.sav",use.value.labels=F, use.missings=TRUE, to.data.frame = TRUE)

# schauen ob es geklappt hat.
head(data$ep01)


##### 1 grundlegende deskriptive Statistik #####

# nun zu ein paar grundlegenden Befehlen deskriptiver Statistik in R.
# Lage- und Streuungsmaße in R:
# mean(), sd(), var(), min(), max(),median(), length(), range(), quantile(), fivenum()

# um die Beispielfunktionen aufzurufen wird jeweils der Variablenname in die Klammer gepackt.
#Mittelwert, Standardabweichung und Varianz
mean(data$age)

# Warum wird NA angezeigt?
?mean

# es kann zu Fehlermeldungen kommen, wenn fehlende Werte (NA) in einer Variable existieren. Das ist bspw. bei der Frage zum Alter der Fall.
# im Standard mean Befehl können NA nicht verarbeitet werden. Wenn NA erscheint, ist das Zusatzargument na.rm=TRUE anzufügen, für "remove the na values from data", die NA werden bei der Berechnung nicht berücksichtigt:

mean(data$age, na.rm=TRUE)

# in base R sind NA nach default als FALSE gesetzt: mean(x, na.rm = FALSE, ...) bzw. sh. Hilfe ?mean, d.h. standardmäßig werden die NA's genutzt. (Das kann / ist oft in anderen Paketen anders).

# Das gleiche gilt für die Standardabweichung und Varianz:

sd(data$age, na.rm=TRUE) 
var(data$age, na.rm=T) 
# es reicht auch nur das T von True zu schreiben.

# Was bedeuten Standardabweichung sd() und Varianz var()?

##### Übung 1 #####
# Schreiben Sie die Syntax, so dass für die Variable alter (age) die restlichen Merkmale beschreibender Statistik von oben (min(), max() ... angezeigt werden. Was bedeuten die Ouputs?

x <- data$age
min(x, na.rm=T)
length(x)
quantile(x, na.rm=T)
fivenum(x, na.rm=T)
# TIPPS #
summary(x)

# neben der zusammenfassenden Darstellung mittels summary(), gibt auch der Befehl describe() einen Überblick einer Variable, für letzteren ist das package "psych" zu laden (bzw. vorher zu installieren). 
# install.packages("psych") 
# library(psych)
# describe(data$age)

# wenn nur ein konkreter Befehl aus einem Paket geladen werden soll, reicht auch folgende schreibweise (ohne vorher das Paket zu laden)
psych::describe(data$age)
install.packages("psych")
library(psych)
describe(data$age, IQR=TRUE)
describe(data$age, quant=c(.1, .25, .6))

# Statistiken abhängig von Gruppen angeben.
describeBy(data$age, group=data$sex)

# ein weiterer Tipp noch: wenn Sie nicht immer den Namen des Datensatzes beim Aufrufen einer Variable schreiben wollen, können Sie den attach Befehl nutzen, wenn dieser aktiviert ist, wird sich jeweils auf dieses Element bezogen. Es reicht also die Angabe von age anstelle von data$age.

attach(data)

mean(age, na.rm=TRUE)

##### 2 einfache Grafiken und Tabellen mit R ####

# hier geht es nun erstmal um die Basics, als im tatsächlichem Sinne wird das "BAse" Paket von R genutzt, R ist sehr 'mächtig' wenn es um Grafiken (und im Prinzip auch Tabellen) geht. 

#der Befehl table(x) gibt euch eine einfache Tabelle eines Objekts aus.
table(ep01)
#für zwei Variablen dann bspw. so
table(ep01, eastwest)
#mit prop.table bekommt ihr die relative Häufigkeit ausgegeben.
prop.table(table(ep01))
prop.table(table(ep01, eastwest))
#ihr könnt den Wert noch mit 100 multiplizieren, so bekommt ihr die Prozentangaben angenehmer angezeigt.
prop.table(table(ep01))*100

#Pakete für schicke Tabellen:

#gt https://themockup.blog/posts/2020-09-04-10-table-rules-in-r/
#flextable https://ardata-fr.github.io/flextable-book/
#kableExtra - great for HTML/LaTex
#formattable - great for custom fill of cells and HTML
#DT or reactable - great for reactive tables

# Bsp. gt #install.packages("gt")
install.packages("gt")
library(gt)
data.sub <- data.frame(ep01, eastwest, sex)

head(data.sub) %>% 
  gt() %>%
  tab_header(
    title = ("Titel"),
    subtitle = ("Untertitel")) %>%
    tab_source_note(
      source_note = "Quelle: ALLBUS 2018") 
?gt

# Tabellen können für Grafiken genutzt werden.
#die letzte Tabelle kann auch als Grafik angezeigt werden.
#hier der Befehl für ein einfaches Balkendiagramm.

barplot(prop.table(table(ep01))*100)

#zur grafischen Darstellung ist es übersichtlicher die Tabelle als neues Objekt zu speichern.

wl <- prop.table(table(ep01))*100
barplot(wl)

#nun noch etwas "schicker" gemacht.

barplot(wl,
        main = "Beurteilung der wirtschaftlichen Lage in
        Deutschland, in Prozent",
        ylab = "Prozent",
        names.arg = c("sehr gut", "gut", "teils /teils",
        "schlecht", "sehr schlecht"),
        col = "lightblue")
?barplot
# mit names.arg können Wertebeschriftungen hinzugefügt werden.
#bei Faktoren geschieht das automatisch! (müssen aber eventuell erstellt werden)

#weiteres Beispiel mit der Variable Alter in Kategorien.

table(agec)

barplot((table(agec)),
        main="Übersicht der Altersverteilung im ALLBUS 2018",
        xlab="Alterskategorien in Jahren",
        ylab="Anzahl",
        names.arg = c("18-29", "30-44", "45-59", "60-74", "75-89", "UEBER 89"),
        col="salmon")

#Mit Low-Level-Grafikfunktionen können zu bestehenden Grafiken zusätzliche Elemente hinzugefügt werden. 
#Beispiel für low level Grafiken (sh. auch Folien)

plot(age, di01a) 

#mit abline() wird eine gerade in einen Plot eingezeichnet.
abline(1000, 12, col= "blue")

#mit legend() wird eine Legende eingefügt.
legend("topright", legend=c("Regressionsgerade"),
       col=c("blue"), lty=1, cex=0.7)

#mit folgendem Befehl wird der Bildschirm gelöscht.
dev.off()


##### Übersicht einfacher Grafiken in base R ####

# hier Beispiel für 1 variable:
hist(age)                    # histogramm
boxplot(di01a)                 # boxplot
barplot(table(ep01))         # barchart
pie(table(ep01))             # piechart


# Beispiele für 2 Variablen:
plot(age, di01a)                  # scatterplot
barplot(table(ep01, eastwest))    # barchart
boxplot(di01a ~ eastwest)          # boxplot

# Beispiel für mehrere Variablen.
# pairs(data)  # scatterplot für einen gesamten Datensatz (da der Datensatz zu groß ist, lieber nicht ausführen!)
#folgender Befehl erstellt einen Datensatz mit 3 VAr.
data.cont <- data.frame(age, lm02, di01a)
pairs(data.cont)

#die Grafiken können weiter konfiguriert werden, hier ein Beispiel:

plot(age, di01a) 

plot(age, di01a, 
     type = "p", 
     col = "red", 
     lwd=1, 
     main = "Streudiagramm Alter gegen Einkommen", 
     sub = "Untertitel",
     xlab="Alter", 
     ylab="Einkommen in Euro")

dev.off()

model <- lm(di01a ~ age)
abline(model, col= "blue")
summary(model)

plot(age, di01a) 

abline(1000, 12, col= "purple")

boxplot(data$age, 
     main = "Streudiagramm Alter gegen Einkommen" 
     )

?boxplot

dev.off()

### Variablen in andere Datentypen umkehren. ####

class(ep01)
ep01.f <- as.factor(ep01)

class(ep01.f)

levels(ep01.f)<-c("sehr gut", "gut", "teils/ teils", "schlecht", "sehr schlecht")
levels(ep01.f)

# von factor auf numeric
ep01.n <- as.numeric(ep01.f)

#weiteres Beispiel
eastwest <- as.factor(eastwest)
levels(eastwest)<-c("Ost", "West")
str(eastwest)

# hier noch etwas schickes für euch, dazu muss der Datensatz anders geladen werden (mit Paket haven)
data_h <- haven::read_sav("./ALLBUS_2018.sav")
# Übersicht aller Labels im Datensatz im Viewer, bzw. als html file
sjPlot::view_df(data_h)

levels(ep01)
levels(data_h$ep01)
str()

# install.packages("sjPlot")

##### Aufgabe 2 #####

#Ausgehend von der Fragebogendokumentation und dem Variablenbericht des ALLBUS 2018 (sh. OPAL): 

# 1. Welche drei Fragen (mind. 2 unterschiedliche Skalenniveaus) des Fragebogens sind für Sie "interessant"? (Frage, Fragenummer und Variablennummer notieren) 
# 2. Stellen Sie die drei Variablen deskriptiv dar (Lage- und Streuungsmaße sowie grafische Darstellung) 
# 3. Beschreiben Sie die Variablen in Textform (ca. jeweils 3 bis 5 Sätze).

# Laden Sie das Dokument bis 30.11.2021 auf OPAL hoch 
# (Dateiname: Name_Deskription). Hinweis: Die Aufgabe kann vollständig als R Syntax / R Markdown abgegeben werden oder ein Dokument (Word/ PDF) mit zusätzlicher/eingebetteter R Syntax wird erstellt.

