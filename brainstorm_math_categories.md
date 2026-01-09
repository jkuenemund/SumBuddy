# Brainstorming: Modulares Mathe-Kategoriesystem

Aktuell ist das System linear über alle Grundrechenarten gestreckt. Die Idee ist nun, die Schwierigkeit **pro Rechenart** zu trennen und zusätzliche Dimensionen wie **negative Zahlen** einzuführen.

## 1. Das "Skill-Tree" Konzept
Anstatt eines linearen Fortschritts hat jede Rechenart ihre eigene "Säule".

### Addition (Säule A)
*   **Lvl 1**: 1-10 (Summe bis 20)
*   **Lvl 2**: 1-20 (Summe bis 40)
*   **Lvl 3**: Zehnerübergang (z.B. 8+7, 15+6)
*   **Lvl 4**: Große Zahlen bis 100
*   **Lvl 5**: Negative Zahlen (Einstieg: z.B. 5 + (-3))
*   **Lvl 6**: Komplexe Negative (z.B. -10 + (-5))

### Subtraktion (Säule S)
*   **Lvl 1**: 1-10 (Kein Zehnerübergang, positives Ergebnis)
*   **Lvl 2**: 1-20 (Zehnerübergang, z.B. 12-5)
*   **Lvl 3**: Ergebnisse bis 100
*   **Lvl 4**: Negative Ergebnisse (Einstieg: 3 - 5 = -2)
*   **Lvl 5**: Subtraktion negativer Zahlen (z.B. 5 - (-2))
*   **Lvl 6**: Komplexe Kombinationen (z.B. -5 - (-8))

### Multiplikation (Säule M)
*   **Lvl 1**: Kleines 1x1 (2er, 5er, 10er Reihe)
*   **Lvl 2**: Kleines 1x1 (alle Reihen bis 10)
*   **Lvl 3**: Zehnerzahlen (z.B. 3 * 20, 5 * 40)
*   **Lvl 4**: Großes 1x1 (bis 20 * 20)
*   **Lvl 5**: Negative Faktoren (z.B. 3 * -4)
*   **Lvl 6**: Beide Faktoren negativ (-3 * -4)

### Division (Säule D)
*   **Lvl 1**: Umkehrung 2er, 5er, 10er Reihe
*   **Lvl 2**: Ganzes kleines 1x1 (Restlos)
*   **Lvl 3**: Zehnerzahlen (z.B. 80 / 4)
*   **Lvl 4**: Großes 1x1 (bis 200 / 10)
*   **Lvl 5**: Negative Divisoren (z.B. 12 / -3)
*   **Lvl 6**: Komplexe Vorzeichenregeln (-12 / -4)

---

## 2. Globaler Fortschritt vs. Spezialisierung
Wie ziehen wir die Aufgaben?

### Option A: Unabhängige Slot-Gewichtung
*   Der Spieler wählt in den Settings, welche Rechenarten er trainieren will.
*   Das System zieht aus den aktivierten Säulen. Innerhalb der Säule bestimmt das "Erfahrungslevel" dieser Säule die Komplexität (80% aktuelles Level, 20% Wiederholung).

### Option B: "Mastery Score"
*   Es gibt einen globalen Level, der sich aus der Summe aller Mastery Scores berechnet.
*   Neue Rechenarten werden erst freigeschaltet, wenn Addition/Subtraktion einen Basis-Mastery-Wert erreicht haben.

---

## 3. Die Rolle der Negativen Zahlen
Negative Zahlen sind ein "Modifier", kein reiner Zufall.

*   **Vorschlag**: Sobald ein Spieler in einer Säule (z.B. Addition) Level 5 erreicht, wird der "Negative Switch" für diese Säule umgelegt.
*   Man könnte in den Settings einen globalen Schalter "Negative Zahlen einbeziehen" anbieten, der erst erscheint, wenn man genug Punkte hat.

---

## 5. Level-Übergänge und Dynamik
Wie kommen wir von Lvl 1 zu Lvl 2, ohne dass es sich "hart" anfühlt?

