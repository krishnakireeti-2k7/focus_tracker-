import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/focus_session.dart';

final sessionListProvider =
    StateNotifierProvider<SessionListNotifier, List<FocusSession>>((ref) {
      return SessionListNotifier(); // no need for init call here
    });

class SessionListNotifier extends StateNotifier<List<FocusSession>> {
  SessionListNotifier() : super([]) {
    // 👇 this ensures sessions are loaded when provider is first created
    Future.microtask(() => loadSessions());
  }

  void addSession(FocusSession session, {int? atIndex}) {
    final updatedList = [...state];
    if (atIndex != null && atIndex >= 0 && atIndex <= updatedList.length) {
      updatedList.insert(atIndex, session);
    } else {
      updatedList.add(session);
    }
    state = updatedList;
  }
  Future<void> loadSessions() async {
    print('📥 Trying to load saved sessions...');
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString('sessions');

    if (encoded == null) {
      print('⚠️ No saved sessions found.');
      return;
    }

    final decoded = jsonDecode(encoded) as List;
    final loaded = decoded.map((item) => FocusSession.fromJson(item)).toList();
    state = loaded;
  }

  Future<void> deleteSession(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final newList = [...state]..removeAt(index);
    state = newList;

    final encoded = jsonEncode(newList.map((s) => s.toJson()).toList());
    await prefs.setString('sessions', encoded);
  }
}
