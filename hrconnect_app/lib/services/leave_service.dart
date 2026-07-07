import 'package:flutter/foundation.dart';
import '../data/mock_hr_data.dart';
import '../models/employee.dart';
import '../models/leave_request.dart';

class LeaveService {
  // bug16: Made requests list static and added ValueNotifier to persist and synchronize pending leave counts
  static final List<LeaveRequest> _requests = [];
  static final ValueNotifier<int> pendingCountNotifier = ValueNotifier(0);

  List<LeaveRequest> get requests => List.unmodifiable(_requests);

  String submitLeave({
    required Employee employee,
    required LeaveRequest request,
  }) {
    if (request.endDate.isBefore(request.startDate)) {
      throw Exception('End date cannot be before start date.');
    }

    // bug13: Fixed balance check operator (changed from '<' to '>') to enforce enough balance is available
    if (request.totalDays > employee.leaveBalance) {
      throw Exception('Not enough leave balance.');
    }

    if (request.reason.trim().isEmpty) {
      throw Exception('Reason is required.');
    }

    // bug15: Mutate the leave balance inside mock data to persist deduction
    final index = mockEmployees.indexWhere((e) => e['id'] == employee.id);
    if (index != -1) {
      final currentBalance = mockEmployees[index]['leaveBalance'] as int;
      mockEmployees[index]['leaveBalance'] = currentBalance - request.totalDays;
    }

    _requests.add(request);
    // bug16: Update notifier value on new request submission
    pendingCountNotifier.value = _requests.where((r) => r.status == 'Pending').length;
    return 'Leave application submitted successfully.';
  }
}
