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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    return Container(
      width: screenWidth * 0.2, // era 80
      height: screenWidth * 0.2, // era 80
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF3498DB),
          width: screenWidth * 0.005, // era 2
        ),
      ),
      child: Stack(
        children: [
          GestureDetector(
              onTap: _showAddAvatar,
              child: AvatarPlus(
                widget.avatar,
                height: screenWidth * 0.2,
                width: screenWidth * 0.2,
              )),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF3498DB),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(screenWidth * 0.01), // era 4
                child: Icon(
                  Icons.camera_alt,
                  size: screenWidth * 0.04, // era 16
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAvatar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final Size screenSize = MediaQuery.of(context).size;
        final double screenWidth = screenSize.width;

        String newAvatar = '';
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 30,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withAlpha(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.04), // era 16
          ),
          title: const Text('Ingrese el código del avatar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Puede obtener códigos de avatar en:\nhttps://multiavatar.com',
                style: TextStyle(
                  fontSize: screenWidth * 0.03, // era 12
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: screenWidth * 0.025), // era 10
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
}
