class FocusSession {
  final String task;
  final int seconds;
  final DateTime timestamps;

  FocusSession({
    required this.task,
    required this.seconds,
    required this.timestamps,
  });

  Map<String, dynamic> toJson() {
    return{
      'task': task,
      'seconds': seconds,
      'timestamps': timestamps,
    };
  }
  factory FocusSession.fromJson(Map<String,dynamic> json){
    return FocusSession(
      task: json['task'],
      seconds: json['seconds'],
      timestamps: json['timestamps'],
    );
  }
}
