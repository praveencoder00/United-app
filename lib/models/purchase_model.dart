import 'package:cloud_firestore/cloud_firestore.dart';

class Purchase {
  final String? id;
  final String customerName;
  final String customerNumber;
  final String productName;
  final int amount;
  final int nos;
  final DateTime date;

  Purchase({
    this.id,
    required this.customerName,
    required this.customerNumber,
    required this.productName,
    required this.amount,

    required this.date, required this.nos,
  });

  factory Purchase.fromMap(String id, Map<String, dynamic> map) {
    return Purchase(
      id: id,
      customerName: map["customerName"],
      customerNumber: map["customerNumber"],
      productName: map["productName"],
      amount: map["amount"],
      date: (map["date"] as Timestamp).toDate(),
      nos: map['nos'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "customerName": customerName,
      "customerNumber": customerNumber,
      "productName": productName,
      "amount": amount,
      "date": date,
      'nos':nos,
    };
  }
}