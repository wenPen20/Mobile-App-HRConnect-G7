class Attendance {
  final String employeeId;
  final DateTime date;
  final String checkIn;
  final String checkOut;
  final String status;

  const Attendance({
    required this.employeeId,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      employeeId: json['employeeId'] as String,
      // bug3: Fixed JSON key mapping from 'dateTime' to 'date'
      date: DateTime.parse(json['date'] as String),
      checkIn: json['checkIn'] as String,
      checkOut: json['checkOut'] as String,
      status: json['status'] as String,
    );
  }

  bool get isLate => status.toLowerCase() == 'late';
  // bug17: Expose a helper to easily check if the employee was absent
  bool get isAbsent => status.toLowerCase() == 'absent';
}
