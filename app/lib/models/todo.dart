import 'package:go_flutter_todo_list/models/message.dart';
import 'package:go_flutter_todo_list/services/networking.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class Todo {
  final int id;
  final String title;
  final String content;

  Todo({
    required this.id,
    required this.title,
    required this.content,
  });

  static Future<Iterable<Todo>> all() async {
    final res = await Api.get('todos') as List;

    return res.map((e) => Todo.fromJson(e));
  }

  static Future<Message> create({
    required String title,
    required String content,
  }) async {
    final res = await Api.post('todo', body: {
      'title': title,
      'content': content,
    });

    return Message.fromJson(res);
  }

  static Future<Message> update({
    required int id,
    required String title,
    required String content,
  }) async {
    final res = await Api.put('todo/$id', body: {
      'title': title,
      'content': content,
    });

    return Message.fromJson(res);
  }

  static Future<Message> delete({required int id}) async {
    final res = await Api.delete('todo/$id');

    return Message.fromJson(res);
  }

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
