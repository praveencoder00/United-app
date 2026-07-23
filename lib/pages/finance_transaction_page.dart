import 'package:flutter/material.dart';
import 'package:united_app/firebase/firebase_functions.dart';

import '../models/finance_model.dart';


class FinanceTransactionsPage extends StatelessWidget {
  final int year;
  final int month;
  final int day;

  const FinanceTransactionsPage({
    super.key,
    required this.year,
    required this.month,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$day/${month.toString().padLeft(2, '0')}/$year"),
      ),
      body: StreamBuilder<List<FinanceModel>>(
        stream: FirestoreService().getTransactions(
          year,
          month,
          day,
        ),
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

          final transactions = snapshot.data!;

          if (transactions.isEmpty) {
            return const Center(
              child: Text("No Transactions"),
            );
          }

          double income = 0;
          double expense = 0;

          for (final t in transactions) {
            if (t.type == "income") {
              income += t.amount;
            } else {
              expense += t.amount;
            }
          }

          final profit = income - expense;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      const Text(
                        "Summary",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Income"),
                          Text("₹${income.toStringAsFixed(2)}"),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Expense"),
                          Text("₹${expense.toStringAsFixed(2)}"),
                        ],
                      ),

                      const Divider(),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Profit",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹${profit.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Transactions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              ...transactions.map(
                (t) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: t.type == "income"
                          ? Colors.green
                          : Colors.red,
                      child: Icon(
                        t.type == "income"
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(t.note),
                    subtitle: Text(t.type),
                    trailing: Text(
                      "₹${t.amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}