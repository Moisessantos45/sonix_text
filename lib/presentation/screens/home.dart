import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonix_text/config/helper/page_router.dart';
import 'package:sonix_text/presentation/riverpod/repository_user.dart';
import 'package:sonix_text/presentation/screens/screens.dart';
import 'package:sonix_text/presentation/widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final nickName = user.isEmpty ? 'Usuario' : user.first.nickname;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
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
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications,
                        color: Color(0xFF2C80B4)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(page: const NotificationsScreen()),
                      );
                    },
                  ),
                ],
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
            CardLevelWidget(),
            InkWell(
              onTap: () {
                context.go('/statistics');
              },
              child: Builder(
                builder: (context) {
                  final width = MediaQuery.of(context).size.width;
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: width * 0.025, // antes 10
                      horizontal: width * 0.05, // antes 20
                    ),
                    padding: EdgeInsets.all(width * 0.04), // antes 15
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(width * 0.04), // antes 15
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(100),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.bar_chart,
                                color: Color(0xFF3498DB), size: width * 0.08),
                            SizedBox(height: width * 0.02),
                            const Text(
                              'Ver estadísticas',
                              style: TextStyle(
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: GradeDisplayWidget(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3498DB),
        onPressed: () {
          context.push("/add_note/0");
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
