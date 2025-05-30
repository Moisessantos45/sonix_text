import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigation extends StatelessWidget {
  const CustomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

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
                blurRadius: screenWidth * 0.025, // era 10
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: const Color(0xFF2C80B4),
                  size: screenWidth * 0.06, // ajuste para el tamaño del icono
                ),
                onPressed: () => context.go("/"),
              ),
              IconButton(
                icon: Icon(
                  Icons.check_circle,
                  color: const Color(0xFF2C80B4),
                  size: screenWidth * 0.06,
                ),
                onPressed: () {
                  context.go("/progress");
                },
              ),
              SizedBox(width: screenWidth * 0.1), // era 40
              IconButton(
                icon: Icon(
                  Icons.stacked_bar_chart,
                  color: const Color(0xFF2C80B4),
                  size: screenWidth * 0.06,
                ),
                onPressed: () {
                  context.go("/statistics");
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: const Color(0xFF2C80B4),
                  size: screenWidth * 0.06,
                ),
                onPressed: () => context.go("/profile"),
              ),
            ],
          ),
        ));
  }
}
