import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrombosis/bottum_nav/bottum_nav_bar.dart';
import 'package:thrombosis/constans/color.dart';
import 'package:thrombosis/model/profile_model.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController nhsNumberController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: GoogleFonts.poppins(
            fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [kheight40, Image   .network('https://personalpivots.com/wp-content/uploads/2022/08/activity-log-1024x1024.png'),kheight40, 
              _buildTextField(
                controller: usernameController,
                labelText: 'Username',
                hintText: 'Enter your username',
                icon: Icons.person,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                icon: Icons.email,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: ageController,
                labelText: 'Age',
                hintText: 'Enter your age',
                icon: Icons.cake,
                inputType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: mobileController,
                labelText: 'Mobile Number',
                hintText: 'Enter your mobile number',
                icon: Icons.phone,
                inputType: TextInputType.phone,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: nhsNumberController,
                labelText: 'NHS Number',
                hintText: 'Enter your NHS number',
                icon: Icons.verified,
                inputType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              _buildGenderDropdown(),
              SizedBox(height: 30.h),
              Center(
                child: ElevatedButton(
                  onPressed: () => _saveData(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build TextFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  // Helper to build Gender Dropdown
  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(Icons.people),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: ['Male', 'Female', 'Other'].map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender, style: GoogleFonts.poppins(fontSize: 16.sp)),
        );
      }).toList(),
      onChanged: (value) {
        selectedGender = value;
      },
    );
  }

  // Save data using ProfileModel to Hive
  Future<void> _saveData(BuildContext context) async {
    final profileBox = Hive.box<ProfileModel>('profileBox'); // Open the profile box
    final settingsBox = Hive.box('settingsBox'); // Use a separate box for flags

    // Create a new ProfileModel instance
    final profile = ProfileModel()
      ..username = usernameController.text
      ..email = emailController.text
      ..age = int.parse(ageController.text)
      ..mobile = mobileController.text
      ..nhsNumber = nhsNumberController.text
      ..gender = selectedGender ?? 'Not specified';

    // Save the profile data in Hive
    await profileBox.put('userProfile', profile);

    // Save registration flag in a separate box
    await settingsBox.put('isRegistered', true);

    // Print success message
    print("Profile data saved: ${profile.username}");

    // Navigate to BottomNavBar after successful registration
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottumNavBar()),
    );
  }
}
