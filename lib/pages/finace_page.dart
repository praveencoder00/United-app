import 'package:flutter/material.dart';
import 'package:united_app/firebase/firebase_functions.dart';
import 'package:united_app/pages/finance_history_page.dart';
import 'package:united_app/utils/dialouges/add_transaction_dialouge.dart';
import 'package:united_app/utils/dialouges/simple_dialouges.dart';
import '../models/finance_model.dart';


class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FinanceHistoryPage(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await showFinanceDialog(context);
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<FinanceModel>>(
        stream: FirestoreService().getTodayTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
       if (snapshot.hasError) {
  return Center(
    child: Text(snapshot.error.toString()),
  );
}
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No transactions today"),
            );
          }
   
          final transactions = snapshot.data!;

          double income = 0;
          double expense = 0;

          for (final e in transactions) {
            if (e.type == "income") {
              income += e.amount;
            } else {
              expense += e.amount;
            }
          }

          final profit = income - expense;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              _summaryCard(
                income,
                expense,
                profit,
              ),

              const SizedBox(height: 20),

              const Text(
                "Today's Transactions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ...transactions.map(
                (e) => Card(
                  child: ListTile(
                    onLongPress: ()async =>await SimpleDialouges().deleteTransactionDialouge(context, e.id),
                    leading: CircleAvatar(
                      backgroundColor:
                          e.type == "income"
                              ? Colors.green
                              : Colors.red,
                      child: Icon(
                        e.type == "income"
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),

                    title: Text(e.note),

                    subtitle: Text(e.type),

                    trailing: Text(
                      "₹${e.amount.toStringAsFixed(2)}",
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

  Widget _summaryCard(
    double income,
    double expense,
    double profit,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            const Text(
              "Today's Summary",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
    );
  }
}