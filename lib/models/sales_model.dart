import 'package:cloud_firestore/cloud_firestore.dart';

class Sales {
  final String? id;
  final String customerName;
  final String customerNumber;
  final String productName;
  final int amount;
  final DateTime date;

  Sales({
    this.id,
    required this.customerName,
    required this.customerNumber,
    required this.productName,
    required this.amount,

    required this.date,
  });

  factory Sales.fromMap(String id, Map<String, dynamic> map) {
    return Sales(
      id: id,
      customerName: map["customerName"],
      customerNumber: map["customerNumber"],
      productName: map["productName"],
      amount: map["amount"],
      date: (map["date"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "customerName": customerName,
      "customerNumber": customerNumber,
      "productName": productName,
      "amount": amount,
      "date": date,
    };
  }
}