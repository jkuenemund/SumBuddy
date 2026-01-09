import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_buddy/features/math/domain/config/math_levels_config.dart';
import 'package:sum_buddy/features/math/domain/entities/math_difficulty.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';
import 'package:sum_buddy/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:sum_buddy/features/settings/presentation/bloc/settings_state.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<SettingsCubit>()),
          BlocProvider.value(value: context.read<PetCubit>()),
        ],
        child: const SettingsDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text('Settings'),
            ),
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.settings), text: 'Allgemein'),
                Tab(icon: Icon(Icons.bar_chart), text: 'Fortschritt'),
                Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admin'),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 500,
          child: TabBarView(
            children: [
              _buildGeneralTab(context),
              _buildProgressTab(context),
              _buildAdminTab(context),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Column(
                children: [
                  SwitchListTile(
                    title: const Text('Debug Mode'),
                    subtitle: const Text('Stats für Hunger & Glück anzeigen'),
                    value: state.debugMode,
                    onChanged: (_) =>
                        context.read<SettingsCubit>().toggleDebugMode(),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mathe-Aufgaben aktivieren',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ...MathOperation.values.map((op) {
                    return CheckboxListTile(
                      title: Text(_opLabel(op)),
                      value: state.enabledOperations.contains(op),
                      onChanged: (_) =>
                          context.read<SettingsCubit>().toggleMathOperation(op),
                    );
                  }).toList(),
                ],
              );
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('0.8.0 (Admin Mode)'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab(BuildContext context) {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.psychology, color: Colors.blue),
                title: const Text('Gesamt-Erfahrung'),
                trailing: Text(
                  '${state.totalGlobalPoints} XP',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...MathOperation.values.map((op) => _buildOpProgress(op, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdminTab(BuildContext context) {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _showResetConfirmation(context),
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Alle Fortschritte löschen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Level & Punkte direkt setzen (Testen)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              ...MathLevelsConfig.levels.map((level) {
                final points = state.proficiencyPoints[level.id] ?? 0;
                return ListTile(
                  key: ValueKey('admin_${level.id}'),
                  title: Text(level.id),
                  subtitle: Text(level.label),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () =>
                            context.read<PetCubit>().setProficiencyPoints(
                              level.id,
                              (points - 1).clamp(0, 100),
                            ),
                      ),
                      Text(
                        '$points',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () =>
                            context.read<PetCubit>().setProficiencyPoints(
                              level.id,
                              (points + 1).clamp(0, 100),
                            ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOpProgress(MathOperation op, PetState state) {
    final opLevels = MathLevelsConfig.levels
        .where((l) => l.operation == op)
        .toList();
    if (opLevels.isEmpty) return const SizedBox.shrink();

    MathDifficulty currentLevel = opLevels.first;
    for (final level in opLevels) {
      final points = state.proficiencyPoints[level.id] ?? 0;
      if (points < level.pointsToNextLevel) {
        currentLevel = level;
        break;
      }
      currentLevel = level;
    }

    final points = state.proficiencyPoints[currentLevel.id] ?? 0;
    final progress = points / currentLevel.pointsToNextLevel;
    final streak = state.activeStreaks[currentLevel.id] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _opLabel(op).split(' (').first,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'LVL ${opLevels.indexOf(currentLevel) + 1}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                currentLevel.label,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const Spacer(),
              if (streak > 0)
                Text(
                  '🔥 $streak/${currentLevel.streakTarget}',
                  style: const TextStyle(fontSize: 10, color: Colors.orange),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (innerContext) => AlertDialog(
        title: const Text('Fortschritt zurücksetzen?'),
        content: const Text(
          'Bist du sicher? Alle gesammelten Punkte, Level und Möbel werden gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(innerContext).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PetCubit>().resetProgress();
              Navigator.of(innerContext).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Ja, alles löschen',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _opLabel(MathOperation op) {
    switch (op) {
      case MathOperation.addition:
        return 'Addition (+)';
      case MathOperation.subtraction:
        return 'Subtraktion (-)';
      case MathOperation.multiplication:
        return 'Multiplikation (×)';
      case MathOperation.division:
        return 'Division (÷)';
    }
  }
}
