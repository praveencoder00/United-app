import 'package:cloud_firestore/cloud_firestore.dart';

class ProblemlogModel {
  final String? id;
  final String problem;
  final int amount;
  final DateTime date;

  ProblemlogModel({
    this.id,required this.problem, required this.amount, required this.date
  });

  factory ProblemlogModel.fromMap(String id,Map<String,dynamic> doc){
    return ProblemlogModel(
      id: id,
      problem: doc['problem'], amount: doc['amount'], date: (doc['date'] as Timestamp).toDate());
  }

  Map<String,dynamic> toMap(){
    return {
      'problem':problem,
      'amount':amount,
      'date':date
    };
  }
  
}