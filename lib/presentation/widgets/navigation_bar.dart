import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigation extends StatelessWidget {
  const CustomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        shadowColor: const Color(0xFF3498DB),
        surfaceTintColor: Color(0xFFD6EAF8).withAlpha(50),
        color: Color(0xFFD6EAF8).withAlpha(50),        
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
                icon: const Icon(
                  Icons.home,
                  color: Color(0xFF2C80B4),
                ),
                onPressed: () => context.go("/"),
              ),
              IconButton(
                icon: const Icon(Icons.check_circle, color: Color(0xFF2C80B4)),
                onPressed: () {
                  context.go("/progress");
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.stacked_bar_chart,
                    color: Color(0xFF2C80B4)),
                onPressed: () {
                  context.go("/statistics");
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Color(0xFF2C80B4)),
                onPressed: () => context.go("/profile"),
              ),
            ],
          ),
        ));
  }
}
