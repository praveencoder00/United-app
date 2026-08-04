import 'package:flutter/material.dart';
import 'package:united_app/pages/completed_page.dart';
import 'package:united_app/pages/machine_detail_page.dart';
import 'package:united_app/pages/billwgst_page.dart';
import 'package:united_app/providers/machine_providers.dart';
import 'package:united_app/utils/dialouges/add_dialouge.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:united_app/utils/dialouges/sales_dialouge.dart';
import 'package:united_app/utils/dialouges/simple_dialouges.dart';



class SalesPage extends ConsumerWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(purchaseProvider);

    final search = ref.watch(searchProvider).toLowerCase();

    return Scaffold(
      resizeToAvoidBottomInset: true,
            floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await SalesDialouge().addDialogue(context);
        },
        backgroundColor: const Color.fromARGB(255, 236, 128, 255),
        child: Icon(Icons.add, color: Colors.white),
      ),
       appBar: AppBar(title: Text('Purchase Productes'),leading: GestureDetector(
        onTap: () {
          ref.read(searchProvider.notifier).state = '';
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_new_rounded)),),
    
      body: product.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),

        error: (e, _) =>
            Center(child: Text(e.toString())),

        data: (list) {
         final problemMachines = list.where((machine) {

            // If search is empty, keep the machine
            if (search.isEmpty) return true;

            // Search in multiple fields
            return machine.customerName.toLowerCase().contains(search) ||
                machine.customerNumber.toLowerCase().contains(search) ||
                machine.productName.toLowerCase().contains(search) ;
          }).toList();
              if (problemMachines.isEmpty) {
            return Column(
              children: [
                Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                child: TextField(
                  onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(searchProvider.notifier).state = value;
                  },
                ),
              ),

                Expanded(child: Center(child: Text('No machines registered'))),
              ],
            );
          }

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                child: TextField(
                  onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(searchProvider.notifier).state = value;
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: problemMachines.length,
                  itemBuilder: (_, index) {
                    final machine = problemMachines[index];
                
                   return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => MachineDetailPage(initialIndex: 1,machineId: machine.id!,cusName: machine.customerName,machineName: machine.machineName,)),
                    // );
                  },
                  onLongPress: () async => SimpleDialouges().deletePurchaseDialouge(context, machine.id!) ,
                  child: Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: index % 2 == 0
                          ? Color.fromARGB(255, 209, 209, 209)
                          : const Color.fromARGB(141, 70, 196, 255),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(machine.customerName, style: TextStyle(fontSize: 24)),
                        Text(machine.customerNumber, style: TextStyle(fontSize: 24)),
                        Text('${machine.productName} ', style: TextStyle(fontSize: 18)),
                         Text('₹${machine.amount}', style: TextStyle(fontSize: 18)),
                        Text('${machine.date.day}-${machine.date.month}-${machine.date.year}'),
                      ],
                    ),
                  ),
                );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


