import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:sonix_text/presentation/screens/about.dart';
import 'package:sonix_text/presentation/utils/validate_string.dart';
import 'package:sonix_text/presentation/widgets/add_category_dialog.dart';
import 'package:sonix_text/presentation/widgets/avatar.dart';
import 'package:sonix_text/presentation/widgets/manage_notifications.dart';
import 'package:sonix_text/presentation/riverpod/repository_user.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/infrastructure/category_model.dart';
import 'package:sonix_text/config/helper/page_router.dart';
import 'package:sonix_text/presentation/riverpod/repository_category.dart';
import 'package:sonix_text/presentation/widgets/custom_text_form_field.dart';
import 'package:sonix_text/presentation/widgets/list_category.dart';
import 'package:sonix_text/presentation/widgets/navigation_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final uuid = Uuid();
  String avatar = '92574792835600d793';

  void _showAddCategoryDialog() {
    AddCategoryDialog.show(
        context: context,
        onAddCategory: (value) {
          addCategory(value);
        });
  }

  void initializeState() async {
    final user = ref.read(userProvider);
    if (user.isNotEmpty) {
      _nameController.text = user.first.name;
      _nicknameController.text = user.first.nickname;
      avatar = user.first.avatar;
    }
  }

  Future<void> updateUser() async {
    try {
      final validate = isValidString(_nameController.text) &&
          isValidString(_nicknameController.text);

      if (!validate) {
        showNotification("Error", "Algunos campos son inválidos", error: true);
        return;
      }

      final user = ref.read(userProvider);
      if (user.isNotEmpty) {
        final updatedUser = user.first.copyWith(
          name: _nameController.text.trim(),
          nickname: _nicknameController.text.trim(),
        );

        await ref.read(userNotifierProvider.notifier).updateUser(updatedUser);
        showNotification("Éxito", "Usuario actualizado correctamente");
      }
    } catch (e) {
      showNotification("Error", "No se pudo actualizar el usuario",
          error: true);
    }
  }

  Future<void> addCategory(String category) async {
    try {
      final categoryName =
          category[0].toUpperCase() + category.substring(1).toLowerCase();

      final newCategory = CategoryModel(
        id: uuid.v4(),
        name: categoryName.trim(),
      );
      await ref
          .read(categoryNotifierProvider.notifier)
          .addCategory(newCategory);

      showNotification("Éxito", "Categoría agregada correctamente");
    } catch (e) {
      showNotification("Error", "No se pudo agregar la categoría", error: true);
    }
  }

  Future<void> deleteCategory(String category) async {
    try {
      await ref
          .read(categoryNotifierProvider.notifier)
          .deleteCategory(category);
      showNotification("Éxito", "Categoría eliminada correctamente");
    } catch (e) {
      showNotification("Error", "No se pudo eliminar la categoría",
          error: true);
    }
  }

  void _onMenuSelected(String value) {
    Navigator.push(context, CustomPageRoute(page: const AboutScreen()));
  }

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryNotifierProvider);
    final categoryNames = categories.map((e) => e.name).toSet().toList();

    return Scaffold(
        backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Mi Perfil',
            style: TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              surfaceTintColor: Colors.white,
              iconSize: 30,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color(0xFFF5F5F5)),
              ),
              onSelected: _onMenuSelected,
              itemBuilder: (BuildContext context) {
                return {'Acerca de'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice.toLowerCase(),
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      AvatarWidget(
                        avatar: avatar,
                        onSelect: (p0) => {},
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Información Personal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextFormField(
                  controller: _nameController,
                  label: 'Nombre',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _nicknameController,
                  label: 'Apodo',
                  icon: Icons.alternate_email,
                ),
                const SizedBox(height: 32),
                NotificationManager(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mis Categorías',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    IconButton(
                      onPressed: _showAddCategoryDialog,
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xFF3498DB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CategoryListWidget(
                  categories: categoryNames,
                  onCategory: (category) {
                    final item = categories
                        .firstWhere((element) => element.name == category);
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        elevation: 30,
                        surfaceTintColor: Colors.white,
                        shadowColor: Colors.black.withAlpha(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text('Eliminar Categoría'),
                        content: Text(
                          '¿Estás seguro de que deseas eliminar la categoría "$category"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteCategory(item.id);
                              Navigator.pop(context);
                            },
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: updateUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3498DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Guardar Cambios',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF3498DB),
          onPressed: () {
           context.push("/add_note/0");
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomNavigation());
  }
}
