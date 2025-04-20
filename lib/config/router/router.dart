import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonix_text/config/helper/shared_preferents.dart';
import 'package:sonix_text/presentation/screens/home.dart';
import 'package:sonix_text/presentation/screens/onboarding.dart';
import 'package:sonix_text/presentation/screens/profile.dart';
import 'package:sonix_text/presentation/screens/statistics.dart';

Future<bool> checkForRedirect() async {
  final sharedPreferents = SharedPreferentsManager();
  try {
    final data = await sharedPreferents.getData("isRegistered");

    return data;
  } catch (e) {
    return false;
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: "/",
        redirect: (context, state) async {
          final isRedirect = await checkForRedirect();
          if (isRedirect) {
            return "/";
          }
          return "/onboarding";
        },
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            })),
    GoRoute(
      path: "/onboarding",
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen(),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: "/statistics",
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const StatisticsScreen(),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: "/profile",
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ProfileScreen(),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      ),
    )
  ],
);
