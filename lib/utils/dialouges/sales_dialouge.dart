import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:united_app/firebase/firebase_functions.dart';
import 'package:united_app/models/finance_model.dart';
import 'package:united_app/models/machine_model.dart';
import 'package:united_app/models/onsite_model.dart';
import 'package:united_app/models/sales_model.dart';
import 'package:united_app/providers/machine_providers.dart';
import 'package:united_app/utils/dialouges/simple_dialouges.dart';

class SalesDialouge {
  Future<void> addDialogue(BuildContext context) async {
    TextEditingController customerName = TextEditingController();
    TextEditingController customerNumber = TextEditingController();
    TextEditingController product = TextEditingController();
    TextEditingController amount = TextEditingController();

   


    bool isLoading = false;


    final fromKey = GlobalKey<FormState>();
    String search = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            customerNumber.addListener(() {
              setState(() {
                search = customerNumber.text;
              });
            });
            Future<void> onTap() async {
              setState(() => isLoading = true);

              try {
                if (fromKey.currentState!.validate() 
                   ) {
                  Sales machineModel = Sales(
                    customerName: customerName.text,
                    amount: int.parse(amount.text) ,
                    productName: product.text,
                    customerNumber: customerNumber.text,
                    date: DateTime.now(),
                   
                  );
                 
                   
                    final now = DateTime.now();

                    final finance = FinanceModel(
                      id: '',
                      amount: double.parse(amount.text.trim()),
                      note: '${customerName.text}--${product.text}',
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
                  
                   await FirestoreService().addSale(
                      machineModel,
            
                    );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                  print('done');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$e'),
                    backgroundColor: const Color.fromARGB(255, 255, 31, 31),
                  ),
                );
                Navigator.pop(context);
              }
            }

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
                            'Add Entry',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: customerNumber,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length != 10) {
                              return 'Enter the Number';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),

                            label: Row(
                              children: [
                                Icon(Icons.phone),
                                SizedBox(width: 10),
                                Text('Customer Number'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: FirestoreService().searchCustomers(search),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || search.isEmpty) {
                              return const SizedBox();
                            }

                            final customers = snapshot.data!;

                            if (customers.isEmpty) {
                              return const SizedBox();
                            }

                            return Container(
                              constraints: const BoxConstraints(maxHeight: 150),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: customers.length,
                                itemBuilder: (_, index) {
                                  final customer = customers[index];

                                  return ListTile(
                                    title: Text(customer['name']),
                                    subtitle: Text(customer['phoneNumber']),
                                    onTap: () {
                                      customerNumber.text =
                                          customer['phoneNumber'];

                                      customerName.text = customer['name'];

                                      FocusScope.of(context).unfocus();

                                      setState(() {
                                        search = '';
                                      });
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        TextFormField(
                          controller: customerName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the Name';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 10),
                                Text('Customer name'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: product,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the Product name';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Row(
                              children: [
                                Icon(Icons.shopify_rounded),
                                SizedBox(width: 10),
                                Text('Product'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: amount,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the Amount';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Row(
                              children: [
                                Icon(Icons.money),
                                SizedBox(width: 10),
                                Text('Amount'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      
                        const SizedBox(height: 20),
                        Align(
                          alignment: AlignmentGeometry.bottomRight,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : onTap,
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text('Save'),
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
