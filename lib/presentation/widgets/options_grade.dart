import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonix_text/presentation/riverpod/riverpod.dart';
import 'package:sonix_text/presentation/utils/utils.dart';
import 'package:sonix_text/presentation/widgets/widgets.dart';

class GradeOptionsWidget extends ConsumerStatefulWidget {
  final TextEditingController category;
  final TextEditingController status;
  final TextEditingController priority;
  final ValueChanged<int>? onTapColor;
  final String id;

  const GradeOptionsWidget(
      {super.key,
      this.id = "",
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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final categories =
        ref.watch(categoryNotifierProvider).map((e) => e.name).toList();
    return !isInit
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: screenHeight * 0.05,
            width: screenWidth * 0.95,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (widget.id.isNotEmpty && widget.id != "0")
                  Container(
                    width: screenWidth * 0.5,
                    decoration: BoxDecoration(
                      color: Color(0xFFD6EAF8).withAlpha(50),
                    ),
                    child: ListTile(
                      onTap: () {
                        context.push('/search_note_link/${widget.id}');
                      },
                      leading: Icon(Icons.link,
                          size: screenWidth * 0.04, color: Colors.greenAccent),
                      title: Text(
                        'Vincular Notas',
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ),
                SizedBox(width: screenWidth * 0.04),
                if (categories.isNotEmpty)
                  _buildDropdownField(
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
                SizedBox(width: screenWidth * 0.04),
                _buildDateSelector(context),
                _buildDropdownField(
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
                SizedBox(width: screenWidth * 0.04),
                _buildDropdownField(
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
                SizedBox(width: screenWidth * 0.04),
                SizedBox(
                    width: screenWidth * 0.4,
                    child: ColorSelector(onColorSelected: (color) {
                      ref.read(indexColor.notifier).state = color.index;
                      ref.read(selectColor.notifier).state = color.color;
                    })),
                SizedBox(width: screenWidth * 0.04),
              ],
            ));
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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final uniqueItems = items.toSet().toList();
    final validValue =
        uniqueItems.contains(value) ? value : uniqueItems.firstOrNull;

    return Container(
      constraints: BoxConstraints(
        minWidth: screenWidth * 0.3, // Set minimum width
        maxWidth: screenWidth * 0.45, // Set maximum width
      ),
      decoration: BoxDecoration(
        color: Color(0xFFD6EAF8).withAlpha(50),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03, vertical: screenHeight * 0.005),
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
            Icon(icon, size: screenWidth * 0.045, color: Colors.greenAccent),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: Text(
                validValue ?? hint,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Icon(Icons.arrow_drop_down,
                color: Colors.greenAccent, size: screenWidth * 0.06),
            SizedBox(width: screenWidth * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Container(
      constraints: BoxConstraints(
        minWidth: screenWidth * 0.3, // Set minimum width
        maxWidth: screenWidth * 0.45, // Set maximum width
      ),
      decoration: BoxDecoration(
        color: Color(0xFFD6EAF8).withAlpha(50),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03, vertical: screenHeight * 0.015),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: Row(
          children: [
            Icon(Icons.calendar_today,
                size: screenWidth * 0.045, color: Colors.greenAccent),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: Text(
                ref.watch(selectDateProvider),
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
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
