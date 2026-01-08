# Math Feature

## Purpose
This feature handles the educational logic of the game. It generates math problems, validates answers, and provides the UI for the player to solve them.

## Structure
- `domain/`: Contains the core logic.
    - `entities/`: `MathProblem` model.
    - `logic/`: `MathGenerator` service.
- `presentation/`: Contains the UI.
    - `dialogs/`: The `MathDialog` modal.
    - `cubit/`: The `MathCubit` managing the dialog state.

## Responsibilities
- **Generator**: Creates randomized problems based on difficulty (currently Addition <= 20).
- **Dialog**: Displays the problem and choices/numpad.
- **Cubit**: Validates the input and reports Success/Failure.
