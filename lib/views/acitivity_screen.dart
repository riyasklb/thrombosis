import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thrombosis/model/hive_model.dart';

class DailyActivitiesScreen extends StatefulWidget {
  @override
  _DailyActivitiesScreenState createState() => _DailyActivitiesScreenState();
}

class _DailyActivitiesScreenState extends State<DailyActivitiesScreen> {
  final TextEditingController _walkingController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();
  final TextEditingController _waterIntakeController = TextEditingController();

  late Box<ActivityModel> _activityBox;

  @override
  void initState() {
    super.initState();
    _activityBox = Hive.box<ActivityModel>('activityBox');
  }

  @override
  void dispose() {
    _walkingController.dispose();
    _sleepController.dispose();
    _waterIntakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Activities',
          style: GoogleFonts.lato(fontSize: 22.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log Your Activities',
              style: GoogleFonts.lato(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            _buildActivityInput(
              label: 'Minutes Walked',
              hintText: 'Enter minutes walked',
              controller: _walkingController,
              icon: Icons.directions_walk,
            ),
            SizedBox(height: 20.h),
            _buildActivityInput(
              label: 'Hours Slept',
              hintText: 'Enter hours slept',
              controller: _sleepController,
              icon: Icons.bed,
            ),
            SizedBox(height: 20.h),
            _buildActivityInput(
              label: 'Water Intake (Liters)',
              hintText: 'Enter water intake in liters',
              controller: _waterIntakeController,
              icon: Icons.local_drink,
            ),
            SizedBox(height: 40.h),
            Center(
              child: ElevatedButton(
                onPressed: _submitActivities,
                child: Text(
                  'Submit',
                  style: GoogleFonts.lato(fontSize: 18.sp),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to create input fields for activities
  Widget _buildActivityInput({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.blue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }

void _submitActivities() {
  final String walking = _walkingController.text;
  final String sleep = _sleepController.text;
  final String waterIntake = _waterIntakeController.text;

  if (walking.isNotEmpty && sleep.isNotEmpty && waterIntake.isNotEmpty) {
    final activity = ActivityModel(
      int.parse(walking),
      int.parse(sleep),
      double.parse(waterIntake),
      DateTime.now(), // Capture the current date
    );

    _activityBox.add(activity); // Save to Hive

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Activities logged successfully!')),
    );

    _walkingController.clear();
    _sleepController.clear();
    _waterIntakeController.clear();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in all fields')),
    );
  }
}

}
