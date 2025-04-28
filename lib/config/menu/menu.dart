import 'package:flutter/material.dart';
import 'package:sonix_text/domains/entyti_menu.dart';

final List<EntytiMenu> menuItems = [
  EntytiMenu(text: "Home", icon: Icons.home, route: "/"),
  EntytiMenu(text:"Progress", icon: Icons.check_circle, route: "/progress"),
  EntytiMenu(text: "Onboarding", icon: Icons.person, route: "/onboarding"),
  EntytiMenu(text: "Statistics", icon: Icons.bar_chart, route: "/statistics"),
  EntytiMenu(text: "Profile", icon: Icons.person, route: "/profile"),
];
