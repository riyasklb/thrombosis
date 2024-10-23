// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:thrombosis/model/hive_model.dart';

// class ActivityBarChart extends StatelessWidget {
//   final List<ActivityModel> activities;

//   ActivityBarChart({required this.activities});

//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         barGroups: activities.asMap().entries.map((entry) {
//           int index = entry.key;
//           ActivityModel activity = entry.value;

//           return BarChartGroupData(
//             x: index,
//             barRods: [
//               BarChartRodData(
//                 toY: activity.minutesWalked.toDouble(), // Use toY instead of y
//                 width: 15.w,
//                 color: [Colors.blueAccent],
//               ),
//             ],
//           );
//         }).toList(),
//         titlesData: FlTitlesData(
//           bottomTitles: SideTitles(
//             showTitles: true,
//             getTextStyles: (context, value) => TextStyle(color: Colors.black, fontSize: 10.sp),
//             getTitles: (double value) {
//               return 'Day ${value.toInt() + 1}';
//             },
//           ),
//           leftTitles: SideTitles(showTitles: true),
//         ),
//       ),
//     );
//   }
// }
