import 'package:field_track/features/todos/domain/entities/todo.dart';

String userInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return '?';
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

String formatRoleLabel(String role) {
  if (role.trim().isEmpty) return 'Field User';
  return role
      .split(RegExp(r'[_\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

int countTasksDoneToday(List<Todo> todos) {
  final now = DateTime.now();
  return todos.where((todo) {
    if (!todo.isCompleted) return false;
    final updated = DateTime.parse(todo.updatedAt).toLocal();
    return updated.year == now.year &&
        updated.month == now.month &&
        updated.day == now.day;
  }).length;
}
