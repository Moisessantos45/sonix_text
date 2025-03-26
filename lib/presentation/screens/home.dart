import 'package:flutter/material.dart';
import 'package:sonix_text/config/helper/page_router.dart';
import 'package:sonix_text/presentation/screens/voicce_text.dart';
import 'package:sonix_text/presentation/widgets/card_level.dart';
import 'package:sonix_text/presentation/widgets/carrusel_card.dart';
import 'package:sonix_text/presentation/widgets/home/grade.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: AppBar(
                title: const Text(
                  'Mis Notas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                    fontSize: 26,
                    letterSpacing: 0.5,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white.withAlpha(80),
                surfaceTintColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                actions: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3E50).withAlpha(10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CustomPageRoute(page: const VoiceTextScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFF2C3E50),
                        size: 45,
                      ),
                    ),
                  )
                ],
              ))),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            CarouselCard(),
            CardLevelWidget(),
            Expanded(
              child: GradeDisplayWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
