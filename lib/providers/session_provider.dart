import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/focus_session.dart';

final sessionListProvider =
    StateNotifierProvider<SessionListNotifier, List<FocusSession>>((ref) {
      return SessionListNotifier()..loadSessions();
    });

class SessionListNotifier extends StateNotifier<List<FocusSession>> {
  SessionListNotifier() : super([]);

  Future<void> addSession(FocusSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final newList = [...state, session];
    state = newList;

    final encoded = jsonEncode(newList.map((s) => s.toJson()).toList());
    prefs.setString('sessions', encoded);
  }

  Future<void> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString('sessions');
    if (encoded == null) return;

    final decoded = jsonDecode(encoded) as List;
    state = decoded.map((item) => FocusSession.fromJson(item)).toList();
  }
}
