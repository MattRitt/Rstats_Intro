# Script Kurs "Quantitative Untersuchungen I"
# Einfuehrung in R
# Matthias Ritter

################################################################################

# Inhalt
# 1 Quellen
# 2 Arbeitsweise in Rstudio
# 3 R als Skriptsprache
# 4 Objekttypen   



# 1 Quellen

# Download:
# http://cran.r-project.org
# Manual
# http://cran.r-project.org/doc/manuals/R-intro.html
# Entwicklungsumgebung
# http://rstudio.org/

# Vielzahl an B?chern/ Tutorials im Netz
# Luhmann, M. (2010): R fuer Einsteiger
# Skript von Mathias Kuhnt

#########################################################################################################

## 2 Arbeit mit RStudio: ##
###########################

# verschiedene Fenster
# einen Befehl in die Konsole senden: STRG+Enter 
# in der Konsole kann mit den Pfeiltasten die letzten Befehle aufgerufen werden
# wenn der Hintergrund ge?ndert werden soll, nutzt unter Tools > Global Options > Appearance eine der Varianten 
# die Programmierzeilen sind in diesem Skript recht lang, diese k?nnen automatisch angepasst werden, indem ihr in Rstudio unter: # Tools > Global Options > Code > Soft-wrap R source files   markiert
# immer wenn eine Fehlermeldung kommt, kann die Hilfe mit dem Befehl ?Befehl aufgerufen werden.

## 3 R als Skriptsprache    ##
############################

# erster Befehl:

1

# den Kursor auf die Zeile mit "1" platzieren und dann oben "Run" klicken oder STRG+Enter dr?cken, so dass Befehle gestartet und in R prozessiert werden, in diesem Fall hatte R nicht viel zu tun, er reproduziert die 1.

# die kleinsten Einheiten in R sind Objekte und Funktionen, wir werden verschiedene Objekte erstellen
# Zun?chst zu Funktionen: Funktionen werden jeweils mit Ihrem Namen hervorgerufen, gefolgt von einer offenen und geschlossenen Klammer.

getwd()

# bei der Funktion getwd wird im Output das aktuelle Arbeitsverezeichnis angezeigt.
# Alle Dateien werden darin abgespeichert bzw. wird in Befehlen darauf zugegriffen.

# Das Verzeichnis kann ge?ndert werden, indem ihr die Funktion setwd nutzt. Das Verzeichnis muss angepasst werden ansonsten kommt bei euch (sehr wahrscheinlich) eine Fehlermeldung. 

setwd("M:/Lehre/_wbf_Seminar/R/")

# deutlich wird aber, dass Funktionen die Argumente in den Klammern verwenden, so dass klar ist, wie die Funktion ausgef?hrt wird. Hier also wo das neue Arbeitsverzeichnis ("working directory") liegt.

# Achtung Verzeichnisse werden in R mit  "/" anstelle von "\" (wie es in Windows ?blich ist) beschrieben. 

# weitere Grundlegende Aspekte der R Skriptsprache:

# R ist case sensitive. Also aufpassen, bei der Gro?- und Kleinschreibung. Auch bei Symbolen bzw. Sonderzeichen sollte aufgepasst werden. Empfehlung ist, keine Sonderzeichen zu nutzen, also bspw. keine Umlaute (? ? ?).

# R nutzt im Kontext von Zahlen (auch unabh?ngig von der gesetzten Sprache) den Dezimalpunkt anstelle des Kommas, also 1.23 (anstelle von 1,23)

# Kommas werden genutzt, um verschiedene Argumente innerhalb von Funktionen zu separieren. Das werden wir sp?ter sehen.

# Die Syntax ist - wie erw?hnt - sehr sensibel bei Fehlern, bspw. gibt es unterschiedliche Arten von Klammern: () != {} != []

# Keine Probleme gibt es bei der Nutzung von Leerzeichen. Da k?nnen mehr oder weniger stehen, das ist R egal. (ausser in Funktionsnamen)

getwd()

getwd( )

getwd ( )
# gleicher Befehl

# wie du gemerkt hast, wird "#" f?r Kommentare genutzt, diese Textzeilen werden beim Ausf?hren von Befehlen ignoriert.#

## R: erste Schritte mit R ##
#######################

# R kann als Taschenrechner genutzt werden.

3+2
3.5+2

# Die L?sung findet sich jeweils im Output unten.

# Wie erw?hnt arbeitet R mit Objekten und Funktionen. In Objekten k?nnen verschiedene Daten gespeichert und auch verschachtelt werden. Das funktioniert ?ber die Angabe "<-". Ein Beispiel: 

obj1 <- 1.2
obj1

