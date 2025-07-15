import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_tracker/providers/session_list_notifier.dart';
import 'package:focus_tracker/widgets/session_tile.dart';
import '../models/focus_session.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Focus History')),
      body:
          sessions.isEmpty
              ? const Center(child: Text('No focus sessions yet.'))
              : ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final FocusSession session = sessions[index];

                  return SessionTile(
                    session: session,
                    onDelete: () {
                      ref
                          .read(sessionListProvider.notifier)
                          .deleteSession(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Session deleted")),
                      );
                    },
                  );
                },
              ),
    );
  }
}


Map<String, List<FocusSession>> _groupSessionsByDate(
  List<FocusSession> sessions,
) {
  Map<String, List<FocusSession>> grouped = {};

  for (var session in sessions) {
    final dateKey =
        "${session.timestamp.day}/${session.timestamp.month}/${session.timestamp.year}";
    grouped.putIfAbsent(dateKey, () => []).add(session);
  }

  // Sort by most recent day first
  final sortedKeys =
      grouped.keys.toList()..sort((a, b) {
        final da = DateTime.parse(a.split('/').reversed.join('-'));
        final db = DateTime.parse(b.split('/').reversed.join('-'));
        return db.compareTo(da); // descending
      });

  // Rebuild sorted map
  return {for (var k in sortedKeys) k: grouped[k]!};
}
