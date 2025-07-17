import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_tracker/providers/session_list_notifier.dart';
import 'package:focus_tracker/widgets/FloatingSnackBar';
import 'package:focus_tracker/widgets/session_tile.dart';
import '../models/focus_session.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final sessions = ref.watch(sessionListProvider);
    final groupedSessions = groupSessionsByDay(sessions);

    return Scaffold(
      appBar: AppBar(title: const Text('Focus History')),
      body:
          groupedSessions.isEmpty
              ? const Center(child: Text('No sessions yet'))
              : ListView(
                children:
                    groupedSessions.entries.map((entry) {
                      final date = entry.key;
                      final sessionsForDate = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                            child: Text(
                              _formatDateHeader(date),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...sessionsForDate.map((session) {
                            final globalIndex = sessions.indexOf(
                              session,
                            ); // important

                            return SessionTile(
                              session: session,
                              onDelete: () {
                                final deletedSession = session;
                                final deletedIndex = globalIndex;

                                ref
                                    .read(sessionListProvider.notifier)
                                    .deleteSession(deletedIndex);

                                FloatingSnackBar.show(
                                  context,
                                  message: "Session deleted",
                                  actionLabel: "Undo",
                                  onAction: () {
                                    ref
                                        .read(sessionListProvider.notifier)
                                        .addSession(
                                          deletedSession,
                                          atIndex: deletedIndex,
                                        );
                                  },
                                );
                              },
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
              ),
    );
  }
}

Map<DateTime, List<FocusSession>> groupSessionsByDay(
  List<FocusSession> sessions,
) {
  Map<DateTime, List<FocusSession>> grouped = {};

  for (final session in sessions) {
    final date = DateTime(
      session.timestamp.year,
      session.timestamp.month,
      session.timestamp.day,
    );
    grouped.putIfAbsent(date, () => []).add(session);
  }
  for (final list in grouped.values) {
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
  final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
  return {for (var key in sortedKeys) key: grouped[key]!};
}
