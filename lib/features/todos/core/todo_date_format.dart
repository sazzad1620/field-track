const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatHeaderDate(DateTime date) {
  final weekday = _weekdays[date.weekday - 1];
  final month = _months[date.month - 1];
  return '$weekday, $month ${date.day}';
}

String formatTodoTime(String? iso, {required bool isCompleted}) {
  if (iso == null || iso.isEmpty) return '';
  final dt = DateTime.parse(iso).toLocal();
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  final prefix = isCompleted ? 'Done' : 'Due';
  return '$prefix $hour:$minute $period';
}

String formatPendingSyncTime(String? iso, {required bool isCompleted}) {
  if (iso == null || iso.isEmpty) return '';
  final dt = DateTime.parse(iso).toLocal();
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  final label = isCompleted ? 'Marked done' : 'Marked undone';
  return '$label · $hour:$minute $period';
}

String formatLastSynced(DateTime? at) {
  if (at == null) return 'Not synced yet';
  final local = at.toLocal();
  final now = DateTime.now();
  final sameDay = local.year == now.year &&
      local.month == now.month &&
      local.day == now.day;
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final period = local.hour >= 12 ? 'PM' : 'AM';
  final time = '$hour:$minute $period';
  if (sameDay) return 'Last synced today, $time';
  final yesterday = now.subtract(const Duration(days: 1));
  final isYesterday = local.year == yesterday.year &&
      local.month == yesterday.month &&
      local.day == yesterday.day;
  if (isYesterday) return 'Last synced yesterday, $time';
  final month = _months[local.month - 1];
  return 'Last synced $month ${local.day}, $time';
}

String pendingChangesLabel(int count) {
  if (count == 1) return '1 change pending';
  return '$count changes pending';
}
