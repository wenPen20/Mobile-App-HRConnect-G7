import '../data/mock_hr_data.dart';
import '../models/employee.dart';
import '../models/leave_request.dart';

class LeaveService {
  final List<LeaveRequest> _requests = [];

  List<LeaveRequest> get requests => List.unmodifiable(_requests);

  String submitLeave({
    required Employee employee,
    required LeaveRequest request,
  }) {
    if (request.endDate.isBefore(request.startDate)) {
      throw Exception('End date cannot be before start date.');
    }

    if (request.totalDays > employee.leaveBalance) {
      throw Exception('Not enough leave balance.');
    }

    if (request.reason.trim().isEmpty) {
      throw Exception('Reason is required.');
    }

    final index = mockEmployees.indexWhere((e) => e['id'] == employee.id);
    if (index != -1) {
      final currentBalance = mockEmployees[index]['leaveBalance'] as int;
      mockEmployees[index]['leaveBalance'] = currentBalance - request.totalDays;
    }

    _requests.add(request);
    return 'Leave application submitted successfully.';
  }
}
