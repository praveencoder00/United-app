import 'package:cloud_firestore/cloud_firestore.dart';

class OnsiteModel {
  final String? id;
  final String address;
  final String customerName;
  final String customerNumber;
  final String problem;
  final DateTime date;
  final int? amountPaid;
  final String status;
  final String engineer;

  OnsiteModel({
    this.id,
    required this.address,
    required this.customerName,
    required this.status,
    required this.customerNumber,
    required this.date,
    this.amountPaid,
    required this.problem, required this.engineer,

  });

  factory OnsiteModel.fromMap(String id, Map<String, dynamic> map) {
    return OnsiteModel(
      id: id,
      address: map["address"],
      customerName: map["customerName"],
      status: map["status"],
      customerNumber: map["customerNumber"],
      date: (map["date"] as Timestamp).toDate(),
      amountPaid: map["amountPaid"],
      problem: map['problem'], engineer: map['engineer']??'Anand',
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "address": address,
      "customerName": customerName,
      "status": status,
      'customerNumber': customerNumber,
      'date': date,
      'amountPaid': amountPaid,
      'problem': problem,
      'engineer':engineer,
    };
  }
}
