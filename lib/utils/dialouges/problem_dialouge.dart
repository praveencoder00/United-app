import 'package:flutter/material.dart';
import 'package:united_app/firebase/firebase_functions.dart';
import 'package:united_app/models/problemLog_model.dart';

class ProblemDialouge {
  Future<void> addProblemDialogue(BuildContext context, String docId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        TextEditingController problemController = TextEditingController();
        TextEditingController amountController = TextEditingController();
        bool isLoading = false;
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
                      Text('Add problem log', style: TextStyle(fontSize: 24)),

                      SizedBox(height: 20),

                      TextFormField(
                        controller: problemController,
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
                              Text('Problem Note'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: amountController,
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
                                    problem: problemController.text,
                                    amount: int.parse(amountController.text),
                                    date: DateTime.now(),
                                  );

                                  FirestoreService().addProblemLog(
                                    docId,
                                    problem,
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
