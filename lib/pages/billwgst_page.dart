import 'package:flutter/material.dart';
import 'package:united_app/pages/customer_worklog_page.dart';

class BillwgstPage extends StatefulWidget {
  const BillwgstPage({super.key});

  @override
  State<BillwgstPage> createState() => _BillwgstPage();
}

class _BillwgstPage extends State<BillwgstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate Invoice')),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
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
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the gst no';
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
                      Text('GST IN'),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the State';
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
                            Text('state'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the pin code';
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
                            Text('pincode'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
              Container(
                color: Colors.grey,
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
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
                                  Text('Name of goods'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),

                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                                  // SizedBox(width: 3),
                                  Text(
                                    'Quantity',
                                    style: TextStyle(fontSize: 14),
                                    overflow: TextOverflow.clip,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
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
                                  Text('HSN/SAC'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),

                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'amount with gst';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: ClipRRect(
                                child: Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(width: 10),
                                    Text('amount ',overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.delete),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){}, child: Icon(Icons.add)),
              Spacer(),
              Expanded(child: Row(
                children: [
                  Spacer(),
                  ElevatedButton(onPressed: (){}, child: Text('Generate'))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
