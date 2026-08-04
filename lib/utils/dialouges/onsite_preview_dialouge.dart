import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:united_app/firebase/firebase_functions.dart';
import 'package:united_app/models/machine_model.dart';
import 'package:united_app/models/onsite_model.dart';
import 'package:united_app/providers/machine_providers.dart';
import 'package:united_app/utils/dialouges/simple_dialouges.dart';
import 'package:url_launcher/url_launcher.dart';

class OnsitePreviewDialouge {
  Future<void> addDialogue(BuildContext context, OnsiteModel onsite) async {
    bool isLoading = false;

    final fromKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            Future<void> onTap() async {}

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: fromKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentGeometry.topCenter,
                          child: Text(
                            'Preview',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          onsite.customerName,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          onsite.customerNumber,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(onsite.problem, style: TextStyle(fontSize: 18)),
                        Text(
                          'Engineer: ${onsite.engineer}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(onsite.address, style: TextStyle(fontSize: 18)),
                        Text(
                          '${onsite.date.day}-${onsite.date.month}-${onsite.date.year}',
                          style: TextStyle(fontSize: 18),
                        ),

                        onsite.status == 'Completed'
                            ? Text(
                                'Amount Paid: ${onsite.amountPaid}',
                                style: TextStyle(fontSize: 18),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  if (onsite.status == 'Pending') {
                                    await SimpleDialouges()
                                        .statusChangeDialouge(
                                          context,
                                          'Seen',
                                          onsite.id!,
                                          onsite.customerNumber,
                                          onsite.problem,
                                          true,
                                        );
                                    Navigator.pop(context);
                                  } else if (onsite.status == 'Seen') {
                                    if (onsite.amountPaid == null) {
                                      await SimpleDialouges()
                                          .finalAmountDialouge(
                                            context,
                                            'Completed',
                                            onsite.id!,
                                            true,
                                          );
                                      return;
                                    }

                                    await SimpleDialouges()
                                        .statusChangeDialouge(
                                          context,
                                          'Completed',
                                          onsite.id!,
                                          onsite.customerNumber,
                                          onsite.problem,
                                          true,
                                        );
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: onsite.status == 'Pending'
                                              ? Colors.red
                                              : onsite.status == 'Seen'
                                              ? Colors.amber
                                              : Colors.green,
                                        ),
                                        width: 10,
                                        height: 10,
                                      ),
                                      SizedBox(width: 5),
                                      Text(onsite.status),
                                    ],
                                  ),
                                ),
                              ),

                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            final Uri phoneUri = Uri(         
                              scheme: 'tel',
                              path: onsite.customerName,
                            );

                            if (!await launchUrl(phoneUri)) {
                              throw Exception('Could not open dialer');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: BoxBorder.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [Icon(Icons.call), Text('call')],
                            ),
                          ),
                        ),
                      ],
                    ),
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
