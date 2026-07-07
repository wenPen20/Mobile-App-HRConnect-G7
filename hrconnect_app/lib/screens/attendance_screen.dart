import 'package:flutter/material.dart';

import '../data/mock_hr_data.dart';
import '../models/app_user.dart';
import '../models/attendance.dart';
import '../services/employee_service.dart';

class AttendanceScreen extends StatelessWidget {
  final AppUser user;

  const AttendanceScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final employeeService = const EmployeeService();
    final records = mockAttendance.map(Attendance.fromJson).where((record) {
      if (user.isHr) return true;
      // bug12: Correctly filter attendance records by matching employeeId instead of user.id
      return record.employeeId == user.employeeId;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: records.isEmpty
          ? const Center(child: Text('No attendance records found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                final employee = employeeService.getEmployeeById(
                  record.employeeId,
                );
                return Card(
                  child: ListTile(
                    leading: Icon(
                      // bug17: Map attendance statuses (Late, Absent, Present) to their respective icons
                      record.isLate
                          ? Icons.warning_amber
                          : record.isAbsent
                              ? Icons.cancel_outlined
                              : Icons.check_circle,
                    ),
                    title: Text(employee?.fullName ?? record.employeeId),
                    subtitle: Text(
                      // bug1: Formatted date string with a newline escape character
                      '${record.date.year}-${record.date.month.toString().padLeft(2, '0')}-${record.date.day.toString().padLeft(2, '0')}\n'
                      'In: ${record.checkIn} | Out: ${record.checkOut}',
                    ),
                    trailing: Text(record.status),
                  ),
                );
              },
            ),
    );
  }
}
