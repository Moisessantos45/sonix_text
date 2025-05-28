import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/service/notifications.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/infrastructure/user_model.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_user.dart';
import 'package:sonix_text/presentation/utils/parse_date.dart';

class NotificationManager extends ConsumerStatefulWidget {
  const NotificationManager({super.key});

  @override
  ConsumerState<NotificationManager> createState() =>
      _NotificationManagerState();
}

class _NotificationManagerState extends ConsumerState<NotificationManager> {
  int hora = 0;
  int minuto = 0;
  int i = 0;
  bool isSwitched = false;

  void initializeState() async {
    final user = ref.read(userProvider);
    if (user.isNotEmpty) {
      setState(() {
        isSwitched = user.first.activeNotifications;
        hora = user.first.hora;
        minuto = user.first.minuto;
      });
    }
  }

  Future<void> _scheduleNotifications(bool value) async {
    try {
      final user = ref.read(userProvider);
      if (user.isEmpty) {
        throw Exception("No hay usuario");
      }

      final updatedUser = user.first.copyWith(
        activeNotifications: value,
      );

      if (!value) {
        await NotificationsService.cancelAll();

        await _updateUser(updatedUser.copyWith(activeNotifications: false));

        showNotification(
            "Notificaciones", "Las notificaciones han sido desactivadas");
        return;
      }

      if (hora <= 0 || hora > 24 || minuto <= 0 || minuto > 59) {
        showNotification("Error",
            "La hora y el minuto deben estar en el rango correcto (0-23 y 0-59)",
            error: true);
        return;
      }

      final dueSoonGrades = filterNotesDueSoon(ref.read(allGradesProvider));
      if (dueSoonGrades.isEmpty) return;

      for (final grade in dueSoonGrades) {
        DateTime fecha = parseDate(grade.dueDate) ?? DateTime.now();

        DateTime fechaConHora =
            DateTime(fecha.year, fecha.month, fecha.day, hora, minuto);

        await NotificationsService.cancel(i);

        await NotificationsService.hideNotificationSchedule(
          i,
          "La nota ${grade.title}",
          'La nota ${grade.title} se vence en ${grade.dueDate}',
          fechaConHora,
        );
        i++;
      }

      await _updateUser(updatedUser.copyWith(
          minuto: minuto, hora: hora, activeNotifications: true));

      showNotification("Notificaciones",
          "Las notificaciones han sido programadas correctamente");
      setState(() {
        isSwitched = true;
      });
    } catch (e) {
      showNotification("Error", "Error al programar las notificaciones",
          error: true);

      await NotificationsService.cancelAll();
      setState(() {
        isSwitched = false;
        i = 0;
      });
      return;
    }
  }

  Future<void> _updateUser(UserModel updatedUser) async {
    await ref.read(userNotifierProvider.notifier).updateUser(updatedUser);
  }

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notificaciones',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF2C3E50),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildTextField(
              'H (0-23)',
              (value) => setState(() {
                hora = int.parse(value);
              }),
            ),
            const SizedBox(width: 12),
            _buildTextField(
              'Min (0-59)',
              (value) => setState(() {
                minuto = int.parse(value);
              }),
            ),
            const SizedBox(width: 12),
            Switch(
              value: isSwitched,
              onChanged: (value) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    elevation: 30,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black.withAlpha(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text('Confirmar'),
                    content: const Text(
                        '¿Está seguro de que desea activar las notificaciones?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _scheduleNotifications(value);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          _scheduleNotifications(value);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              },
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.blue,
              inactiveTrackColor: Colors.white,
              trackOutlineColor: WidgetStatePropertyAll(Colors.grey[400]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
    String hintText,
    Function(String) onChanged,
  ) {
    return SizedBox(
      width: 120,
      height: 50,
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF2C3E50),
          fontWeight: FontWeight.w500,
        ),
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            onChanged(value);
          } else {
            onChanged('0');
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
      ),
    );
  }
}
