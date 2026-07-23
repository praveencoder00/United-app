import 'package:cloud_firestore/cloud_firestore.dart';

class FinanceModel {
  final String id;
  final double amount;
  final String note;
  final String type;
  final DateTime createdAt;

  final int year;
  final int month;
  final int day;

  FinanceModel({
    required this.id,
    required this.amount,
    required this.note,
    required this.type,
    required this.createdAt,
    required this.year,
    required this.month,
    required this.day,
  });

  factory FinanceModel.fromMap(
      String id,
      Map<String,dynamic> json){
    return FinanceModel(
      id: id,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'],
      type: json['type'],
      createdAt:
          (json['createdAt'] as Timestamp).toDate(),
      year: json['year'],
      month: json['month'],
      day: json['day'],
    );
  }

  Map<String,dynamic> toMap(){
    return{
      'amount':amount,
      'note':note,
      'type':type,
      'createdAt':FieldValue.serverTimestamp(),
      'year':year,
      'month':month,
      'day':day,
    };
  }
}