import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:thrombosis/model/hive_model.dart';
import 'package:thrombosis/views/callender_screen.dart';
import 'package:thrombosis/views/show_whole%20activity_screen.dart/dummy.dart';

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
         style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      leading: InkWell(onTap: (){Get.to(ActivityCalendarScreen());},
        child: Icon(Icons.calendar_month,color: Colors.white,)),),
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

                      return InkWell(onTap: (){
                        Get.to(ActivityScreen());
                      },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10.h),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.fitness_center, color: Colors.blueAccent, size: 30),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'Day ${index + 1}',
                                      style: GoogleFonts.lato(fontSize: 24.sp, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Divider(color: Colors.grey.shade300),
                                SizedBox(height: 10.h),
                                Text('Walking: ${activity?.minutesWalked} minutes', 
                                    style: GoogleFonts.lato(fontSize: 18.sp)),
                                Text('Sleep: ${activity?.hoursSlept} hours', 
                                    style: GoogleFonts.lato(fontSize: 18.sp)),
                                Text('Water: ${activity?.waterIntake} liters', 
                                    style: GoogleFonts.lato(fontSize: 18.sp)),
                                SizedBox(height: 10.h),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Logged on: ${activity?.date?.toLocal().toString().split(' ')[0]}',
                                    style: GoogleFonts.lato(fontSize: 14.sp, fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            ),
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
