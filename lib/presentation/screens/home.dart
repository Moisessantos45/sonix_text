import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/helper/page_router.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_level.dart';
import 'package:sonix_text/presentation/riverpod/repository_user.dart';
import 'package:sonix_text/presentation/screens/voicce_text.dart';
import 'package:sonix_text/presentation/widgets/card_level.dart';
import 'package:sonix_text/presentation/widgets/carrusel_card.dart';
import 'package:sonix_text/presentation/widgets/home/grade.dart';
import 'package:sonix_text/presentation/widgets/navigation_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _onInit() async {
    await ref.read(levelNotifierProvider.notifier).getLevels();
    await ref.read(userNotifierProvider.notifier).getUsers();
    await ref.read(allGradesProvider.notifier).loadGrades();
  }

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final nickName = user.isEmpty ? 'Usuario' : user.first.nickname;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: AppBar(
                title: Text(
                  'Mis Notas $nickName',
                  style: const TextStyle(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3498DB),
        onPressed: () {
          Navigator.push(
            context,
            CustomPageRoute(page: const VoiceTextScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomNavigation(),
    );
  }
}
