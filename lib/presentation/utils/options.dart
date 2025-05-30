// final List<String> categories = [
//   'General',
//   'Escolar',
//   'Trabajo',
//   'Casa',

//   'Personal'
// ];

final List<String> statusOptions = ['Pending', 'In Progress', 'Completed'];
final List<Map<String, String>> statusFilter = [
  {"name":"Ver","value":"See All"},
  {'name': 'Todos', 'value': 'All'},
  {'name': 'Pendiente', 'value': 'Pending'},
  {'name': 'En Progreso', 'value': 'In Progress'},
  {'name': 'Completo', 'value': 'Completed'},
];
List<String> listMenu = ['All', ...statusOptions];
final List<String> priorityOptions = ['Low', 'Normal', 'High'];
final List<int> statusColors = [0XFFE74C3C, 0XFFF1C40F, 0xFF1ABC9C];
