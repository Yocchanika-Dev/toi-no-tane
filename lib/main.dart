import 'package:flutter/material.dart';
import 'view.dart';
import 'view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final vm = KanbanViewModel();
  await vm.load();
  runApp(
    ListenableBuilder(
      listenable: vm,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '問いの種',
        theme: ThemeData(colorSchemeSeed: Colors.teal),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.teal,
          brightness: Brightness.dark,
        ),
        themeMode: vm.isDark ? ThemeMode.dark : ThemeMode.light,
        home: KanbanView(vm),
      ),
    ),
  );
}
