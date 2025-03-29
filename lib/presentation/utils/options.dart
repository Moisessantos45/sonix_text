// final List<String> categories = [
//   'General',
//   'Escolar',
//   'Trabajo',
//   'Casa',

//   'Personal'
// ];

final List<String> statusOptions = ['Pending', 'In Progress', 'Completed'];
final List<Map<String, String>> statusFilter = [
  {'name': 'Pendiente', 'value': 'Pending'},
  {'name': 'En Progreso', 'value': 'In Progress'},
  {'name': 'Completo', 'value': 'Completed'},
  {'name': 'Todos', 'value': 'All'},
];
List<String> listMenu = ['All', ...statusOptions];
final List<String> priorityOptions = ['Low', 'Normal', 'High'];
final List<int> statusColors = [0xFFE57373, 0xFF81C784, 0xFF64B5F6];
