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
  int _selectedMenu = 1;

  @override
  Widget build(BuildContext context) {
    final gradesState = ref.watch(gradesProvider);
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: width * 0.15, // antes 60
          child: ListView.builder(
            itemCount: statusFilter.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: width * 0.05), // antes 20
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(width * 0.02), // antes 8.0
                child: GestureDetector(
                  onTap: () {
                    if (index == 0) return;
                    setState(() {
                      _selectedMenu = index;
                    });
                    ref
                        .read(gradeNotifierProvider.notifier)
                        .setFilter(statusFilter[index]['value']!);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06, // antes 20
                        vertical: width * 0.025), // antes 10
                    decoration: BoxDecoration(
                      color: _selectedMenu == index
                          ? Colors.blue
                          : Colors.grey[200],
                      borderRadius:
                          BorderRadius.circular(width * 0.05), // antes 20
                    ),
                    child: Text(
                      statusFilter[index]['name']!,
                      style: TextStyle(
                        color: _selectedMenu == index
                            ? Colors.white
                            : Colors.black,
                        fontSize: width * 0.04, // responsivo
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: width * 0.025), // antes 10
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05), // antes 20
            decoration: BoxDecoration(
              color: Color(0xFFD6EAF8).withAlpha(50),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: gradesState.isEmpty
                ? Center(
                    child: Text(
                      'No hay notas',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: width * 0.05, // antes 20
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
