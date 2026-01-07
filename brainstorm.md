# Brainstorming: Mathe-Tamagotchi (Arbeitstitel)

## 1. Übersicht
*   **Zielgruppe:** Grundschüler (ca. 6-10 Jahre)
*   **Plattform:** iPad (iOS)
*   **Technologie:** Flutter
*   **Game Engine:** **Flame** (Entscheidung getroffen)
*   **Sprache:** Dart

## 2. Spielkonzept: "Das Mathe-Haustier"
Das Grundprinzip verbindet die Pflege eines virtuellen Charakters (Tamagotchi-Prinzip) mit dem Üben von Mathematik. Das Rechnen soll nicht "Strafe" sein, sondern Mittel zum Zweck (Belohnung).

### Core Loop (Spielschleife)
1.  **Bedürfnis:** Das Haustier hat Wünsche (Hunger, Langeweile, Müdigkeit, Dreckig).
2.  **Aktion:** Der Spieler möchte dem Tier etwas Gutes tun (Essen geben, Ball spielen).
3.  **Herausforderung (Mathe):** Um das Item zu bekommen oder die Aktion auszuführen, muss eine Mathe-Aufgabe gelöst werden.
    *   *Variante A (Shop):* Man löst Aufgabenblöcke, verdient "Sterne/Münzen" und kauft davon im Shop Essen/Spielzeug.
    *   *Variante B (Direkt):* Das Tier will einen Apfel. Um den Apfel zu pflücken, muss man das Ergebnis von `3 + 4` antippen.
4.  **Belohnung:** Das Tier freut sich, wächst, entwickelt sich weiter oder verändert sein Aussehen. Das Zimmer kann dekoriert werden.

### Spiel-Elemente
*   **Der Avatar:** Ein niedliches Monster, Tier oder Roboter. Es sollte auf Berührung reagieren (Animationen).
*   **Das Zimmer:** Der Hauptscreen. Hier lebt das Tier.
*   **Der Lern-Bereich (Arcade):**
    *   Hier werden die Punkte verdient.
    *   Möglichkeit, spezifische Rechenarten zu trainieren (nur Mal-Rechnen, nur Plus bis 100).
*   **Progression:**
    *   Level-System für das Tier.
    *   Freischaltbare Deko-Gegenstände (Hüte, Brillen, Wandfarbe).

## 3. Technische Anforderungen (Flame)
*   **Sprites & Animationen:** Wir brauchen Spritesheets für das Tier (Idle, Eating, Happy, Sad).
*   **Game Loop:** Flame handelt den Loop.
*   **State Management:** Da wir UI (Flutter Widgets) und Game (Flame) mischen, brauchen wir ein State Management (z.B. `Bloc` oder `Riverpod`), um den Punktestand und Pet-Status zwischen den Welten zu synchronisieren.
*   **Persistenz:** Spielstand (Level, Münzen, Hunger-Status) muss lokal gespeichert werden (z.B. `shared_preferences` oder `hive`).

## 4. Lerninhalte (Rules)
*   **Grundrechenarten:** (+, -, •, :)
*   **Schwierigkeitsgrade:**
    *   Level 1: Zahlenraum bis 10 (Addition/Subtraktion).
    *   Level 2: Zahlenraum bis 20 (mit Zehnerübergang).
    *   Level 3: Kleines Einmaleins.
    *   Level 4: Zahlenraum bis 100.

## 5. Nächste Schritte
*   [x] Spielidee festlegen (Tamagotchi-Style)
*   [x] Engine auswählen (Flame)
*   [ ] **Projekt aufsetzen:** `flutter create`
*   [ ] **Dependencies hinzufügen:** `flame`, `equatable`, `flutter_bloc` (oder provider/riverpod), `shared_preferences`.
*   [ ] **Asset-Suche:** Wir brauchen vorläufige Grafiken (Monster, Essen, Hintergrund).
*   [ ] **Prototyp:** Einen Screen bauen, wo ein Sprite sichtbar ist und reine UI-Buttons zum Interagieren.
