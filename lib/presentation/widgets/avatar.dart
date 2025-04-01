import 'package:flutter/material.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/presentation/riverpod/repository_user.dart';

class AvatarWidget extends ConsumerStatefulWidget {
  final Function(String)? onSelect;
  final String avatar;

  const AvatarWidget({
    super.key,
    required this.onSelect,
    required this.avatar,
  });

  @override
  ConsumerState<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends ConsumerState<AvatarWidget> {
  Future<void> changeAvatar(String avatar) async {
    try {
      final user = ref.read(userProvider);
      if (user.isEmpty) {
        throw Exception("No hay usuario");
      }
      final updatedUser = user.first.copyWith(
        avatar: avatar,
      );

      await ref.read(userNotifierProvider.notifier).updateUser(updatedUser);
      showNotification(
        "Éxito",
        "Avatar cambiado correctamente",
      );
    } catch (e) {
      showNotification("Error", "No se pudo cambiar el avatar", error: true);
    }
  }

  void _showAddAvatar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newAvatar = '';
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 30,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withAlpha(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Ingrese el código del avatar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Puede obtener códigos de avatar en:\nhttps://multiavatar.com',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  newAvatar = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Ejemplo: abc123',
                  labelText: 'Código del avatar',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (newAvatar.trim().isNotEmpty) {
                  changeAvatar(newAvatar.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF3498DB),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          GestureDetector(
              onTap: _showAddAvatar,
              child: AvatarPlus(
                widget.avatar,
                height: MediaQuery.of(context).size.width - 20,
                width: MediaQuery.of(context).size.width - 20,
              )),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3498DB),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
