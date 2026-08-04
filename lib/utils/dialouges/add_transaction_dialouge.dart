import 'package:flutter/material.dart';
import 'package:united_app/firebase/firebase_functions.dart';
import 'package:united_app/models/finance_model.dart';

Future<void> showFinanceDialog(BuildContext context) async {
  final formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String type = 'income';

  await showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Transaction'),

            content: SingleChildScrollView(
              child: SizedBox(
                width: 350,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              
                      const Text(
                        "Transaction Type",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              
                      const SizedBox(height: 10),
              
                      Wrap(
                        spacing: 10,
                        children: [
              
                          ChoiceChip(
                            label: const Text("Income"),
                            selected: type == "income",
                            selectedColor: Colors.green.shade100,
                            onSelected: (_) {
                              setState(() {
                                type = "income";
                              });
                            },
                          ),
              
                          ChoiceChip(
                            label: const Text("Expense"),
                            selected: type == "expense",
                            selectedColor: Colors.red.shade100,
                            onSelected: (_) {
                              setState(() {
                                type = "expense";
                              });
                            },
                          ),
              
                        ],
                      ),
              
                      const SizedBox(height: 20),
              
                      TextFormField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter amount";
                          }
              
                          if (double.tryParse(value) == null) {
                            return "Invalid amount";
                          }
              
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Amount",
                          prefixText: "₹ ",
                          border: OutlineInputBorder(),
                        ),
                      ),
              
                      const SizedBox(height: 20),
              
                      TextFormField(
                        controller: noteController,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter note";
                          }
              
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Note",
                          hintText: "Enter description...",
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            actions: [

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),

              FilledButton.icon(
                onPressed: () async {

                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  final now = DateTime.now();

                  final finance = FinanceModel(
                    id: '',
                    amount: double.parse(amountController.text.trim()),
                    note: noteController.text.trim(),
                    type: type,
                    createdAt: now,
                    year: now.year,
                    month: now.month,
                    day: now.day,
                  );

                  await FirestoreService().addTransaction(finance);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              ),
            ],
          );
        },
      );
    },
  );
}