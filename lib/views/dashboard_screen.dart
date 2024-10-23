import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:thrombosis/model/hive_model.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Box<ActivityModel> _activityBox;

  @override
  void initState() {
    super.initState();
    _activityBox = Hive.box<ActivityModel>('activityBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.lato(fontSize: 22.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Activities Overview',
              style: GoogleFonts.lato(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),

            // Displaying the activities using a ListView
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _activityBox.listenable(),
                builder: (context, Box<ActivityModel> box, _) {
                  if (box.values.isEmpty) {
                    return Center(
                      child: Text(
                        'No activities logged yet.',
                        style: GoogleFonts.lato(fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final activity = box.getAt(index);

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        child: ListTile(
                          leading: Icon(Icons.fitness_center, color: Colors.blueAccent),
                          title: Text(
                            'Day ${index + 1}',
                            style: GoogleFonts.lato(fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Walking: ${activity?.minutesWalked} minutes', style: GoogleFonts.lato(fontSize: 16.sp)),
                              Text('Sleep: ${activity?.hoursSlept} hours', style: GoogleFonts.lato(fontSize: 16.sp)),
                              Text('Water: ${activity?.waterIntake} liters', style: GoogleFonts.lato(fontSize: 16.sp)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