# Wenn der "Pfeil" so genutzt wird, passieren zwei Dinge: das Objekt wird erstellt (obj1) und der Wert (1.3) wird gespeichert. Genauso wie mit "obj2".
obj2 <- 3.5

# Die gespeicherten Werte k?nnen wieder aufgerufen werden. 

obj1
obj2

# Eine weitere Funktion ist ls(), damit werden alle Objekte ausgegeben, die in der Session erstellt wurden. In RStudio sind die Objekte aber auch im Fenster oben rechts zu sehen.

ls()

# Es k?nnen alle m?gliche Namen f?r Objekte genutzt werden. Es sollten jedoch Funktionsnamen vermieden werden.

# Objekte mit Zahlenwerten k?nnen auch in Form einer Berechnung genutzt werden:

obj1 + obj2

# Oft ist es sinnvoll den berechneten Wert auch als Objekt zu speichern. bspw als "obj3".

obj3 <- obj1 + obj2

# Alle Operationen k?nnen also verschachtelt werden. In der vorherigen Kommandozeile wurden wieder zwei Sachen gemacht, die Summe berechnet und einem Objekt ("obj3") ?bergeben.

# Das Objekt kann wieder aufgerufen werden:

obj3 

# weitere Berechnungen sind wieder m?glich: 

obj3^2

sqrt(obj3)

#########################################################################################################

# ?bung: Erstelle drei Objekte "x", "y" and "z". Jedes Objekt soll einen unterschiedlichen Wert erhalten. Berechne dann (x+y)/z. Das erstellte Objekt soll dann als "v" bezeichnet werden. 

#########################################################################################################

x <- 2
y <- 3
z <- 4
v <- (x+y)/z


# 4 Objekttypen

################################################################

# es gibt in R verschiedene Objekttypen, die wichtigsten f?r uns sind 
#   Vektoren, 
#   Faktoren und 
#   Data frames (bzw. auch tibbles)

# Vektoren / combine-Befehl
# Vektoren in R sind eine Menge von Elementen (in SPSS/Excel entsprechen sie den Werten einzelner Personen, die in einer Spalte untereinander stehen). Vektoren k?nnen Zahlen und Buchstaben enthalten. Wenn nur Zahlen vorkommen, ist es ein  numerischer Vektor  (in R numeric). Sobald Buchstaben vorkommen ist es automatisch ein Text-Vektor (in R character). Mit dem combine Befehl wird ein Vektor erzeugt:

alter <- c(19,23,23,34,21,18,28,25)
alter

#Wenn wir die L?nge des Vektors wissen wollen:
length(alter)

#Faktoren

#In R werden Variablen mit Ordinalskalenniveau oder h?hren Skalenniveaus als Vektoren angelegt. Variablen mit Nominalskalenniveau werden dagegen als Faktoren gespeichert. Die Unterscheidung zwischen Faktoren und Vektoren hat wichtige Konsequenzen. Viele Analysen k?nnen nur durchgef?hrt werden, wenn die Variablen den richtigen Objekttyp haben. 
#Im folgenden Beispiel legen wir die nominalskalierte Variable Geschlecht an. Zun?chst wird ein Vektor definiert, welcher den Namen geschl bekommt.

geschl <- c(1,2,2,1,2,3,1,2)

# die Umwandlung dieses Vektors in einen Faktor funktioniert ?ber factor(x) 
geschl

geschl.faktor <- factor(geschl) 
geschl.faktor

#wird der Inhalt des Objekts aufgerufen, werden neben der Auflistung der Elemente auch die Faktorstufen angezeigt.

#mit folgendem Befehl kann auch ein Wertelabel hinzugef?gt werden.

geschl.faktor <- factor(geschl, labels = c("weiblich", "maennlich", "divers"))

# Data frames
#Vektoren und Faktoren kann man sich als einzelne Variablen vorstellen. Wenn man alle diese Variablen zu einem Objekt kombiniert, erh?lt man einen data frame. Ein data frame besteht aus mehreren Zeilen und Spalten (sh. SPSS und Excel), Zeile meist Person, Spalte Variablen. Data frame ist eine Menge von Faktoren und Vektoren, die alle dieselbe Anzahl von Elementen haben (in R: L?nge).

beispiel.df <- data.frame(alter, geschl.faktor)
beispiel.df

#?berpr?fung des Variablentyps mittels class() Befehl.

class(alter)
class(geschl.faktor)
class(beispiel.df)

#oder mit str() kann auch die Struktur des Objekts ?berpr?ft werden

str(alter)
str(geschl.faktor)
str(beispiel.df)

# mit dem Befehl names() weren die Elemente des data frames angezeigt
?names
help(names)

names(beispiel.df)

