import 'package:flutter/cupertino.dart';
import 'package:go_flutter_todo_list/models/todo.dart';
import 'package:go_flutter_todo_list/modules/edit_todo_page.dart';
import 'package:go_flutter_todo_list/providers/app_provider.dart';
import 'package:go_flutter_todo_list/widgets/error_message_widget.dart';
import 'package:go_flutter_todo_list/widgets/todo_widget.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const route = 'main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<void> _newTodo() async {
    await Navigator.of(context).pushNamed(EditTodoPage.route);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<AppProvider>(context, listen: false);

      provider.updateTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Todo list'),
        trailing: CupertinoButton(
          onPressed: _newTodo,
          child: const Text('New'),
          padding: EdgeInsets.zero,
        ),
      ),
      child: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, value, child) {
            return FutureBuilder<Iterable<Todo>>(
              future: value.todosFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const ErrorMessageWidget();
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  final todos = snapshot.data ?? [];

                  if (todos.isEmpty) {
                    return const ErrorMessageWidget(
                      message: 'Your todo list is empty.',
                    );
                  }

                  return ListView.separated(
                    itemCount: todos.length,
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 1,
                        color: CupertinoTheme.of(context).barBackgroundColor,
                      );
                    },
                    itemBuilder: (context, index) {
                      final todo = todos.elementAt(index);

                      return TodoWidget(todo: todo);
                    },
                  );
                }

                return const Center(child: CupertinoActivityIndicator());
              },
            );
          },
        ),
      ),
    );
  }
}
