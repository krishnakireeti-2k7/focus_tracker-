import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_tracker/providers/session_list_notifier.dart';
import 'package:focus_tracker/providers/time_provider.dart';
import 'package:focus_tracker/widgets/FloatingSnackBar.dart' as FloatingSnackBar;
import '../models/focus_session.dart';
import '../providers/theme_provider.dart';

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
  void dispose() {
    _taskController.dispose(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final elapsed = ref.watch(focusTimerProvider);

    return Scaffold(
      appBar: AppBar(
    title: const Text('Focus Tracker'),
    centerTitle: true,
  ),
      drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: const Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Focus History'),
          onTap: () {
            Navigator.pop(context); // close drawer
            Navigator.pushNamed(context, '/history');
          },
        ),
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('Toggle Theme'),
          onTap: () {
            Navigator.pop(context); // close drawer
            ref.read(themeModeProvider.notifier).toggleTheme();
          },
        ),
        // You can add more items later like "Settings", "About", etc.
      ],
    ),
  ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Text(
              'What are you focusing on?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: 'e.g. Study Math',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                _formatDuration(elapsed),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              key: UniqueKey(), 
              onPressed: () {
                final timer = ref.read(focusTimerProvider.notifier);
                final elapsed = ref.read(focusTimerProvider);
                final taskName = _taskController.text.trim();

                if (!_isFocusing) {
                  if (taskName.isEmpty) {
                    FloatingSnackBar.show(context, message: "Please enter the Session Name");
                    return;
                  }
                  setState(() => _isFocusing = true);
                  timer.start();
                } else {
                  timer.stop();

                  final session = FocusSession(
                    task: taskName,
                    seconds: elapsed.inSeconds,
                    timestamp: DateTime.now(),
                  );

                  ref.read(sessionListProvider.notifier).addSession(session);
                  ref.read(focusTimerProvider.notifier).reset();
                  _taskController.clear();

                  setState(() => _isFocusing = false);

                  FloatingSnackBar.show(
                    context,
                    message: "Session saved!",
                    icon: Icons.check,
                    iconColor: Colors.greenAccent,
                  );

                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isFocusing ? 'Stop' : 'Start Focusing',
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
