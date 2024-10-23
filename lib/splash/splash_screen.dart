import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thrombosis/auth/register_screen.dart';
import 'package:thrombosis/bottum_nav/bottum_nav_bar.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkRegistrationStatus();
  }

  // Check if the user is registered
  Future<void> _checkRegistrationStatus() async {
    final userBox = Hive.box('userBox');
    final bool? isRegistered = userBox.get('isRegistered', defaultValue: false);

    Future.delayed(const Duration(seconds: 3), () {
      if (isRegistered == true) {
        // Navigate to BottomNavBar if registered
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottumNavBar()),
        );
      } else {
        // Navigate to RegisterScreen if not registered
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Section
            CircleAvatar(
              backgroundImage: AssetImage('assets/logo/index-logo.jpg'),
              radius: 150.r,
            ),
            SizedBox(height: 30.h),
            // App Title
            Text(
              "Thrombosis App",
              style: GoogleFonts.poppins(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 12.h),
            // Subtitle
            Text(
              "Managing Your Health",
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
