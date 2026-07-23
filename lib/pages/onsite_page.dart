import 'package:flutter/material.dart';
import 'package:united_app/pages/completed_page.dart';
import 'package:united_app/pages/machine_detail_page.dart';
import 'package:united_app/pages/billwgst_page.dart';
import 'package:united_app/providers/machine_providers.dart';
import 'package:united_app/utils/dialouges/add_dialouge.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:united_app/utils/dialouges/onsite_add_dialouge.dart';
import 'package:united_app/utils/dialouges/onsite_preview_dialouge.dart';
import 'package:united_app/utils/dialouges/simple_dialouges.dart';



class OnsitePage extends ConsumerWidget {
  const OnsitePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machines = ref.watch(onSiteMachinesProvider);
    final selectedType = ref.watch(onSiteStatusFilterProvider);
    final search = ref.watch(searchProvider).toLowerCase();

    return Scaffold(
      resizeToAvoidBottomInset: true,
       appBar: AppBar(title: Text('Onsite machines'),leading: GestureDetector(
        onTap: () {
          ref.read(searchProvider.notifier).state = '';
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_new_rounded)),),

            floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await OnsiteAddDialouge().addDialogue(context);
        },
        backgroundColor: const Color.fromARGB(255, 236, 128, 255),
        child: Icon(Icons.add, color: Colors.white),
      ),
    
      body: machines.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),

        error: (e, _) =>
            Center(child: Text(e.toString())),

        data: (list) {
         final problemMachines = list.where((machine) {


             // Apply type filter
            if (selectedType != 'All' && machine.status != selectedType) {
              return false;
            }

            // If search is empty, keep the machine
            if (search.isEmpty) return true;

            // Search in multiple fields
            return machine.customerName.toLowerCase().contains(search) ||
                machine.customerNumber.toLowerCase().contains(search) ||
                machine.address.toLowerCase().contains(search) ;
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
                SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                  _chip(ref, "All", selectedType),
                    _chip(ref, "Completed", selectedType),
                     _chip(ref, "Seen", selectedType),
                    _chip(ref, "Pending", selectedType),
                  ],
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
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    _chip(ref, "All", selectedType),
                    _chip(ref, "Completed", selectedType),
                    _chip(ref, "Seen", selectedType),
                    _chip(ref, "Pending", selectedType),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: problemMachines.length,
                  itemBuilder: (_, index) {
                    final machine = problemMachines[index];
                
                   return GestureDetector(
                  onTap: ()async {
                    await OnsitePreviewDialouge().addDialogue(context, machine);
                    
                  },
                  onLongPress: () async => SimpleDialouges().deleteDialouge(context, machine.id!) ,
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
                        Text(machine.address,  style: TextStyle(fontSize: 18)),
                        Text('${machine.date.day}-${machine.date.month}-${machine.date.year}'),
                        Row(
                          children: [
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
                                      color: machine.status == 'Pending'? Colors.red: machine.status == 'Seen'? Colors.amber:Colors.green,
                                    ),
                                    height: 10,
                                    width: 10,
                                  ),
                                  SizedBox(width: 5),
                                  Text(machine.status),
                                ],
                              ),
                            ),

                          ],
                        ),
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

Widget _chip(WidgetRef ref, String type, String selected) {
  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(type),
      selected: selected == type,
      onSelected: (_) {
        ref.read(onSiteStatusFilterProvider.notifier).state = type;
      },
    ),
  );
}
