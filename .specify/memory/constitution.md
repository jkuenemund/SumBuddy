<!--
SYNC IMPACT REPORT
Version Change: New (Template) -> 1.0.0
Modified Principles: Established initial principles (Kids First, Educational Integrity, Robust Engineering, Visual Excellence, Offline-First).
Added Sections: All.
Templates Requiring Updates: None (Initial instantiation).
Follow-up TODOs: None.
<!--
SYNC IMPACT REPORT
Version Change: 1.4.0 -> 1.5.0
Modified Principles: Added Game-Specific Architecture Guidelines.
Added Sections: 5. Game Architecture & The Bridge.
Templates Requiring Updates: None.
Follow-up TODOs: Implement AssetRegistry.
-->
# Math Pet Constitution

## Core Principles

### I. User-Centric (Kids First)
The user interface MUST be designed for children (ages 6-10).
- **Simplicity**: Minimal text, large touch targets, and intuitive navigation.
- **Engagement**: Use meaningful animations, sound effects, and visual rewards ("juice") to encourage progress.
- **Forgiveness**: The UI must handle erratic touches and never leave the user in a stuck state.

### II. Educational Integrity
The core purpose is educational.
- **Accuracy**: Mathematical content MUST be 100% correct.
- **Progression**: Difficulty curves should be pedagogically sound, adapting to the child's skill.
- **Transparency**: Progress and learning outcomes should be visible to parents.

### III. Robust Engineering
The application MUST be stable and maintainable.
- **Architecture**: Follow Feature-First Clean Analysis with Bloc for state management.
- **Testing**: Business logic (Cubits/Blocs, Repositories) MUST be unit tested.
- **Zero Crashes**: Defensive coding standards to prevent runtime exceptions.
- **Code Standards**:
    - **Formatting**: Run `dart format` before every commit.
    - **Linting**: No unused imports allowed. Strict adherence to `very_good_analysis`.
    - **Logging**: Use structured logging (e.g., `logger`). NEVER use `print()` or `debugPrint()`.


### IV. Visual Excellence
The application MUST be visually appealing.
- **Aesthetics**: Use high-quality assets. **No static colors**; use `Theme.of(context)` for all colors to support Dark/Light modes.
- **Motion**: Transitions and interactions should be smooth (60fps target).
- **Consistency**: Design elements must be consistent across the entire application.

### V. Offline-First
The game MUST be fully functional without an internet connection.
- **Local Storage**: All progress and state MUST be persisted locally.
- **Sync**: Cloud sync (if added) MUST be additive and not block offline gameplay.

### VI. AI & Documentation Optimization
To ensure effective collaboration with AI agents and maintain navigability:
- **Recursive Documentation**: Every significant structural unit (Feature, Module, Complex Widget with sub-folders) MUST have a local `README.md`.
    - This README MUST describe the unit's **Purpose**, **Structure**, and **Responsibilities**.
    - This creates a "Knowledge Tree" allowing AI to understand the system by traversing READMEs without reading every line of code.
- **Visual Context**: READMEs SHOULD include Mermaid diagrams (graph/flowchart) showing file relationships and data flow within that unit.
- **Decomposition**: Large widgets MUST be broken down into sub-widgets in dedicated sub-folders.
- **Explicit Context**: Documentation (spec, plan, local READMEs) MUST be updated *before* code changes to provide accurate context.
- **Small Files**: Code files SHOULD be kept small (< 200 lines) and focused (Single Responsibility).



## Technology Standards
**Stack**: Flutter, Flame, Bloc/Cubit, GoRouter.
**Quality**:
- Strict linting rules (`very_good_analysis`).
- CI/CD ready (tests pass before merge).

## Architecture Guidelines

