import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thrombosis/constans/color.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box('userBox');
    final userData = userBox.get('userData', defaultValue: {});

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
            children: [kheight40,
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
              _buildProfileCard('Username', userData['username']),
              _buildProfileCard('Email', userData['email']),
              _buildProfileCard('Password', userData['password']),
              _buildProfileCard('Age', userData['age']),
              _buildProfileCard('Mobile', userData['mobile']),
              _buildProfileCard('NHS Number', userData['nhsNumber']),
              _buildProfileCard('Gender', userData['gender']),

              SizedBox(height: 30.h),

              // Logout Button
              ElevatedButton(
                onPressed: () async {
                  await userBox.delete('userData'); // Clear data
                  Navigator.pop(context); // Navigate back
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
          kheight40,kheight40,kheight40,  ],
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
      case 'Password':
        return Icons.lock;
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