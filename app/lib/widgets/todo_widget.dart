import 'package:flutter/cupertino.dart';
import 'package:go_flutter_todo_list/models/todo.dart';
import 'package:go_flutter_todo_list/providers/app_provider.dart';
import 'package:provider/provider.dart';

class TodoWidget extends StatefulWidget {
  const TodoWidget({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  Future<void> _delete() async {
    final ans = await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Warning'),
          content: const Text(
            'Delete this todo? This action cannot be undone.',
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Yes'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).maybePop(true);
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
          ],
        );
      },
    );

    if (ans != true) return;

    final id = widget.todo.id;

    final res = await Todo.delete(id: id);

    await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Success!'),
          content: Text(res.message),
        );
      },
    );

    final provider = Provider.of<AppProvider>(context, listen: false);

    provider.updateTodos();
  }

  Future<void> _edit() async {
    // TODO: fix
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.todo.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.todo.content),
              ],
            ),
          ),
          const SizedBox.square(dimension: 8),
          CupertinoButton(
            onPressed: _edit,
            child: const Icon(CupertinoIcons.pen),
          ),
          CupertinoButton(
            onPressed: _delete,
            child: const Icon(CupertinoIcons.delete),
          ),
        ],
      ),
    );
  }
}
