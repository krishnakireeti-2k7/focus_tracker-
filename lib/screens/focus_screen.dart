import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_tracker/providers/session_list_notifier.dart';
import 'package:focus_tracker/providers/time_provider.dart';
import 'package:focus_tracker/screens/history_screen.dart';
import '../models/focus_session.dart';

class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  final TextEditingController _taskController = TextEditingController();
  bool _isFocusing = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(sessionListProvider.notifier).loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = ref.watch(focusTimerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Timer'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'What are you focusing on?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: 'e.g. Study Math',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _formatDuration(elapsed),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final timer = ref.read(focusTimerProvider.notifier);
                final elapsed = ref.read(focusTimerProvider);
                final taskName = _taskController.text.trim();

                if (!_isFocusing) {
                  if (taskName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter task name")),
                    );
                    return;
                  }

                  setState(() => _isFocusing = true);
                  timer.start();
                } else {
                  timer.stop();

                  final session = FocusSession(
                    task: taskName,
                    seconds: elapsed.inSeconds,
                    timestamp: DateTime.now(), // ✅ fixed
                  );

                  print(
                    "🔄 Saving session: ${session.task}, ${session.seconds}s",
                  );

                  await ref
                      .read(sessionListProvider.notifier)
                      .addSession(session);
                  ref.read(focusTimerProvider.notifier).reset();
                  _taskController.clear();

                  setState(() => _isFocusing = false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Focus session saved")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              child: Text(
                _isFocusing ? 'Stop & Save' : 'Start Focusing',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(d.inHours);
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return '$h:$m:$s';
  }
}
