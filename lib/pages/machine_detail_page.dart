import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:united_app/firebase/firebase_functions.dart';
import 'package:united_app/models/machine_model.dart';
import 'package:united_app/models/problemLog_model.dart';
import 'package:united_app/pages/billwgst_page.dart';
import 'package:united_app/providers/machine_providers.dart';
import 'package:united_app/utils/dialouges/add_dialouge.dart';
import 'package:united_app/utils/dialouges/payment_dialouge.dart';
import 'package:united_app/utils/dialouges/problem_dialouge.dart';
import 'package:united_app/utils/dialouges/simple_dialouges.dart';
import 'package:url_launcher/url_launcher.dart';

class MachineDetailPage extends ConsumerStatefulWidget {
  final int initialIndex;
  final String machineId;
  final String cusName;
  final String machineName;
  const MachineDetailPage({
    super.key,
    required this.initialIndex,
    required this.machineId,
    required this.cusName,
    required this.machineName,
  });
  @override
  ConsumerState<MachineDetailPage> createState() => _MachineDetailPage();
}

class _MachineDetailPage extends ConsumerState<MachineDetailPage> {
  late String? paymentStatus;
  late int amountPaid;
  late int? finalAmount;
  late String cusnumber;
  late Machine machineLocal;

  @override
  Widget build(BuildContext context) {
    final machine = ref.watch(machineProvider(widget.machineId));
    final problems = ref.watch(problemLogProvider(widget.machineId));
    final payments = ref.watch(paymentLogProvider(widget.machineId));

    return DefaultTabController(
      initialIndex: widget.initialIndex,
      length: 2,
      child: Scaffold(
        floatingActionButton: widget.initialIndex == 1
            ? null
            : FloatingActionButton(
                onPressed: () async {
                  ProblemDialouge().addProblemDialogue(
                    context,
                    widget.machineId,
                  );
                },
                child: Icon(Icons.add),
              ),
        appBar: AppBar(
          title: Text('Machine Details'),
          leading: GestureDetector(
            onTap: () {
              ref.read(searchProvider.notifier).state = '';
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_rounded),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                await PaymentDialouge().addPaymentDialogue(
                  context,
                  widget.machineId,
                  amountPaid,
                  finalAmount,
                  widget.cusName,
                  widget.machineName,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.money_rounded, size: 28),
              ),
            ),
          ],
        ),
        body: machine.when(
          data: (data) {
            amountPaid = data.amountPaid;
            finalAmount = data.finalAmount;
            machineLocal = data;
            setState(() {
              cusnumber = data.customerNumber;
              paymentStatus = data.paymentStatus;
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(12),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // border: Border.all(),
                    color: const Color.fromARGB(38, 104, 58, 183),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(data.customerName, style: TextStyle(fontSize: 18)),
                      Text(data.customerNumber, style: TextStyle(fontSize: 18)),
                      Text(
                        '${data.machineName} -- id:${data.machineId}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${data.date.day}-${data.date.month}-${data.date.year}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Estimated Amount: ${data.estimatedAmount}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Final Amount: ${data.finalAmount ?? 'not confirmed'}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Amount Paid: ${data.amountPaid}',
                        style: TextStyle(fontSize: 18),
                      ),
                      widget.initialIndex == 1
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (data.status == 'Pending') {
                                      await SimpleDialouges()
                                          .statusChangeDialouge(
                                            context,
                                            'On proccess',
                                            data.id!,
                                            data.customerNumber,
                                            data.machineName,
                                            false
                                          );
                                    } else if (data.status == 'On proccess') {
                                      if (data.finalAmount == null) {
                                        SimpleDialouges().finalAmountDialouge(
                                          context,
                                          'Completed',
                                          data.id!,
                                          false
                                        );
                                        return;
                                      }
                                      if (data.amountPaid == data.finalAmount) {
                                        await FirebaseFirestore.instance
                                            .collection('machines')
                                            .doc(data.id)
                                            .update({
                                              'paymentStatus': 'Completed',
                                            });
                                      }
                                      await SimpleDialouges()
                                          .statusChangeDialouge(
                                            context,
                                            'Completed',
                                            data.id!,
                                            data.customerNumber,
                                            data.machineName,
                                            false
                                          );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: data.status == 'Pending'
                                                ? Colors.red
                                                : data.status == 'On proccess'
                                                ? Colors.amber
                                                : Colors.green,
                                          ),
                                          width: 10,
                                          height: 10,
                                        ),
                                        SizedBox(width: 5),
                                        Text(data.status),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: data.paymentStatus == 'Pending'
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                        height: 10,
                                        width: 10,
                                      ),
                                      SizedBox(width: 5),
                                      Text(data.paymentStatus),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                data.paymentStatus == 'Pending'
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          final Uri url = Uri.parse(
                                            "https://wa.me/91$cusnumber?text=${Uri.encodeComponent('Thanks for choosing United IT Solutions, your service request for machine ${machineLocal.machineName} is Completed. Please make your payment of *${machineLocal.finalAmount} Rs* soon.')}",
                                          );
                                          await launchUrl(
                                            url,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        },
                                        child: Icon(Icons.send),
                                      )
                                    : SizedBox(),
                                SizedBox(width: 20),
                              ],
                            )
                          : GestureDetector(
                              onTap: () async {
                                if (data.status == 'Pending') {
                                  await SimpleDialouges().statusChangeDialouge(
                                    context,
                                    'On proccess',
                                    data.id!,
                                    data.customerNumber,
                                    data.machineName,
                                    false
                                  );
                                } else if (data.status == 'On proccess') {
                                  if (data.finalAmount == null) {
                                    SimpleDialouges().finalAmountDialouge(
                                      context,
                                      'Completed',
                                      data.id!,
                                      false
                                    );
                                    return;
                                  }
                                  if (data.amountPaid == data.finalAmount) {
                                    await FirebaseFirestore.instance
                                        .collection('machines')
                                        .doc(data.id)
                                        .update({'paymentStatus': 'Completed'});
                                  }
                                  await SimpleDialouges().statusChangeDialouge(
                                    context,
                                    'Completed',
                                    data.id!,
                                    data.customerNumber,
                                    data.machineName,
                                    false
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: data.status == 'Pending'
                                            ? Colors.red
                                            : data.status == 'On proccess'
                                            ? Colors.amber
                                            : Colors.green,
                                      ),
                                      width: 10,
                                      height: 10,
                                    ),
                                    SizedBox(width: 5),
                                    Text(data.status),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                TabBar(tabs: [Text('Problem Log'), Text('Payment Log')]),
                Expanded(
                  child: TabBarView(
                    children: [
                      problems.when(
                        data: (list) {
                          return ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              final problemdetail = list[index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(38, 104, 58, 183),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          child: Text(
                                            problemdetail.problem,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Text(
                                          '${problemdetail.date.day}/${problemdetail.date.month}/${problemdetail.date.year}',
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text('₹${problemdetail.amount}'),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        error: (e, _) {
                          return Center(child: Text('$e'));
                        },
                        loading: () => CircularProgressIndicator(),
                      ),

                      payments.when(
                        data: (list) {
                          if (list.isEmpty) {
                            return Center(child: Text('No log entered'));
                          }
                          return ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              final problemdetail = list[index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(38, 104, 58, 183),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            // width: MediaQuery.of(context).size.width * 0.7,
                                            child: Text(
                                              problemdetail.problem,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          Text(
                                            '${problemdetail.date.day}/${problemdetail.date.month}/${problemdetail.date.year}',
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Text('₹${problemdetail.amount}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        error: (e, _) {
                          return Center(child: Text('$e'));
                        },
                        loading: () => CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (e, _) => Center(child: Text(e.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
