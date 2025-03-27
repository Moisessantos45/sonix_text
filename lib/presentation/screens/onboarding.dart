import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/helper/shared_preferents.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/infrastructure/category_model.dart';
import 'package:sonix_text/infrastructure/user_model.dart';
import 'package:sonix_text/presentation/riverpod/repository_category.dart';
import 'package:sonix_text/presentation/riverpod/repository_level.dart';
import 'package:sonix_text/presentation/riverpod/repository_user.dart';
import 'package:go_router/go_router.dart';
import 'package:sonix_text/presentation/utils/data_level.dart';
import 'package:uuid/uuid.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final List<String> listCategory = ["Tecnología", "Deportes", "Cine"];
  final List<String> selectCategory = [];

  Future<void> registerUser() async {
    try {
      final sharedPreferents = SharedPreferentsManager();
      final uuid = Uuid();

      for (final level in listLevel) {
        await ref.read(levelNotifierProvider.notifier).addLevel(level);
      }

      final newList =
          selectCategory.map((e) => e.toLowerCase()).toSet().toList();

      for (final item in newList) {
        final categoryName =
            item[0].toUpperCase() + item.substring(1).toLowerCase();

        final category = CategoryModel(
          id: uuid.v4(),
          name: categoryName,
        );

        await ref.read(categoryNotifierProvider.notifier).addCategory(category);
      }

      final user = UserModel(
          id: uuid.v4(),
          name: _nameController.text,
          nickname: _nicknameController.text.trim(),
          level: 1);

      await ref.read(userNotifierProvider.notifier).addUser(user);

      await sharedPreferents.saveData("isRegistered", true);

      showNotification("Success", "User registered successfully");
      context.go('/');
    } catch (e) {
      showNotification("Error", e.toString(), error: true);
    }
  }

  void _showAddCategoryDialog() {
    final TextEditingController categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Categoría'),
        content: TextField(
          controller: categoryController,
          decoration: const InputDecoration(
            hintText: 'Nombre de la categoría',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                setState(() {
                  selectCategory.add(categoryController.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF5F5F5),
              Color(0xFFE8F0FE),
              Color(0xFFE3F2FD),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB).withAlpha(10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    size: 80,
                    color: Color(0xFF3498DB),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Personaliza tu experiencia',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF2C3E50).withAlpha(70),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.person_outline,
                      color: Color(0xFF3498DB)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.alternate_email,
                      color: Color(0xFF3498DB)),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tus intereses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  IconButton(
                    onPressed: _showAddCategoryDialog,
                    icon: const Icon(Icons.add_circle, size: 28),
                    color: const Color(0xFF3498DB),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  ...listCategory.map((category) => FilterChip(
                        label: Text(category),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectCategory.add(category);
                              listCategory.remove(category);
                            }
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF3498DB).withAlpha(15),
                        checkmarkColor: const Color(0xFF3498DB),
                        labelStyle: TextStyle(
                          color: selectCategory.contains(category)
                              ? const Color(0xFF3498DB)
                              : const Color(0xFF2C3E50),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      )),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Seleccionadas',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2C3E50).withAlpha(70),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  ...selectCategory.map((category) => Chip(
                        label: Text(category),
                        backgroundColor: const Color(0xFF3498DB).withAlpha(15),
                        labelStyle: const TextStyle(color: Color(0xFF3498DB)),
                        deleteIcon: const Icon(Icons.close,
                            color: Color(0xFF3498DB), size: 20),
                        onDeleted: () {
                          setState(() {
                            selectCategory.remove(category);
                            listCategory.add(category);
                          });
                        },
                      )),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _nicknameController.text.isNotEmpty) {
                      registerUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3498DB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Comenzar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
