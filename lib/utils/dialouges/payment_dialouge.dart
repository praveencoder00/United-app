import 'package:flutter/material.dart';
import 'package:united_app/firebase/firebase_functions.dart';
import 'package:united_app/models/finance_model.dart';
import 'package:united_app/models/problemLog_model.dart';
import 'package:united_app/utils/dialouges/simple_dialouges.dart';

class PaymentDialouge {
  Future<void> addPaymentDialogue(
    BuildContext context,
    String docId,
    int amountPaid,
    int? finalAmount,
    String cusName,
    String machineName,
  ) async {
    TextEditingController paymentContoller = TextEditingController();
    TextEditingController amount = TextEditingController();
    bool isLoading = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Payment log', style: TextStyle(fontSize: 24)),

                      SizedBox(height: 20),

                      TextFormField(
                        controller: paymentContoller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter the value';
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Row(
                            children: [
                              Icon(Icons.note_add_rounded),
                              SizedBox(width: 4),
                              Text('Payment Note'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: amount,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter the value';
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Row(
                            children: [
                              Icon(Icons.attach_money_rounded),
                              SizedBox(width: 4),
                              Text('Amount'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  ProblemlogModel problem = ProblemlogModel(
                                    problem: paymentContoller.text,
                                    amount: int.parse(amount.text),
                                    date: DateTime.now(),
                                  );

                                  await FirestoreService().addPaymentLog(
                                    docId,
                                    problem,
                                    amountPaid,
                                    finalAmount,
                                  );
                                  final now = DateTime.now();

                                  final finance = FinanceModel(
                                    id: '',
                                    amount: double.parse(amount.text.trim()),
                                    note: '$cusName--$machineName',
                                    type: 'income',
                                    createdAt: now,
                                    year: now.year,
                                    month: now.month,
                                    day: now.day,
                                  );
                                  await SimpleDialouges().addPaymentToFinance(
                                    context,
                                    finance,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Problem Log added'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }

                                Navigator.pop(context);
                              }
                            },
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
