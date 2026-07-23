import 'package:flutter/material.dart';
import 'package:united_app/firebase/firebase_functions.dart';
import 'package:united_app/pages/finance_day_page.dart';


class FinanceMonthPage extends StatelessWidget {
  final int year;

  const FinanceMonthPage({
    super.key,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(year.toString()),
      ),
      body: StreamBuilder<List<int>>(
        stream: FirestoreService().getMonths(year),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final months = snapshot.data!;

          if (months.isEmpty) {
            return const Center(
              child: Text("No Months"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: months.length,
            itemBuilder: (context, index) {
              final month = months[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(_monthName(month)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FinanceDayPage(
                          year: year,
                          month: month,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return names[month];
  }
}