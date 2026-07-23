import 'package:flutter/material.dart';
import 'package:united_app/firebase/firebase_functions.dart';
import 'package:united_app/pages/finance_transaction_page.dart';



class FinanceDayPage extends StatelessWidget {
  final int year;
  final int month;

  const FinanceDayPage({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_monthName(month)} $year"),
      ),
      body: StreamBuilder<List<int>>(
        stream: FirestoreService().getDays(year, month),
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

          final days = snapshot.data!;

          if (days.isEmpty) {
            return const Center(
              child: Text("No Days Found"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(day.toString()),
                  ),
                  title: Text(
                    "$day ${_monthName(month)}",
                  ),
                  subtitle: Text(year.toString()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FinanceTransactionsPage(
                          year: year,
                          month: month,
                          day: day,
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