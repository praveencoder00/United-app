import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleDialouges {
  Future<void> statusChangeDialouge(
    BuildContext context,
    String status,
    String id,
    String number,
    String machineName,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Status'),
          content: Text(
            'Are you sure want to change the status to \'$status\'?',
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('machines')
                    .doc(id)
                    .update({'status': status});
                    
            final Uri url = Uri.parse(
      "https://wa.me/91$number?text=${Uri.encodeComponent('Thanks for choosing United IT Solutions, your service request for machine $machineName is $status and will be delivered soon.')}",
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteDialouge(BuildContext context, String id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Entry'),
          content: Text('Are you sure want to Delete the entry?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final machineRef = FirebaseFirestore.instance
                    .collection('machines')
                    .doc(id);

                final problemLogs = await machineRef.collection('problemLogs').get();
                final paymentLogs = await machineRef.collection('paymentLogs').get();

                for (final doc in problemLogs.docs) {
                  await doc.reference.delete();
                }
                for (final doc in paymentLogs.docs) {
                  await doc.reference.delete();
                }

                await machineRef.delete();
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> finalAmountDialouge(
    BuildContext context,
    String status,
    String id,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        TextEditingController amount = TextEditingController();

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
                      Text(
                        'Enter Final Amount',
                        style: TextStyle(fontSize: 24),
                      ),

                      SizedBox(height: 20),

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
                                  await FirebaseFirestore.instance
                                      .collection('machines')
                                      .doc(id)
                                      .update({
                                        'finalAmount': int.parse(amount.text),
                                      });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Amount updated'),
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
