class Employee {
  final String id;
  final String fullName;
  final String department;
  final String position;
  final String email;
  final String phone;
  final int leaveBalance;
  final String managerName;
  final bool isActive;

  const Employee({
    required this.id,
    required this.fullName,
    required this.department,
    required this.position,
    required this.email,
    required this.phone,
    required this.leaveBalance,
    required this.managerName,
    required this.isActive,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    // bug3: Corrected employee JSON keys mapping (e.g. name to fullName, leave_balance to leaveBalance) and added null safety fallback for phone numbers
    return Employee(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      department: json['department'] as String,
      position: json['position'] as String,
      email: json['email'] as String,
      phone: (json['phone'] as String?) ?? 'N/A',
      leaveBalance: json['leaveBalance'] as int,
      managerName: json['managerName'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}
