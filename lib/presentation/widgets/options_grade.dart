import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/riverpod/repository_category.dart';
import 'package:sonix_text/presentation/utils/options.dart';
import 'package:sonix_text/presentation/widgets/color_select.dart';

class GradeOptionsWidget extends ConsumerStatefulWidget {
  final TextEditingController category;
  final TextEditingController status;
  final TextEditingController priority;
  final TextEditingController dueDate;
  final ValueChanged<int> onTapColor;

  const GradeOptionsWidget(
      {super.key,
      required this.category,
      required this.status,
      required this.priority,
      required this.dueDate,
      required this.onTapColor});

  @override
  ConsumerState<GradeOptionsWidget> createState() => _GradeOptionsWidgetState();
}

class _GradeOptionsWidgetState extends ConsumerState<GradeOptionsWidget> {
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool isInit = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
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
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        widget.dueDate.text =
            '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}';
      });
    }
  }

  void initializeState() {
    final categories = ref.read(categoryNotifierProvider);

    if (categories.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final validCategories = categories.map((e) => e.name).toSet().toList();
    final currentValue = widget.category.text.trim();

    List<String> parts = widget.dueDate.text.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    _dueDate = DateTime(year, month, day);

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
    initializeState();
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
                        widget.onTapColor(color);
                      }),
                    ),
                  ],
                ),
              ),
            ],
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
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.greenAccent),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: validValue,
                isDense: true,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down,
                    color: Colors.greenAccent),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C3E50),
                ),
                onChanged: onChanged,
                items: uniqueItems.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                hint: Text(hint),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.calendar_today,
                size: 18, color: Colors.greenAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
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