### 1. Folder Structure (Feature-First)
Code MUST be organized by feature.
```text
lib/features/{feature_name}/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── widgets/              # Sections, Cards, Tiles
│   │   ├── {feature}_tab.dart
│   │   ├── {section}_section/
│   │   └── shared/
│   ├── dialogs/              # Modal Dialogs
│   │   └── {dialog_name}/
│   └── cubit/                 # State Management
│       ├── {feature}_cubit.dart
│       └── {feature}_state.dart
├── {feature_name}.dart        # Barrel File - Public API
└── README.md                  # Feature-Dokumentation
```

### 2. Widget Architecture & Organization
**Size Limits**:
- **Max 200 Lines**: Widgets > 200 lines MUST be split.
- **Target 150 Lines**: Widgets > 150 lines SHOULD be split.

**Recursive Organization**:
Every complex widget gets its own folder containing a README and sub-widgets.
```
{widget_name}/
├── {widget_name}.dart      # Main Widget
├── README.md               # Documentation
└── widgets/                # Sub-widgets
    ├── {sub_widget1}.dart
    └── {sub_widget2}.dart
```

**Widget Categories**:
- **Screen/Tab**: Top-level layout (`{Feature}Tab`). Responsible for composition.
- **Section**: Grouping (`{Name}Section`). Always has its own folder.
- **Tile/Card**: Reusable display components (`{Name}Card`, `{Name}Tile`).
- **Dialog**: Modal UI (`{Name}Dialog`). Always has its own folder.

### 3. Separation of Concerns
| Aspect | ✅ Widgets (UI) | ❌ Functions (Logic) |
|--------|----------------|----------------------|
| **Logic** | Layout, Animation, Form Inputs | Calculations, Validation Rules, Transformations |
| **State** | Reading State (BlocBuilder) | Mutating State (Emit) |
| **API** | Callbacks `onTap: () => cubit.func()` | Direct HTTP/DB Calls |

### 4. State Management (Bloc vs Cubit)
- **Cubit**: The DEFAULT choice for UI state. Use for simple state mutations and direct function calls.
- **Bloc**: Use ONLY when event transformation (debounce, throttle, distinct) or complex event coordination is required.
- **Documentation**: ALL Cubits/Blocs MUST be documented. Public methods MUST have doc comments explaining *what* they do and *when* to use them.

### 5. Game Architecture & The Bridge (Flame + Flutter)
**Flame Component Architecture**:
- **Same Rules Apply**: Game Components (`*Component`) follow the **200-line limit** and **recursive folder structure** just like Widgets.
- **Decomposition**: Complex components (e.g., `PetComponent`) MUST be split into sub-components (e.g., `EatingBehavior`, `MovementComponent`).

**The Bridge (State Trennung)**:
- **Flame** handles: Animation frames, Particle effects, Collision detection, Local input vectors.
- **Cubit** handles: Business Logic (Score, Inventory, Level-Up mechanics), Persistence.
- **Communication**: Components NEVER calc game logic. They dispatch events to the Cubit and react to state changes via `FlameBlocListener`.

**Asset Safety**:
- **AssetRegistry**: ALL assets (images, audio) MUST be referenced via a typed `AssetRegistry` or `Gen` class.
- **No Strings**: Hardcoded asset paths in code (e.g., `'assets/images/pet.png'`) are FORBIDDEN.



## Development Workflow
1. **Spec & Plan**: Use `/speckit` workflows to define and plan features before coding.
2. **Feature Branch**: Create `feat/name` branches.
3. **Implementation**: Follow the plan. Write tests for logic.
4. **Pre-Commit Checklist**:
   - [ ] Unused imports removed?
   - [ ] `dart format` run?
   - [ ] `flutter test` passed?
   - [ ] No `print()` calls remaining?
5. **Merge**: Only squash-merge to main when green.

## Governance
This constitution defines the non-negotiable standards for the "Math Pet" project. Amendments require a version bump and justification.

**Version**: 1.5.0 | **Ratified**: 2026-01-07 | **Last Amended**: 2026-01-07
