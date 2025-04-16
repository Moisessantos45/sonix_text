import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonix_text/config/helper/page_router.dart';
import 'package:sonix_text/presentation/screens/grade.dart';
class CustomNavigation extends StatelessWidget {
  const CustomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        shadowColor: const Color(0xFF3498DB),
        surfaceTintColor: Colors.grey[400],
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => context.go("/"),
              ),
              IconButton(
                icon: const Icon(Icons.stacked_bar_chart),
                onPressed: () {
                  context.go("/statistics");
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.notes),
                onPressed: () {
                  Navigator.push(
                    context,
                    CustomPageRoute(page: const GradeScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => context.go("/profile"),
              ),
            ],
          ),
        ));
  }
}
