import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thrombosis/tools/constans/color.dart';
import 'package:thrombosis/tools/constans/model/hive_model.dart';
import 'package:thrombosis/tools/constans/model/profile_model.dart';
import 'auth/register_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileBox = Hive.box<ProfileModel>('profileBox');
    final activityBox = Hive.box<ActivityModel>('activityBox');
    final settingsBox = Hive.box('settingsBox');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 8,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),

              // Profile Avatar
              CircleAvatar(
                radius: 60.r,
                backgroundColor: Colors.blueAccent.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  size: 80.r,
                  color: Colors.blueAccent,
                ),
              ),

              SizedBox(height: 20.h),

              // Profile Data Cards
              _buildProfileCard('Username', profileBox.get('userProfile')?.username),
              _buildProfileCard('Email', profileBox.get('userProfile')?.email),
              _buildProfileCard('Age', profileBox.get('userProfile')?.age.toString()),
              _buildProfileCard('Mobile', profileBox.get('userProfile')?.mobile),
              _buildProfileCard('NHS Number', profileBox.get('userProfile')?.nhsNumber),
              _buildProfileCard('Gender', profileBox.get('userProfile')?.gender),

              SizedBox(height: 30.h),

              // Logout Button with Confirmation
              ElevatedButton(
                onPressed: () => _showLogoutConfirmation(context, profileBox, activityBox, settingsBox),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 8,
                ),
                child: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 40.h),
           kheight40 ,kheight40  ],
          ),
        ),
      ),
    );
  }

  // Helper to build profile data cards
  Widget _buildProfileCard(String label, String? value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(
              _getIconForLabel(label),
              size: 28.r,
              color: Colors.blueAccent,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value ?? 'Not Available',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
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

  // Helper to get icons for each label
  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Username':
        return Icons.person;
      case 'Email':
        return Icons.email;
      case 'Age':
        return Icons.cake;
      case 'Mobile':
        return Icons.phone;
      case 'NHS Number':
        return Icons.verified;
      case 'Gender':
        return Icons.people;
      default:
        return Icons.info;
    }
  }

  // Show logout confirmation dialog with option to clear all data
  void _showLogoutConfirmation(
      BuildContext context, Box profileBox, Box activityBox, Box settingsBox) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout and Clear Data'),
          content: const Text(
              'Are you sure you want to log out and clear all data? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Clear all Hive boxes
                await profileBox.clear();
                await activityBox.clear();
                await settingsBox.clear();

                // Navigate to RegisterScreen
                Get.offAll(() => RegisterScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Logout and Clear Data',style:TextStyle(color: Colors.white) ,),
            ),
        ],
        );
      },
    );
  }
}
