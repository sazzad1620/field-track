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
