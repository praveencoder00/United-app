import 'package:cloud_firestore/cloud_firestore.dart';

class Machine {
  final String? id;
  final String machineId;
  final String paymentStatus;
  final String machineName;
  final String customerName;
  final String customerNumber;
  final DateTime date;
  final String type;
  final int estimatedAmount;
  final int amountPaid;
  final int? finalAmount;
  final String status;
  

  Machine({
     this.id,
    required this.machineName,
    required this.customerName,
    required this.status, required this.customerNumber, required this.date, required this.type, required this.estimatedAmount, required this.amountPaid, this.finalAmount, required this.machineId, required this.paymentStatus,
  });

  factory Machine.fromMap(
      String id, Map<String, dynamic> map) {
    return Machine(
      id: id,
      machineName: map["machineName"],
      customerName: map["customerName"],
      status: map["status"], customerNumber: map["customerNumber"], date:(map["date"] as Timestamp).toDate(), type: map["type"], estimatedAmount: map["estimatedAmount"], amountPaid: map["amountPaid"], finalAmount: map['finalAmount'],
      machineId:map['machineId'],paymentStatus:map['paymentStatus']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "machineName": machineName,
      "customerName": customerName,
      "status": status,
      'customerNumber':customerNumber,
      'date':date,
      'type':type,
      'estimatedAmount':estimatedAmount,
      'amountPaid':amountPaid,
      'finalAmount':null,
      'paymentStatus':paymentStatus,
      'machineId':machineId,



    };
  }
}