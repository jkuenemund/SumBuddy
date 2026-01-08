import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_pet/features/math/presentation/cubit/math_cubit.dart';
import 'package:math_pet/features/math/presentation/cubit/math_state.dart';

/// A Dialog that presents a randomized Math Problem.
/// Returns `true` if solved correctly, `false` otherwise.
class MathDialog extends StatelessWidget {
  const MathDialog({super.key});

  /// Static helper to show the dialog easily.
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Force interaction
      builder: (_) => BlocProvider(
        create: (_) => MathCubit()..generateProblem(),
        child: const MathDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MathCubit, MathState>(
      listener: (context, state) {
        if (state.status == MathStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == MathStatus.failure) {
          // Visual feedback could go here (SnackBar, Shake).
          // For MVP, we just close with 'false' or let them try again?
          // Let's close for now to be strict.
          Navigator.of(context).pop(false);
        }
      },
      builder: (context, state) {
        final problem = state.problem;

        return AlertDialog(
          title: const Text('Solve to Feed!'),
          content: problem == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      problem.term,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 20),
                    // Only supporting Multiple Choice for now
                    Wrap(
                      spacing: 16,
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
                    ),
                  ],
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
