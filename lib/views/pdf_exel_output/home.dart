import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:thrombosis/tools/constans/color.dart';
import 'package:thrombosis/tools/constans/model/hive_model.dart';
import 'package:thrombosis/tools/constans/model/profile_model.dart';
import 'package:thrombosis/views/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<ActivityModel> _activityBox;

  @override
  void initState() {
    super.initState();
    _activityBox = Hive.box<ActivityModel>('activityBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(), // Using the new custom AppBar
      body: Padding(
        padding: EdgeInsets.all(16.w), // Responsive padding
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileCard(),
              SizedBox(height: 20.h), // Responsive spacing
              ValueListenableBuilder(
  valueListenable: _activityBox.listenable(),
  builder: (context, Box<ActivityModel> box, _) {
    // Check if the box is empty
    if (box.isEmpty) {
      return Center(
        child: Text(
          'No activities available.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    // Build the grid only if the box has data
    return _buildActivityGrid(box);
  },
),


              SizedBox(height: 20.h), // Responsive spacing
              _buildGraph(), // Graph showing activity trends
              kheight40, kheight40, kheight40, kheight40,
            ],
          ),
        ),
      ),
    );
  }

  // Modern Custom AppBar with Gradient and Icon Buttons
  AppBar _buildCustomAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
        ),
      ),
      toolbarHeight: 80.h, // Custom height for a larger app bar
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Activity ',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: 'Overview',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      elevation: 10, // Higher elevation for a bolder shadow effect
      shadowColor: Colors.blueAccent.withOpacity(0.4), // Custom shadow color
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
            size: 28.r, // Responsive icon size
          ),
          onPressed: () {
            // Notification functionality here
          },
        ),
        SizedBox(width: 10.w), // Space between icons
        IconButton(
          icon: Icon(
            Icons.dashboard,
            color: Colors.white,
            size: 28.r, // Responsive icon size
          ),
          onPressed: () {
            Get.to(DashboardScreen());
            // Settings functionality here
          },
        ),
        SizedBox(width: 10.w), // Add padding on the right side
      ],
      leading: Padding(
        padding:
            EdgeInsets.only(left: 12.w), // Responsive padding for the avatar
        child: CircleAvatar(
          radius: 24.r, // Responsive size for avatar
          backgroundImage: NetworkImage(
            'https://www.w3schools.com/w3images/avatar2.png', // Sample profile picture
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
    );
  }

  // Profile Card at the top of the screen
  Widget _buildProfileCard() {
    final profileBox = Hive.box<ProfileModel>('profileBox');
    final ProfileModel? profileData =
        profileBox.get('userProfile'); // Fetch ProfileModel
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r), // Responsive border radius
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w), // Responsive padding
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.r, // Responsive avatar size
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: Colors.blue,
                size: 50.r, // Responsive icon size
              ),
            ),
            SizedBox(width: 20.w), // Responsive spacing
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileData!.username,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Height: 182 cm  |  Weight: 76 kg',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp, // Responsive font size
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Build Grid for Activities
  Widget _buildActivityGrid(Box<ActivityModel> activityBox) {
    // Define lists for activities and colors
    List<String> activities = [
      'Water Intake',
      'Walking',
      'Sleep',
      'Calories Burned',
      'Running',
      'Cycling',
    ];

    List<Color> colors = [
      Colors.lightBlueAccent,
      Colors.greenAccent,
      Colors.deepPurpleAccent,
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.pinkAccent,
    ];

    // Get values from Hive or set default values
    List<String> values = [
      '${activityBox.getAt(0)?.waterIntake ?? 0} liters', // Water Intake
      '${activityBox.getAt(0)?.minutesWalked ?? 0} minutes', // Walking
      '${activityBox.getAt(0)?.hoursSlept ?? 0} hours', // Sleep
      '1,500 Kcal', // Calories Burned (static for now)
      '3.2 km', // Running (static for now)
      '10 km', // Cycling (static for now)
    ];

    return GridView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling inside GridView
      shrinkWrap: true, // Ensure GridView doesn't take infinite height
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns in the grid
        childAspectRatio: 1.5, // Adjust height/width ratio
        crossAxisSpacing: 10.w, // Responsive spacing between columns
        mainAxisSpacing: 10.h, // Responsive spacing between rows
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return _buildActivityCard(
          activities[index],
          values[index],
          colors[index],
        );
      },
    );
  }

// Activity Card for each metric in the grid
  Widget _buildActivityCard(String activity, String value, Color iconColor) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r), // Responsive border radius
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [iconColor.withOpacity(0.2), iconColor.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.r), // Responsive border radius
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _getActivityIcon(activity),
                color: iconColor,
                size: 40.r, // Responsive icon size
              ),
              SizedBox(height: 10.h), // Responsive spacing
              Text(
                activity,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp, // Responsive font size
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.h), // Responsive spacing
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp, // Responsive font size
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Icons for different activities
  IconData _getActivityIcon(String activity) {
    switch (activity) {
      case 'Water Intake':
        return Icons.local_drink;
      case 'Walking':
        return Icons.directions_walk;
      case 'Sleep':
        return Icons.bedtime;
      case 'Calories Burned':
        return Icons.local_fire_department;
      case 'Running':
        return Icons.directions_run;
      case 'Cycling':
        return Icons.pedal_bike;
      default:
        return Icons.accessibility;
    }
  }

  // Graph widget using fl_chart
  Widget _buildGraph() {
    return SizedBox(
      height: 250.h, // Responsive height
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(
            border: Border.all(
                color: Colors.grey, width: 1.w), // Responsive border width
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: true),
              spots: [
                FlSpot(0, 2),
                FlSpot(1, 3),
                FlSpot(2, 1.5),
                FlSpot(3, 4),
                FlSpot(4, 3.5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
