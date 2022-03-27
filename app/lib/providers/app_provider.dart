import 'package:flutter/cupertino.dart';
import 'package:go_flutter_todo_list/models/todo.dart';

class AppProvider with ChangeNotifier {
  Future<Iterable<Todo>>? _todosFuture;

  Future<Iterable<Todo>>? get todosFuture => _todosFuture;

  void setTodosFutures(Future<Iterable<Todo>>? todosFuture) {
    _todosFuture = todosFuture;

    notifyListeners();
  }

  void updateTodos() {
    setTodosFutures(Todo.all());
  }
}
