import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/widgets/widgets.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refreshData() async {
    await ref.read(statsProvider.notifier).getStats();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final grades = ref.watch(allGradesProvider);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text('Mis Estadisticas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                fontSize: width * 0.065, // antes 26
                letterSpacing: 0.5,
              )),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(width * 0.05), // antes 20
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    CarouselCard(),
                    SizedBox(height: width * 0.13), // antes 30
                    grades.isEmpty
                        ? Center(
                            child: Text(
                              'No hay notas registradas',
                              style: TextStyle(
                                fontSize: width * 0.04, // antes 16
                                color: Color(0xFF7F8C8D),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: constraints.maxHeight * 0.55,
                            child: PieChartWidget(),
                          ),
                    SizedBox(height: width * 0.05), // antes 20
                    Text(
                      'Notas por dia',
                      style: TextStyle(
                        fontSize: width * 0.06, // antes 24
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    grades.isEmpty
                        ? Center(
                            child: Text(
                              'No hay notas registradas',
                              style: TextStyle(
                                fontSize: width * 0.04, // antes 16
                                color: Color(0xFF7F8C8D),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: constraints.maxHeight * 0.4,
                            child: BarChartWidget(grades: [...grades]),
                          ),
                    SizedBox(height: width * 0.05), // antes 20
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF3498DB),
          onPressed: () {
            context.push("/add_note/0");
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: width * 0.08, // antes tamaño por defecto
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomNavigation());
  }
}
