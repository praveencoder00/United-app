import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:united_app/models/finance_model.dart';
import 'package:united_app/models/machine_model.dart';
import 'package:united_app/models/onsite_model.dart';
import 'package:united_app/models/problemLog_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Machine>> getMachines() {
    return _firestore
        .collection("machines")
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Machine.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  Stream<List<ProblemlogModel>> getProblemLog(String docId) {
    final snapshots = FirebaseFirestore.instance
        .collection('machines')
        .doc(docId)
        .collection('problemLogs')
        .orderBy('date', descending: true)
        .snapshots();
    return snapshots.map((snapshot) {
      return snapshot.docs
          .map((doc) => ProblemlogModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Stream<List<ProblemlogModel>> getPaymentLog(String docId) {
    final snapshots = FirebaseFirestore.instance
        .collection('machines')
        .doc(docId)
        .collection('paymentLogs')
        .orderBy('date', descending: true)
        .snapshots();
    return snapshots.map((snapshot) {
      return snapshot.docs
          .map((doc) => ProblemlogModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addProblemLog(String docId, ProblemlogModel problem) async {
    await _firestore.collection('machines').doc(docId).update({
      'estimatedAmount': FieldValue.increment(problem.amount),
    });
    await _firestore
        .collection('machines')
        .doc(docId)
        .collection('problemLogs')
        .add(problem.toMap());
  }

  Future<void> addPaymentLog(
    String docId,
    ProblemlogModel problem,
    int amountPaid,
    int? finalAmount,
  ) async {
    if (amountPaid + problem.amount == finalAmount) {
      await FirebaseFirestore.instance.collection('machines').doc(docId).update(
        {'paymentStatus': 'Completed'},
      );
    }
    await _firestore.collection('machines').doc(docId).update({
      'amountPaid': FieldValue.increment(problem.amount),
    });
    await _firestore
        .collection('machines')
        .doc(docId)
        .collection('paymentLogs')
        .add(problem.toMap());
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
        if(machine.amountPaid !=0){
          await machineRef
        .collection('problemLogs')
        .add(
          ProblemlogModel(
            problem: 'paid',
            amount: machine.amountPaid,
            date: machine.date,
          ).toMap());
        }
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
    } else if (customerQuery.docs.first.data()['name'] !=
        machine.customerName) {
      await customerQuery.docs.first.reference.update({
        'name': machine.customerName,
      });
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

  Stream<List<Map<String, dynamic>>> searchCustomers(String phone) {
    if (phone.isEmpty) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('customers')
        .where('phoneNumber', isGreaterThanOrEqualTo: phone)
        .where('phoneNumber', isLessThanOrEqualTo: '$phone\uf8ff')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (e) => {
                  'name': e.data()['name'],
                  'phoneNumber': e.data()['phoneNumber'],
                },
              )
              .toList(),
        );
  }


  //---------------------- finace--------------------------------------


    CollectionReference get _finance =>
      _firestore.collection('finance');

  // Add Transaction
 Future<void> addTransaction(
  FinanceModel finance,
) async {

  final batch = _firestore.batch();

  final transactionRef =
      _firestore.collection('finance').doc();

  batch.set(
    transactionRef,
    finance.toMap(),
  );

  await _createHistoryPath(
    batch,
    finance.year,
    finance.month,
    finance.day,
  );

  await batch.commit();
}

  // Delete Transaction
  Future<void> deleteTransaction(String id) async {
    await _finance.doc(id).delete();
  }

  // Update Transaction
  Future<void> updateTransaction(
      String id,
      FinanceModel finance,
      ) async {
    await _finance.doc(id).update(finance.toMap());
  }

  // Today's Transactions
  Stream<List<FinanceModel>> getTodayTransactions() {
    final now = DateTime.now();

    return _finance
        .where('year', isEqualTo: now.year)
        .where('month', isEqualTo: now.month)
        .where('day', isEqualTo: now.day)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => FinanceModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  // Transactions of a Month
  Stream<List<FinanceModel>> getMonthTransactions(
      int year,
      int month,
      ) {
    return _finance
        .where('year', isEqualTo: year)
        .where('month', isEqualTo: month)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => FinanceModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  // Transactions of a Year
  Stream<List<FinanceModel>> getYearTransactions(
      int year,
      ) {
    return _finance
        .where('year', isEqualTo: year)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => FinanceModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }


Stream<List<FinanceModel>> getTransactions(
  int year,
  int month,
  int day,
) {
  return _finance
      .where('year', isEqualTo: year)
      .where('month', isEqualTo: month)
      .where('day', isEqualTo: day)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => FinanceModel.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
}


Future<void> _createHistoryPath(
  WriteBatch batch,
  int year,
  int month,
  int day,
) async {
  final yearRef = _firestore
      .collection('history')
      .doc(year.toString());

  final monthRef = yearRef
      .collection('months')
      .doc(month.toString().padLeft(2, '0'));

  final dayRef = monthRef
      .collection('days')
      .doc(day.toString().padLeft(2, '0'));

  if (!(await yearRef.get()).exists) {
    batch.set(yearRef, {
      'created': true,
    });
  }

  if (!(await monthRef.get()).exists) {
    batch.set(monthRef, {
      'created': true,
    });
  }

  if (!(await dayRef.get()).exists) {
    batch.set(dayRef, {
      'created': true,
    });
  }
}


Stream<List<int>> getYears() {
  return _firestore
      .collection('history')
      .snapshots()
      .map((snapshot) {
    final years = snapshot.docs
        .map((e) => int.parse(e.id))
        .toList();

    years.sort((a, b) => b.compareTo(a));

    return years;
  });
}


Stream<List<int>> getMonths(int year) {
  return _firestore
      .collection('history')
      .doc(year.toString())
      .collection('months')
      .snapshots()
      .map((snapshot) {
    final months = snapshot.docs
        .map((e) => int.parse(e.id))
        .toList();

    months.sort((a, b) => b.compareTo(a));

    return months;
  });
}

Stream<List<int>> getDays(
  int year,
  int month,
) {
  return _firestore
      .collection('history')
      .doc(year.toString())
      .collection('months')
      .doc(month.toString().padLeft(2, '0'))
      .collection('days')
      .snapshots()
      .map((snapshot) {
    final days = snapshot.docs
        .map((e) => int.parse(e.id))
        .toList();

    days.sort((a, b) => b.compareTo(a));

    return days;
  });
}

//-------------onsite--------------
  Future<void> onSiteAddMachine(OnsiteModel machine, String problem) async {
   await _firestore
        .collection('onsite')
        .add(machine.toMap());



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
    } else if (customerQuery.docs.first.data()['name'] !=
        machine.customerName) {
      await customerQuery.docs.first.reference.update({
        'name': machine.customerName,
      });
    }
  }

    Stream<List<OnsiteModel>> getOnSiteMachines() {
    return _firestore
        .collection("onsite")
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => OnsiteModel.fromMap(doc.id, doc.data()))
              .toList();
        });
  }
  Future<void> deleteOnsite(String id)async{
    await _firestore.collection('onsite').doc(id).delete();
  }

}
