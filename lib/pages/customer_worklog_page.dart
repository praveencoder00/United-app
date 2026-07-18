import 'package:flutter/material.dart';

class CustomerWorklogPage extends StatefulWidget {
  const CustomerWorklogPage({super.key});

  @override
  State<CustomerWorklogPage> createState() => _CustomerWorklogPageState();
}

class _CustomerWorklogPageState extends State<CustomerWorklogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer name'),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
               color: const Color.fromARGB(38, 104, 58, 183),
               borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Machine Name:',style: TextStyle(
                  fontSize: 18
                ),),
              Text('Amount:',style: TextStyle(
                fontSize: 18
              ),),
              Text('24/05/2026')
              ],
            ) ,
          );
        },
      ),
    );
  }
}