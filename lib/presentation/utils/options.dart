// final List<String> categories = [
//   'General',
//   'Escolar',
//   'Trabajo',
//   'Casa',

//   'Personal'
// ];

final List<String> statusOptions = ['Pending', 'In Progress', 'Completed'];
final List<Map<String, String>> statusFilter = [
  {'name': 'Todos', 'value': 'All'},
  {'name': 'Pendiente', 'value': 'Pending'},
  {'name': 'En Progreso', 'value': 'In Progress'},
  {'name': 'Completo', 'value': 'Completed'},
];
List<String> listMenu = ['All', ...statusOptions];
final List<String> priorityOptions = ['Low', 'Normal', 'High'];
final List<int> statusColors = [0xFFf44336, 0xFFffd54f, 0xFF00e676];
