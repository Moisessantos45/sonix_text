import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonix_text/presentation/riverpod/repository_category.dart';
import 'package:sonix_text/presentation/riverpod/select_date.dart';
import 'package:sonix_text/presentation/riverpod/seletc_color.dart';
import 'package:sonix_text/presentation/utils/options.dart';
import 'package:sonix_text/presentation/utils/parse_date.dart';
import 'package:sonix_text/presentation/widgets/color_select.dart';
import 'package:sonix_text/presentation/widgets/modal_select.dart';

class GradeOptionsWidget extends ConsumerStatefulWidget {
  final TextEditingController category;
  final TextEditingController status;
  final TextEditingController priority;
  final ValueChanged<int>? onTapColor;

  const GradeOptionsWidget(
      {super.key,
      required this.category,
      required this.status,
      required this.priority,
      this.onTapColor});

  @override
  ConsumerState<GradeOptionsWidget> createState() => _GradeOptionsWidgetState();
}

class _GradeOptionsWidgetState extends ConsumerState<GradeOptionsWidget> {
  bool isInit = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ref.read(initialDateProvider),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3498DB),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != ref.read(initialDateProvider)) {
      ref.read(initialDateProvider.notifier).state = picked;
      ref.read(selectDateProvider.notifier).state =
          formatDateTimeToString(picked);
    }
  }

  void initializeState() {
    final categories = ref.read(categoryNotifierProvider);

    if (categories.isEmpty) {
      context.go("/");
      return;
    }

    final validCategories = categories.map((e) => e.name).toSet().toList();
    final currentValue = widget.category.text.trim();

    setState(() {
      if (currentValue.isEmpty || !validCategories.contains(currentValue)) {
        widget.category.text = validCategories.first;
      }
      isInit = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        ref.watch(categoryNotifierProvider).map((e) => e.name).toList();
    return !isInit
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    if (categories.isNotEmpty)
                      Expanded(
                        child: _buildDropdownField(
                          icon: Icons.category_outlined,
                          hint: 'Categoría',
                          value: widget.category.text,
                          items: categories,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                widget.category.text = value;
                              });
                            }
                          },
                        ),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateSelector(context),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        icon: Icons.flag_outlined,
                        hint: 'Estado',
                        value: widget.status.text,
                        items: statusOptions,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              widget.status.text = value;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        icon: Icons.priority_high_outlined,
                        hint: 'Prioridad',
                        value: widget.priority.text,
                        items: priorityOptions,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              widget.priority.text = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ColorSelector(onColorSelected: (color) {
                        ref.read(indexColor.notifier).state = color.index;
                        ref.read(selectColor.notifier).state = color.color;
                      }),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  void _showSelector(context, List<String> items, String title,
      String selectedItem, Function(String) onItemSelected) {
    SelectionModal.show(
      context: context,
      items: items,
      title: title,
      selectedItem: selectedItem,
      onItemSelected: (value) {
        onItemSelected(value);
      },
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String hint,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    final uniqueItems = items.toSet().toList();
    final validValue =
        uniqueItems.contains(value) ? value : uniqueItems.firstOrNull;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD6EAF8).withAlpha(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: GestureDetector(
          onTap: () {
            _showSelector(
              context,
              uniqueItems,
              hint,
              validValue ?? items.first,
              (value) {
                onChanged(value);
              },
            );
          },
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.greenAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  validValue ?? hint,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_drop_down, color: Colors.greenAccent),
              const SizedBox(width: 8),
            ],
          )),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD6EAF8).withAlpha(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.calendar_today,
                size: 18, color: Colors.greenAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                ref.watch(selectDateProvider),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
