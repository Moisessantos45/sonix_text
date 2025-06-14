import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/helper/page_router.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_level.dart';
import 'package:sonix_text/presentation/screens/reward.dart';

class CardLevelWidget extends ConsumerStatefulWidget {
  const CardLevelWidget({super.key});

  @override
  ConsumerState<CardLevelWidget> createState() => _CardLevelWidgetState();
}

class _CardLevelWidgetState extends ConsumerState<CardLevelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _glowOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _glowOpacityAnimation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLevel = ref.watch(currentLevelProvider);
    final int nextRewardPoints = ref.watch(pointsLevelProvider);
    final int totalPoints = ref.watch(statsProvider).score;
    final bool isLevelUp =
        totalPoints >= nextRewardPoints && currentLevel?.isClaimed == false;

    if (isLevelUp && !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 16),
      child: GestureDetector(
        onTap: () {
          if (isLevelUp) {
            Navigator.push(
                context, CustomPageRoute(page: const RewardScreen()));
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: isLevelUp
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3498DB).withAlpha(
                              (_glowOpacityAnimation.value * 255).toInt()),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: Transform.scale(
                scale: isLevelUp ? _scaleAnimation.value : 1.0,
                child: Container(
                  height: 140,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isLevelUp
                          ? [
                              const Color(0xFF3498DB),
                              const Color(0xFF2980B9),
                            ]
                          : [
                              const Color(0xFF1ABC9C),
                              const Color(0xFF1ABC9C),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: isLevelUp
                            ? const Color(0xFF3498DB).withAlpha(30)
                            : const Color(0xFF34495E).withAlpha(30),
                        blurRadius: isLevelUp ? _glowAnimation.value : 8,
                        spreadRadius: isLevelUp ? _glowAnimation.value / 2 : 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isLevelUp ? Icons.check_circle : Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isLevelUp ? "¡Nivel Completado!" : "Nivel Actual",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                isLevelUp ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(isLevelUp ? 40 : 20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Nivel ${currentLevel?.level}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$totalPoints pts",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$nextRewardPoints pts",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CircularProgressIndicator(
                    value: totalPoints / nextRewardPoints,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF3498DB)),
                    strokeWidth: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
