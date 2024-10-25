import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:hive/hive.dart';
import 'package:thrombosis/tools/constans/color.dart';
import 'package:thrombosis/tools/constans/model/hive_model.dart';
import 'package:thrombosis/tools/constans/model/profile_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PdfGenaerateScreen extends StatefulWidget {
  @override
  _PdfGenaerateScreenState createState() => _PdfGenaerateScreenState();
}

class _PdfGenaerateScreenState extends State<PdfGenaerateScreen> {
  late Box<ActivityModel> _activityBox;
  late Box<ProfileModel> _profileBox;
  ProfileModel? _profile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _activityBox = Hive.box<ActivityModel>('activityBox');
    _profileBox = Hive.box<ProfileModel>('profileBox');
    _profile = _profileBox.get('userProfile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: kwhite,
            )),
        title: Text(
          'Export Activities',
          style: GoogleFonts.poppins(
              fontSize: 24.sp, fontWeight: FontWeight.w600, color: kwhite),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/logo/rb_19305.png'),
                  Text(
                    'Export Reports',
                    style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: kblack),
                  ),
                  SizedBox(height: 10.h),
                  _buildExportButton(
                      context, '   Daily Report   ', _filterDailyData()),
                  SizedBox(height: 10.h),
                  _buildExportButton(
                      context, ' Weekly Report ', _filterWeeklyData()),
                  SizedBox(height: 10.h),
                  _buildExportButton(
                      context, 'Monthly Report', _filterMonthlyData()),
                  kheight10,
                  _buildOverviewSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildExportButton(
      BuildContext context, String label, List<ActivityModel> data) {
    return ElevatedButton(
      onPressed: data.isNotEmpty
          ? () => _generateAndSharePdf(data)
          : () {
              _showMessageDialog(context, 'No data available for $label');
            },
      style: ElevatedButton.styleFrom(
        elevation: 5,
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16.sp),
      ),
    );
  }

  List<ActivityModel> _filterDailyData() {
    String today = DateTime.now().toString().split(' ')[0];
    return _activityBox.values
        .where((activity) => activity.date.toString().split(' ')[0] == today)
        .toList();
  }

  List<ActivityModel> _filterWeeklyData() {
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));
    return _activityBox.values
        .where((activity) => activity.date.isAfter(sevenDaysAgo))
        .toList();
  }

  List<ActivityModel> _filterMonthlyData() {
    DateTime now = DateTime.now();
    return _activityBox.values
        .where((activity) =>
            activity.date.month == now.month && activity.date.year == now.year)
        .toList();
  }

  Future<void> _generateAndSharePdf(List<ActivityModel> activities) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(16.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Remove the logo section
                  pw.Text(
                    'Activity Report',
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  if (_profile != null) _buildPdfProfileSection(),
                  pw.SizedBox(height: 20),
                  ...activities
                      .map((activity) => _buildPdfRow(activity))
                      .toList(),
                  _buildPdfOverviewSection(),
                  _buildPdfConclusionSection(),
                ],
              ),
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/activity_report.pdf");
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)],
          text: 'Here is your activity report!');
    } catch (e) {
      _showMessageDialog(context, 'Error generating report: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    // Check if there are any activities
    if (_activityBox.isEmpty) {
      return Text(
        'No activities logged yet.',
        style: GoogleFonts.montserrat(color: Colors.red, fontSize: 16.sp),
      );
    }

    // Calculate total and average values for overview
    int totalActivities = _activityBox.length;
    double averageWalking = _activityBox.values
            .map((e) => e.minutesWalked)
            .reduce((a, b) => a + b) /
        totalActivities;
    double averageSleep =
        _activityBox.values.map((e) => e.hoursSlept).reduce((a, b) => a + b) /
            totalActivities;
    double averageWaterIntake =
        _activityBox.values.map((e) => e.waterIntake).reduce((a, b) => a + b) /
            totalActivities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Overview',
          style: GoogleFonts.montserrat(
              fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Text('Total Activities: $totalActivities',
            style: GoogleFonts.montserrat(fontSize: 16.sp)),
        Text(
            'Average Walking Time: ${averageWalking.toStringAsFixed(1)} minutes',
            style: GoogleFonts.montserrat(fontSize: 16.sp)),
        Text('Average Sleep: ${averageSleep.toStringAsFixed(1)} hours',
            style: GoogleFonts.montserrat(fontSize: 16.sp)),
        Text(
            'Average Water Intake: ${averageWaterIntake.toStringAsFixed(1)} liters',
            style: GoogleFonts.montserrat(fontSize: 16.sp)),
      ],
    );
  }

  pw.Widget _buildPdfRow(ActivityModel activity) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Date: ${activity.date.toString().split(' ')[0]}',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text('Walking: ${activity.minutesWalked} minutes'),
          pw.Text('Sleep: ${activity.hoursSlept} hours'),
          pw.Text('Water Intake: ${activity.waterIntake} liters'),
        ],
      ),
    );
  }

  pw.Widget _buildPdfProfileSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Profile Details',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Username: ${_profile!.username}'),
        pw.Text('NHS Number: ${_profile!.nhsNumber}'),
      ],
    );
  }

  pw.Widget _buildPdfConclusionSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20), // Add space before the conclusion
        pw.Text(
          'Conclusion',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Tracking your activities is essential for maintaining a healthy lifestyle. '
          'By monitoring your walking, sleep, and water intake, you can identify patterns '
          'that can help improve your well-being. Keep up the great work, and continue '
          'to prioritize your health!',
        ),
      ],
    );
  }

  pw.Widget _buildPdfOverviewSection() {
    int totalActivities = _activityBox.length;
    double averageWalking = _activityBox.values
            .map((e) => e.minutesWalked)
            .reduce((a, b) => a + b) /
        totalActivities;
    double averageSleep =
        _activityBox.values.map((e) => e.hoursSlept).reduce((a, b) => a + b) /
            totalActivities;
    double averageWaterIntake =
        _activityBox.values.map((e) => e.waterIntake).reduce((a, b) => a + b) /
            totalActivities;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Activity Overview',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Total Activities: $totalActivities'),
        pw.Text(
            'Average Walking Time: ${averageWalking.toStringAsFixed(1)} minutes'),
        pw.Text('Average Sleep: ${averageSleep.toStringAsFixed(1)} hours'),
        pw.Text(
            'Average Water Intake: ${averageWaterIntake.toStringAsFixed(1)} liters'),
      ],
    );
  }
}
