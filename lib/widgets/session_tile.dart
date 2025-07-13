import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/models/focus_session.dart';

class SessionTile extends StatelessWidget {
  final FocusSession session;
  final VoidCallback onDelete;

  const SessionTile({super.key, required this.session, required this.onDelete});

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.check_circle_outline),
        title: Text(
          session.task,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${_formatDuration(session.seconds)} • ${_formatDate(session.timestamp)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
