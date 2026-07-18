import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:united_app/models/machine_model.dart';
import 'package:united_app/models/problemLog_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Machine>> getMachines() {
    return _firestore.collection("machines").orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Machine.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Stream<List<ProblemlogModel>> getProblemLog(String docId) {
    final snapshots = FirebaseFirestore.instance
        .collection('machines')
        .doc(docId)
        .collection('problemLogs').orderBy('date', descending: true)
        .snapshots();
    return snapshots
        .map((snapshot) {
          return snapshot.docs.map((doc)=> ProblemlogModel.fromMap(doc.id, doc.data())).toList();
        });
  }
  Stream<List<ProblemlogModel>> getPaymentLog(String docId) {
    final snapshots = FirebaseFirestore.instance
        .collection('machines')
        .doc(docId)
        .collection('paymentLogs').orderBy('date', descending: true)
        .snapshots();
    return snapshots
        .map((snapshot) {
          return snapshot.docs.map((doc)=> ProblemlogModel.fromMap(doc.id, doc.data())).toList();
        });
  }



  Future<void> addProblemLog(String docId, ProblemlogModel problem) async {
    await _firestore.collection('machines').doc(docId).update({
      'estimatedAmount': FieldValue.increment(problem.amount)
    });
    await _firestore.collection('machines').doc(docId).collection('problemLogs').add(problem.toMap());
  }
  Future<void> addPaymentLog(String docId, ProblemlogModel problem,int amountPaid,int? finalAmount) async {
    if (amountPaid+problem.amount == finalAmount) {
       await FirebaseFirestore.instance.collection('machines').doc(docId).update({'paymentStatus':'Completed'});
    }
    await _firestore.collection('machines').doc(docId).update({
      'amountPaid': FieldValue.increment(problem.amount)
    });
    await _firestore.collection('machines').doc(docId).collection('paymentLogs').add(problem.toMap());
    
  }

  Future<void> addMachine(Machine machine, String problem) async {
    final machineRef = await _firestore
        .collection('machines')
        .add(machine.toMap());

    await machineRef
        .collection('problemLogs')
        .add(
          ProblemlogModel(
            problem: problem,
            amount: machine.estimatedAmount,
            date: machine.date,
          ).toMap(),
        );
         final customerQuery = await _firestore
        .collection('customers')
        .where('phoneNumber', isEqualTo: machine.customerNumber)
        .get();
    if (customerQuery.docs.isEmpty) {
      final customerRef = _firestore.collection('customers').doc();
      await customerRef.set({
        'name': machine.customerName,
        'phoneNumber': machine.customerNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else if (customerQuery.docs.first.data()['name'] != machine.customerName) {
      await customerQuery.docs.first.reference.update({'name': machine.customerName});
    }

  }

  Future<void> updateMachine(Machine machine) async {
    await _firestore
        .collection("machines")
        .doc(machine.id)
        .update(machine.toMap());
  }

  Future<void> deleteMachine(String id) async {
    await _firestore.collection("machines").doc(id).delete();
  }

  Stream<List<Map<String,dynamic>>> searchCustomers(String phone) {
  if (phone.isEmpty) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('customers')
      .where(
        'phoneNumber',
        isGreaterThanOrEqualTo: phone,
      )
      .where(
        'phoneNumber',
        isLessThanOrEqualTo: '$phone\uf8ff',
      )
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((e) => {'name':e.data()['name'],
            'phoneNumber':e.data()['phoneNumber']
            })
            .toList(),
      );
}
}
