# Specification: MVP Features

This document defines the features to be implemented in the first MVP phase.

## Feature 1: The Pet Room (Tamagotchi Core)
**Goal:** Create an interactive "Home" for the digital pet.

### Requirements
1.  **Rendering:** Display the Pet (Cartoon Puppy) in the center of the screen using Flame.
2.  **State:** Track `Hunger` (0-100) and `Happiness` (0-100).
    *   Hunger increases over time (e.g. -1 every minute).
    *   Happiness decreases if Hunger is high (>80).
3.  **Interaction:** Tapping the pet triggers a "Happy" animation.
4.  **UI Overlay:** Show Status Bars for Hunger and Happiness Top-Left.

### Technical Implementation
*   **Path:** `features/pet_room`
*   **Cubit:** `PetStatusCubit` (Holds `PetState` with hunger/happiness).
*   **Repository:** `PetRepository` (Persists state to SharedPreferences).

---

## Feature 2: Math Arcade (Feeding)
**Goal:** The mechanism to feed the pet and restore stats.

### Requirements
1.  **Trigger:** Button "Füttern" in Pet Room opens the Math Arcade overlay/screen.
2.  **Gameplay:**
    *   Show a math problem (`3 + 5 = ?`).
    *   Show a Numpad or 3 Choices.
3.  **Feedback:**
    *   **Correct:** Pet plays "Eating" animation, Hunger -10, Happiness +5.
    *   **Wrong:** "Sad" sound/animation.
4.  **Difficulty:** Static level 1 (Addition up to 10).

### Technical Implementation
*   **Path:** `features/math_arcade`
*   **Cubit:** `MathProblemCubit` (Generates problems, validates input).
*   **Communication:**
    *   `MathArcade` calls `MathProblemCubit`.
    *   On Success, calls `PetRepository.feed()`.

---

## Feature 3: Game Setup & Navigation
**Goal:** Basic App Shell.
1.  **Splash Screen:** Simple logo.
2.  **Home Route:** Direct entry to Pet Room (No Main Menu for MVP).
3.  **Theme:** Apply "Kids Cartoon" styling (AppColors).
