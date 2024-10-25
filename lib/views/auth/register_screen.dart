import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrombosis/views/bottum_nav/bottum_nav_bar.dart';
import 'package:thrombosis/tools/constans/color.dart';
import 'package:thrombosis/tools/constans/model/profile_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); 
 // Form key for validation
  final TextEditingController emailController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController nhsNumberController = TextEditingController();

  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kwhite,
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
          child: Form(
            key: _formKey, // Attach the form key here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                CircleAvatar(backgroundImage: AssetImage('assets/logo/rb_2147993862.png'),radius: 150.r,),
                
                SizedBox(height: 40.h),
                _buildTextField(
                  controller: usernameController,
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  icon: Icons.person,
                  validator: (value) =>
                      value!.isEmpty ? 'Username cannot be empty' : null,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  icon: Icons.email,
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Email cannot be empty';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: ageController,
                  labelText: 'Age',
                  hintText: 'Enter your age',
                  icon: Icons.cake,
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Age cannot be empty';
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Enter a valid age';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: mobileController,
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  icon: Icons.phone,
                  inputType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) return 'Mobile number cannot be empty';
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: nhsNumberController,
                  labelText: 'NHS Number',
                  hintText: 'Enter your NHS number',
                  icon: Icons.verified,
                  inputType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'NHS number cannot be empty' : null,
                ),
                SizedBox(height: 16.h),
                _buildGenderDropdown(),
                SizedBox(height: 30.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          selectedGender != null) {
                        _saveData(context);
                      } else if (selectedGender == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select a gender'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.w, vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
           kheight40,kheight40   ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper to build TextFields with validation
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
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
      validator: validator,
    );
  }

  // Helper to build Gender Dropdown with validation
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
    final profileBox = Hive.box<ProfileModel>('profileBox');
    final settingsBox = Hive.box('settingsBox');

    final profile = ProfileModel()
      ..username = usernameController.text
      ..email = emailController.text
      ..age = int.parse(ageController.text)
      ..mobile = mobileController.text
      ..nhsNumber = nhsNumberController.text
      ..gender = selectedGender ?? 'Not specified';

    await profileBox.put('userProfile', profile);
    await settingsBox.put('isRegistered', true);

    print("Profile data saved: ${profile.username}");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottumNavBar()),
    );
  }
}
