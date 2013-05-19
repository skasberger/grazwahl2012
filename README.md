Grazwahl 2012
=========================

Datenanalyse und Visualisierung der Grazer Gemeinderatswahlen 2012.

## BESCHREIBUNG
Die Analyse soll einem einen kleinen Einblick in das Ergebnis der Grazer Gemeinderatswahlen 2012 geben. Im Zuge des Arbeiten mit Datensätzen zu Wahlen soll den spezifischen Fragestellungen nachgegangen und diese visual dargestellt werden.

Dies ist in erster Linie das Visualisieren des Ergebnisses auf einer Karte der Stadt Graz sowie Erzeugen unterschiedlicher Säulendiagramme zu den einzelnen Bezirken.

Weiters soll auch eine Analyse von Graz spezifischen Fragestellungen in Verbindung sozio-ökonomischen Daten (sofern vorhanden) gemacht und nach räumlichen Mustern gesucht werden.

**[Open Science Projektseite](http://openscience.alpine-geckos.at/projects/grazwahlen-2012/)**

## INSTALL
Sämtliche R Scripts müssen aus dem root-Ordner ausgeführt werden.

Sämtliche Inhalte können durch das Ausführen der Datei ``./code/shell/build.sh`` neu generiert werden. 
 
```shell
sh ./code/shell/build.sh
```

## DOKUMENTATION
Big 6 werden hier wie folgt die 6 Parteien die es in den Gemeinderat geschafft haben genannt.

[Ergebnisse](http://www.graz.at/cms/ziel/4787925/DE/)

### Grundlegendes
besondere Stimmen:
- 816: vorgezogenen Wahltag am 16. November 2012; Seniorenpflegeheim mit um die 80 Stimmabgaben am Tag der Wahl
- 2798: Briefwahlstimmen 
- 2799: am Wahltag in Wahlkartenwahllokalen oder vor einer besonderen Wahlbehörde verwendeten Wahlkarten (z.B. Hausbesuche)

Die Vorwahlen sind unter dem Sprengel 816 eingetragen. [1]

Inkonsistenz in Daten: es waren anscheinend um die 8000 vorgezogene Wahlen

#### Farben
- PARTEI	RGB-FARBCODE	
- KPÖ 		#cc3333		204  51  51
- FPÖ 		#0e428e		 14  66 142
- SPÖ 		#ce000c		206   0  12
- Grüne 	#87b52a		135 181  42
- Piraten 	#4c2582		 76  37 130
- BZÖ 		#ee7f00		238 127   0

### Quellcode
#### Wörterbuch 
- Sprengel = parish
- Bezirk = district
- berechtigte WählerInnen = authorized voters
- Wahlbeteiligung = voters participation

### Daten
#### Rohdaten
Die Rohdaten stammen vom [OGD Portal der Stadt Graz](http://data.graz.gv.at/).
- GRW2012_Sprengelbezerg.csv
- GRW2012_Sprengelerg.csv
- [GRW2012_Wahlberechtigte.csv](http://data.graz.gv.at/daten/package/wahlberechtigte-personen-gemeinderatswahl-2012)

#### Prozessierte Daten
Folgende Datensets wurden aus den Rohdaten erzeugt:

Nähere Infos zur Datenstruktur sind in ``./doc/grazwahl2012.org`` nachzulesen.

### Diagramme
Folgende Diagrammtypen wurden aus unterschiedlichen Datensätzen erzeugt und sind im Ordner ``./images`` zu finden.
- Säulendiagramme
- Choroplethendiagramme
- Boxplots
- Histogramme
- Dichtefunktionen

### Ordnerstruktur
- data
	- raw
		- shape
		- csv
		- twitter
	- json
	- rstat
	- shape
- doc
	- licenses: Lizenztexte
	- pres: Presentationen des Projekts
- images

### Qualitätssicherung
- Parteien sind nach dem Listenplatz in allen Datensätzen geordnet

## ToDo
## CHANGELOG
### Version 1.0
- Aufbereitung der Daten für weitere Analysen
- Berechnen des Korrelationskoeffizienten (Pearson)
- Erstellen der Dokumentation
- Shell Scripts 
	- ``get_twitter_data.sh``: Download der Twitterdaten
	- ``create_tarball.sh``: Erstellen eines Tar-Balls mit allen Bildern
	- ``build.sh``: Ausführen aller Scripts und neu generieren des gesamten Contents
- R Scripts
	- ``prepData.R``: Daten aufbereiten
	- ``functions.R``: Funktionen
	- ``visualize.R``: Erzeugen der Diagramme
	- ``spatial.R``: Daten vorbereiten für Choroplethen Diagramme
- Präsentation bei [3. offenen Grazer OGD Stammtisch](http://data.graz.gv.at/aktuelles/openness-fuer-die-grazer-stadtverwaltung-dritter-offener-open-government-data-stammtisch)

## QUELLEN
[1]: http://www.graz.at/cms/beitrag/10203278/4829113/
