import 'dart:math';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:thrombosis/bottum_nav/dummy.dart';
import 'package:thrombosis/constans/color.dart';
import 'package:thrombosis/views/acitivity_screen.dart';
import 'package:thrombosis/views/dashboard_screen.dart';
import 'package:thrombosis/views/profile_screen.dart';

class BottumNavBar extends StatefulWidget {
  const BottumNavBar({Key? key}) : super(key: key);

  @override
  State<BottumNavBar> createState() => _BottumNavBarState();
}

class _BottumNavBarState extends State<BottumNavBar> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
    DashboardScreen(),
     
      DailyActivitiesScreen(),
      ProfileScreen(),
      EducationalResourcesScreen(),
     
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: kblue,
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 1,
              kBottomRadius: 28.0,
              showShadow: true,
              notchShader: SweepGradient(
                startAngle: 0,
                endAngle: pi / 2,
                colors: [kblue, kblue, kblue],
                tileMode: TileMode.mirror,
              ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
              notchColor: Colors.black87,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,

              durationInMilliSeconds: 300,

              itemLabelStyle: const TextStyle(fontSize: 10),

              elevation: 1,
              bottomBarItems: [
               
                BottomBarItem(
                  inActiveItem: Icon(Icons.dashboard, color: kwhite),
                  activeItem: Icon(Icons.dashboard, color: kwhite),
                 
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.fitness_center, color: kwhite),
                  activeItem: Icon(Icons.fitness_center, color: kwhite),
            
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.person, color: kwhite),
                  activeItem: Icon(Icons.person, color: kwhite),
             
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.menu_book, color: kwhite),
                  activeItem: Icon(Icons.menu_book, color: kwhite),
                 
                ),
              ],
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}
