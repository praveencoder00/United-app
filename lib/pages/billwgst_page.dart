import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:united_app/pages/customer_worklog_page.dart';
import 'package:united_app/pages/invoice_preview_page.dart';

class BillwgstPage extends StatefulWidget {
  const BillwgstPage({super.key});

  @override
  State<BillwgstPage> createState() => _BillwgstPage();
}

class _BillwgstPage extends State<BillwgstPage> {
  DateTime now = DateTime.now();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController invoiceNo = TextEditingController();
  TextEditingController nameOfGood = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController amount = TextEditingController();
  final fromKey = GlobalKey<FormState>();
  final List<ProductItem> products = [ProductItem()];

  @override
  void initState() {
    super.initState();

    // Today's date in dd-MM-yyyy format
    date.text = '${now.day}-${now.month}-${now.year}';

    // Load invoice number from Firestore
    loadInvoiceNumber();
  }

  Future<void> loadInvoiceNumber() async {
    final ref = FirebaseFirestore.instance.collection('utils').doc('invoiceNo');

    final doc = await ref.get();

    if (doc.exists) {
      final current = doc['number'] as int;
      invoiceNo.text = (current + 1).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('Generate Invoice')),
      body: SingleChildScrollView(
        child: Form(
          key: fromKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: name,
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
                  controller: address,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the address';
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
                        Text('Address'),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: date,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter the Date';
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
                              Text('Date'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),

                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: invoiceNo,
                        validator: (value) {
                          if (value == null || value.isEmpty ) {
                            return 'Enter the invoice no';
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
                              Text('Invoice no'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final item = products[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey.shade300,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the Name';
                              } else {
                                return null;
                              }
                            },
                            controller: item.name,
                            decoration: const InputDecoration(
                              labelText: "Name of Goods",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter the Quantity';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: item.quantity,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Qty",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter the Amount';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: item.amount,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Amount",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),

                              index != 0
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          products.removeAt(index);
                                        });
                                      },
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      products.add(ProductItem());
                    });
                  },
                  child: Icon(Icons.add),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (fromKey.currentState!.validate()) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => InvoicePreviewPage(
                                name: name.text,
                                address: address.text,
                                date: date.text,
                                invoiceNo: invoiceNo.text,
                                products: products,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text('Generate'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductItem {
  final TextEditingController name = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController amount = TextEditingController();
}