### Der "Flow"-Einstieg (Soft Transition)
Statt eines harten Cut-offs nutzen wir eine gleitende Wahrscheinlichkeit:
*   **Annäherung (80-100% Fortschritt)**: Das nächste Level wird mit ca. 10% eingestreut.
*   **Level Up**: Das neue Level wird primär (z.B. 60-70%), das direkt vorherige bleibt präsent (20-30%), und ganz einfache Level sinken auf ein Minimum (5%), um nicht nur noch "Pille-Palle" Aufgaben zu haben, wenn man eigentlich bei negativen Zahlen ist.

### Der "Eingabe-Modus" Modifier
Ein neues Level oder ein globaler Modifier: **Direkteingabe statt Multiple Choice**.
*   **Stufe 1**: 3 Antwortmöglichkeiten (Multiple Choice).
*   **Stufe 2**: 5 Antwortmöglichkeiten (erhöhter Schwierigkeitsgrad).
*   **Stufe 3**: Zahlenpad-Eingabe (keine Rategallerie mehr).
*   *Vorteil*: Dies verdoppelt die Spieltiefe, da man bekannte Aufgaben in einem schwereren Modus lösen muss.

### Fehler-Regulierung (Anti-Frust)
*   **Down-Scaling**: Bei 3 Fehlern in Folge wird die Gewichtung temporär um ein Level nach unten verschoben, bis wieder 2 Aufgaben korrekt gelöst wurden.

---

## 6. Technische Entkopplung (Architektur)
Um das System wartbar zu halten, trennen wir die Verantwortlichkeiten klar:

1.  **DifficultyManager (Der Entscheider)**:
    *   Kennt den Punktestand und das aktuelle Level pro Säule.
    *   Berechnet die Wahrscheinlichkeiten und die aktuelle Anti-Frust-Phase.
    *   *Output*: Ein `DifficultySettings`-Objekt (z.B. `{ op: addition, max: 50, input: numericPad }`).
2.  **MathGenerator (Die Fabrik)**:
    *   Ist völlig zustandslos.
    *   Bekommt ein `DifficultySettings`-Objekt und spuckt ein `MathProblem` aus.
    *   Weiß nicht, warum er gerade diese Aufgabe generiert.
3.  **MathProblem (Das Produkt)**:
    *   Enthält den Term, die Lösung und den **Input-Typ** (Multiple Choice oder Text).

---

---

## 7. Proficiency Points via Streaks
Statt eine lange Serie am Stück zu fordern, unterteilen wir den Fortschritt in "Proficiency Points" (Kompetenz-Punkte).

### Das Prinzip
1.  **Die Mini-Serie**: 3 richtige Antworten in Folge (Streak) ergeben **1 Proficiency Point** für das aktuelle Level.
2.  **Reset**: Nach 3 richtigen Antworten wird der interne Seriencounter für dieses Level auf 0 gesetzt. Man muss also die nächste 3er-Serie starten.
3.  **Fehler**: Ein Fehler setzt den Seriencounter sofort auf 0 (man verliert aber keine bereits verdienten Proficiency Points).
4.  **Level-Up Schwellenwert**: Jedes Level definiert, wie viele Proficiency Points benötigt werden (z.B. 5 Punkte = 15 richtige Antworten in 3er Paketen), um zum nächsten Level aufzusteigen.

### Warum das besser ist:
*   **Fehlertoleranz**: Ein einzelner Fehler nach 9 richtigen Antworten macht nicht alles kaputt, sondern nur die aktuelle 3er-Serie. Die bereits verdienten 3 Punkte bleiben erhalten.
*   **Granularität**: Wir können pro Level genau sagen: "Für Addition bis 10 brauchst du 3 Punkte, für die schweren Multiplikationen aber 10 Punkte."

---

## 8. Zentrale Konfiguration (`MathConfigs`)
Alle magischen Zahlen (Transition-Weights, Streak-Längen, Point-Thresholds) lagern wir in eine Konfigurationsdatei aus.

**Vorteil**: Wir können die Spielbalance anpassen (z.B. "Level-Ups gehen zu schnell"), ohne in die Logik einzugreifen.

---

**Sollten wir die "Proficiency Points" in den Settings für das Kind sichtbar machen (z.B. als 5 kleine Sterne pro Level), oder soll das eher im Hintergrund laufen?**
