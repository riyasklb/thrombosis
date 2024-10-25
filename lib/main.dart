import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:thrombosis/tools/constans/model/hive_model.dart';
import 'package:thrombosis/tools/constans/model/profile_model.dart';
import 'package:thrombosis/views/splash/splash_screen.dart';


void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityModelAdapter());
    Hive.registerAdapter(ProfileModelAdapter());
   
   await Hive.openBox<ProfileModel>('profileBox');
    await Hive.openBox<ActivityModel>('activityBox');
    await Hive.openBox('settingsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(500, 800), // Set the base design size
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(), // Apply Google Fonts globally
            primarySwatch: Colors.blue,
          ),
          home:  SplashScreen(), // Start with SplashScreen
        );
      },
    );
  }
}
