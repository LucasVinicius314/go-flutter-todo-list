import 'package:flutter/cupertino.dart';
import 'package:go_flutter_todo_list/models/todo.dart';
import 'package:go_flutter_todo_list/providers/app_provider.dart';
import 'package:provider/provider.dart';

class NewTodoPage extends StatefulWidget {
  const NewTodoPage({Key? key}) : super(key: key);

  static const route = 'new_todo';

  @override
  State<NewTodoPage> createState() => _NewTodoPageState();
}

class _NewTodoPageState extends State<NewTodoPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();

  bool _titleEmpty = true;
  bool _contentEmpty = true;

  @override
  void initState() {
    super.initState();

    _titleController.addListener(() {
      setState(() {
        _titleEmpty = _titleController.text.isEmpty;
      });
    });

    _contentController.addListener(() {
      setState(() {
        _contentEmpty = _contentController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(() {});
    _contentController.removeListener(() {});

    super.dispose();
  }

  String? _validateTitle(String value) {
    if (value.length <= 4) {
      return 'Title is too short.';
    }
  }

  String? _validateContent(String value) {
    if (value.length <= 6) {
      return 'Content is too short.';
    }
  }

  Future<void> _create() async {
    final title = _titleController.text;
    final content = _contentController.text;

    final error = _validateTitle(title) ?? _validateContent(content);

    if (error != null) {
      await showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Warning'),
            content: Text(error),
          );
        },
      );

      return;
    }

    final res = await Todo.create(title: title, content: content);

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

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('New todo'),
        trailing: Builder(
          builder: (context) {
            final disabled = _titleEmpty || _contentEmpty;

            return CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('Create'),
              onPressed: disabled ? null : _create,
            );
          },
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Title',
                            style: TextStyle(
                              color: CupertinoColors.inactiveGray,
                            ),
                          ),
                          const SizedBox.square(dimension: 4),
                          CupertinoTextField(
                            placeholder: 'Title',
                            focusNode: _titleFocusNode,
                            controller: _titleController,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Content',
                              style: TextStyle(
                                color: CupertinoColors.inactiveGray,
                              ),
                            ),
                            const SizedBox.square(dimension: 4),
                            CupertinoTextField(
                              minLines: 2,
                              maxLines: 6,
                              placeholder: 'Content',
                              focusNode: _contentFocusNode,
                              controller: _contentController,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
