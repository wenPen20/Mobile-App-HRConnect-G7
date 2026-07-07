import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/employee_service.dart';
import '../widgets/employee_card.dart';

class EmployeeListScreen extends StatefulWidget {
  final AppUser user;

  const EmployeeListScreen({super.key, required this.user});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final _service = const EmployeeService();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final employees = _service.searchEmployees(_query);

    return Scaffold(
      appBar: AppBar(title: const Text('Employee Directory')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name, department, or position',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // bug8: Re-trigger build (setState) on query change to filter search list
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          // bug6: Wrap ListView.builder in Expanded so it layouts correctly inside a Column
          Expanded(
            child: ListView.builder(
            itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return EmployeeCard(
                  employee: employee,
                  onTap: () {
                    // bug7: Fixed routing name to '/employee-details' and passed the whole employee object instead of just the ID
                    Navigator.pushNamed(
                      context,
                      '/employee-details',
                      arguments: employee,
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
