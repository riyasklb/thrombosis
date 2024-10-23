import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrombosis/bottum_nav/bottum_nav_bar.dart';


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
            children: [
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

  // Save data to Hive
  Future<void> _saveData(BuildContext context) async {
    final userBox = Hive.box('userBox'); // Open the user box

    // Store the user data in a map
    final userData = {
      'username': usernameController.text,
      'email': emailController.text,
      'age': ageController.text,
      'mobile': mobileController.text,
      'nhsNumber': nhsNumberController.text,
      'gender': selectedGender,
    };

    // Save the data in Hive
    await userBox.put('userData', userData);

    // Save registration flag
    await userBox.put('isRegistered', true);

    // Print success message
    print("User data saved: $userData");

    // Navigate to BottomNavBar after successful registration
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottumNavBar()),
    );
  }
}
