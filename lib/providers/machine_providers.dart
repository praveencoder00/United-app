

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:united_app/firebase/firebase_functions.dart';
import 'package:united_app/models/machine_model.dart';
import 'package:united_app/models/problemLog_model.dart';

final firestoreProvider =
    Provider((ref) => FirestoreService());

final machineTypeFilterProvider =
    StateProvider<String>((ref) => 'All');

final paymentStatusFilterProvider =
    StateProvider<String>((ref) => 'All');

final searchProvider = StateProvider<String>((ref) => '');

final machinesProvider =
    StreamProvider<List<Machine>>((ref) {
  return ref
      .watch(firestoreProvider)
      .getMachines();
});

final machineProvider = StreamProvider.autoDispose.family<Machine,String>((ref,id){

return FirebaseFirestore.instance
      .collection('machines')
      .doc(id)
      .snapshots()
      .map((doc) => Machine.fromMap(doc.id, doc.data()!));
});

final problemLogProvider = StreamProvider.autoDispose.family<List<ProblemlogModel>,String>((ref,docId){
  return ref.watch(firestoreProvider).getProblemLog(docId);
});
final paymentLogProvider = StreamProvider.autoDispose.family<List<ProblemlogModel>,String>((ref,docId){
  return ref.watch(firestoreProvider).getPaymentLog(docId);
});