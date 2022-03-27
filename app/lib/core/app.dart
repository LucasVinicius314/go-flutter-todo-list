import 'package:flutter/cupertino.dart';
import 'package:go_flutter_todo_list/modules/main_page.dart';
import 'package:go_flutter_todo_list/modules/new_todo_page.dart';
import 'package:go_flutter_todo_list/modules/splash_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Go Flutter Todo List',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(brightness: Brightness.light),
      routes: {
        SplashPage.route: (context) => const SplashPage(),
        MainPage.route: (context) => const MainPage(),
        NewTodoPage.route: (context) => const NewTodoPage(),
      },
    );
  }
}
