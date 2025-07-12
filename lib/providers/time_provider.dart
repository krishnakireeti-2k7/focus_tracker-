import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final focusTimerProvider = StateNotifierProvider<FocusTimerNotifier, Duration>((
  ref,
) {
  return FocusTimerNotifier();
});

class FocusTimerNotifier extends StateNotifier<Duration> {
  Timer? _timer;

  FocusTimerNotifier() : super(Duration.zero);

  void start() {
    _timer?.cancel(); // Cancel if already running
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state + const Duration(seconds: 1);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    stop();
    state = Duration.zero;
  }
}
