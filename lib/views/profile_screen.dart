import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thrombosis/tools/constans/model/profile_model.dart';
import 'package:thrombosis/tools/constans/color.dart';
import 'auth/register_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileBox = Hive.box<ProfileModel>('profileBox');
    final ProfileModel? profileData = profileBox.get('userProfile'); // Fetch ProfileModel

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
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
              _buildProfileCard('Username', profileData?.username),
              _buildProfileCard('Email', profileData?.email),
              _buildProfileCard('Age', profileData?.age.toString()),
              _buildProfileCard('Mobile', profileData?.mobile),
              _buildProfileCard('NHS Number', profileData?.nhsNumber),
              _buildProfileCard('Gender', profileData?.gender),

              SizedBox(height: 30.h),

              // Logout Button
              ElevatedButton(
                onPressed: () async {
                  // Clear user profile from Hive
                  await profileBox.delete('userProfile');

                  // Navigate to Register Screen
                  Get.offAll(() => RegisterScreen());
                },
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
              kheight40,
              kheight40,
            ],
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
}
