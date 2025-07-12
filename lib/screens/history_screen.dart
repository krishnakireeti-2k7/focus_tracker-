import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_tracker/providers/session_list_notifier.dart';
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

                  return ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(session.task),
                    subtitle: Text(
                      '${_formatDuration(session.seconds)} • ${_formatDate(session.timestamp)}',
                    ),
                  );
                },
              ),
    );
  }

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(d.inHours);
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return '$h:$m:$s';
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
