import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_level.dart';

class CarouselCard extends ConsumerWidget {
  const CarouselCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listCard = ref.watch(listCardsProvider);
    final int nextRewardPoints = ref.watch(pointsLevelProvider);
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04), // antes 15
          child: Text(
            'Tu progreso académico',
            style: TextStyle(
              fontSize: width * 0.05, // antes 20
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
        ),
        SizedBox(
            height: width * 0.45, // antes 175
            width: double.infinity,
            child: ListView.builder(
              itemCount: listCard.length,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final card = listCard[index];
                return _buildAnimatedCard(
                  context,
                  card.title,
                  card.subTitle,
                  card.icon,
                  card.primaryColor,
                  card.secundaryColor,
                  card.content,
                );
              },
            ))
      ],
    );
  }

  Widget _buildAnimatedCard(
    BuildContext context,
    String title,
    String subTitle,
    IconData icon,
    int color,
    int twoColor,
    String description,
  ) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.012, // antes 5.0
        vertical: width * 0.035, // antes 14.0
      ),
      child: Container(
        width: width * 0.55, // antes 210
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(color), Color(twoColor)],
          ),
          borderRadius: BorderRadius.circular(width * 0.05), // antes 20
          boxShadow: [
            BoxShadow(
              color: Color(color).withAlpha(40),
              blurRadius: width * 0.03, // antes 12
              offset: Offset(0, width * 0.02), // antes Offset(0, 8)
              spreadRadius: width * 0.005, // antes 2
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: width * -0.05, // antes -20
              top: width * -0.05, // antes -20
              child: Container(
                width: width * 0.25, // antes 100
                height: width * 0.25, // antes 100
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04, // antes 15
                vertical: width * 0.012, // antes 5
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(width * 0.02), // antes 8
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          borderRadius:
                              BorderRadius.circular(width * 0.03), // antes 12
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: width * 0.11, // antes 45
                        ),
                      ),
                      SizedBox(width: width * 0.03), // antes 12
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: width * 0.1, // antes 40
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.012), // antes 5
                  Text(
                    subTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.05, // antes 20
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: width * 0.025), // antes 10
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withAlpha(500),
                      fontSize: width * 0.035, // antes 14
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
