class FocusSession {
  final String task;
  final int seconds;
  final DateTime timestamp;

  FocusSession({
    required this.task,
    required this.seconds,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'seconds': seconds,
      'timestamp': timestamp.toIso8601String(), 
    };
  }

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      task: json['task'],
      seconds: json['seconds'],
      timestamp: DateTime.parse(json['timestamp']), 
    );
  }
}
