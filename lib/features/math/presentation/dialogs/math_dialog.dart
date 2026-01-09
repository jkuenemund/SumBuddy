import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_cubit.dart';
import 'package:sum_buddy/features/math/domain/entities/math_difficulty.dart';
import 'package:sum_buddy/features/math/domain/entities/math_input_type.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';
import 'package:sum_buddy/features/math/presentation/cubit/math_cubit.dart';
import 'package:sum_buddy/features/math/presentation/cubit/math_state.dart';
import 'package:sum_buddy/features/math/presentation/widgets/numeric_pad_widget.dart';
import 'package:sum_buddy/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:sum_buddy/features/math/domain/logic/difficulty_manager.dart';

/// A Dialog that presents a randomized Math Problem.
/// Returns the difficulty level if solved correctly, null otherwise.
class MathDialog extends StatelessWidget {
  const MathDialog({required this.level, super.key});

  final MathDifficulty level;

  /// Static helper to show the dialog easily.
  /// Returns the difficulty level if solved, or null if cancelled/failed.
  static Future<MathDifficulty?> show(BuildContext context) async {
    final petCubit = context.read<PetCubit>();
    final settingsCubit = context.read<SettingsCubit>();

    // Prepare enabled operations map
    final enabledMap = {
      for (final op in MathOperation.values)
        op: settingsCubit.state.enabledOperations.contains(op),
    };

    final level = DifficultyManager.selectDifficulty(
      enabledOperations: enabledMap,
      proficiencyPoints: petCubit.state.proficiencyPoints,
      frustrationCount: petCubit.state.frustrationCount,
    );

    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider(
        create: (_) => MathCubit()..generateProblem(level),
        child: MathDialog(level: level),
      ),
    );

    if (success ?? false) {
      return level;
    } else {
      // We still want to distinguish between "Wrong Answer" and "Cancel"
      // But for now, returning null means no success.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MathCubit, MathState>(
      listener: (context, state) {
        if (state.status == MathStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == MathStatus.failure) {
          Navigator.of(context).pop(false);
        }
      },
      builder: (context, state) {
        final problem = state.problem;

        return AlertDialog(
          title: const Text('Solve to Feed!'),
          content: problem == null
              ? const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      problem.term,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 20),
                    if (problem.inputType == MathInputType.multipleChoice)
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: problem.choices.map((choice) {
                          return ElevatedButton(
                            onPressed: () =>
                                context.read<MathCubit>().checkAnswer(choice),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                            child: Text(
                              '$choice',
                              style: const TextStyle(fontSize: 24),
                            ),
                          );
                        }).toList(),
                      )
                    else
                      NumericPadWidget(
                        onSubmitted: (value) =>
                            context.read<MathCubit>().checkAnswer(value),
                      ),
                  ],
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
