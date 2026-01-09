import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_buddy/features/game/presentation/bloc/interaction_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/interaction_state.dart';

class PetActionBar extends StatelessWidget {
  const PetActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(120), // Darker for better contrast
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withAlpha(40),
            ),
          ),
          child: BlocBuilder<InteractionCubit, InteractionState>(
            builder: (context, state) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ToolButton(
                    icon: Icons.cookie,
                    label: 'Füttern',
                    tool: GameTool.feed,
                    isSelected: state.selectedTool == GameTool.feed,
                  ),
                  const SizedBox(width: 15),
                  _ToolButton(
                    icon: Icons.videogame_asset,
                    label: 'Spielen',
                    tool: GameTool.play,
                    isSelected: state.selectedTool == GameTool.play,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.tool,
    required this.isSelected,
  });

  final IconData icon;
  final String label;
  final GameTool tool;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<InteractionCubit>().selectTool(tool),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withAlpha(100) : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withAlpha(100),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isSelected ? 36 : 28,
              color: isSelected
                  ? (tool == GameTool.feed
                        ? Colors.orangeAccent
                        : Colors.lightBlueAccent)
                  : Colors.white70,
              shadows: isSelected
                  ? [
                      const Shadow(
                        color: Colors.white54,
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
