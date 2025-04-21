import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/utils/options.dart';
import 'package:sonix_text/presentation/widgets/item_grade.dart';

class GradeDisplayWidget extends ConsumerStatefulWidget {
  const GradeDisplayWidget({super.key});

  @override
  ConsumerState<GradeDisplayWidget> createState() => _GradeDisplayWidgetState();
}

class _GradeDisplayWidgetState extends ConsumerState<GradeDisplayWidget> {
  int _selectedMenu = 0;

  @override
  Widget build(BuildContext context) {
    final gradesState = ref.watch(gradesProvider);
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView.builder(
            itemCount: statusFilter.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMenu = index;
                    });
                    ref
                        .read(gradeNotifierProvider.notifier)
                        .setFilter(statusFilter[index]['value']!);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedMenu == index
                          ? Colors.blue
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusFilter[index]['name']!,
                      style: TextStyle(
                        color: _selectedMenu == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xFFD6EAF8).withAlpha(50),
              borderRadius:const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: gradesState.isEmpty
                ? const Center(
                    child: Text(
                      'No hay notas',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: gradesState.length,
                    itemBuilder: (context, index) {
                      final grade = gradesState[index];
                      return GradeItemWidget(grade: grade);
                    },
                  ),
          ),
        )
      ],
    );
  }
}
