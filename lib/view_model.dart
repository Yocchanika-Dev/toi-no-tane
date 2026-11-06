import 'package:flutter/foundation.dart';
import 'model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class KanbanViewModel extends ChangeNotifier {
  final prefs = SharedPreferencesAsync();
  final tasks = <Task>[];
  bool isDark = false;

  Future<void> toggleTheme() async {
    isDark = !isDark;
    notifyListeners();
    await prefs.setBool('isDark', isDark);
  }

  Future<void> load() async {
    isDark = await prefs.getBool('isDark') ?? false;
    final data = await prefs.getString('kanban');
    if (data == null) {
      tasks.addAll([
        Task('雨上がりの土は、なぜ独特のにおいがする？'),
        Task('同じ場所でも、苔が生える面と生えない面があるのはなぜ？'),
        Task('水温が違うと、氷が溶ける速さはどう変わる？'),
      ]);
      await save();
      return;
    }
    tasks.clear();
    for (final t in jsonDecode(data)) {
      tasks.add(Task(t['title'], t['status']));
    }
  }

  Future<void> save() async {
    notifyListeners();
    final data = [
      for (final t in tasks) {'title': t.title, 'status': t.status},
    ];
    await prefs.setString('kanban', jsonEncode(data));
  }

  // Task を作って一覧へ追加する、変更を通知する
  void add(String text) {
    tasks.add(Task(text));
    save();
  }

  void move(Task t, int status) {
    t.status = status;
    save();
  }

  void rename(Task t, String text) {
    t.title = text;
    save();
  }

  void remove(Task t) {
    tasks.remove(t);
    save();
  }

  // tasks.add() は、リストの末尾へタスクを追加する。そのあと、notifyListners() で変更を知らせる。View 側の ListenableBuilder がボードの表示を作り直す
  // final tasks = <Task>[]; は、Task を入れる空のリスト。final は変数に別のリストを代入しないという指定で、tasks.add() のようにリストの中身を変更することはできる。
}
