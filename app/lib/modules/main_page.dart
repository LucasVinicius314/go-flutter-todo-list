import 'package:flutter/cupertino.dart';
import 'package:go_flutter_todo_list/modules/new_todo_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const route = 'main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<void> _newTodo() async {
    await Navigator.of(context).pushNamed(NewTodoPage.route);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Text('Main'),
      navigationBar: CupertinoNavigationBar(
        middle: Text('Todo list'),
        trailing: CupertinoButton(
          child: Text('New'),
          padding: EdgeInsets.zero,
          onPressed: _newTodo,
        ),
      ),
    );
  }
}