import 'package:dio/dio.dart';
import 'package:field_track/core/constants/api_constants.dart';
import 'package:field_track/features/todos/data/models/todo_model.dart';

class TodoRemoteDatasource {
  final Dio dio;

  TodoRemoteDatasource(this.dio);

  Future<List<TodoModel>> fetchTodos() async {
    final response = await dio.get(ApiConstants.todos);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>;
    return list
        .map((e) => TodoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> patchTodo({
    required String id,
    required bool isCompleted,
    required String updatedAt,
  }) async {
    await dio.patch(
      '${ApiConstants.todos}/$id',
      data: {
        'is_completed': isCompleted,
        'updated_at': updatedAt,
      },
    );
  }

  Future<void> syncTodos(List<Map<String, dynamic>> changes) async {
    if (changes.isEmpty) return;
    await dio.post(
      ApiConstants.todosSync,
      data: {'changes': changes},
    );
  }
}
