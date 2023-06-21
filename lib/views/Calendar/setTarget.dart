import 'package:Brahmachaitanya/views/Calendar/progressScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constants.dart';

DateTime start = DateTime.now();
DateTime end = DateTime.now();

class TargetSetScreen extends StatefulWidget {
  const TargetSetScreen({super.key});

  @override
  State<TargetSetScreen> createState() => _TargetSetScreenState();
}

class _TargetSetScreenState extends State<TargetSetScreen> {
  Future<void> setTarget(String newTarget) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    // await Future.delayed(const Duration(seconds: 5));
    await db.collection('admin').doc('target').set({'target': newTarget});
  }

  Future<void> setStart(DateTime newstart) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    // await Future.delayed(const Duration(seconds: 5));
    await db.collection('admin').doc('start').set({'start': newstart});
  }

  Future<void> setEnd(DateTime newend) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    // await Future.delayed(const Duration(seconds: 5));
    await db.collection('admin').doc('end').set({'end': newend});
  }

  Future<double> getTarget() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String target = await db
        .collection('admin')
        .doc('target')
        .get()
        .then((value) => value['target']);
    double code = double.parse(target);
    // targetJapCount = code;
    return code;
  }

  Future<void> getStart() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    start = await db
        .collection('admin')
        .doc('start')
        .get()
        .then((value) => value['start']);
  }

  Future<void> getEnd() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    start = await db
        .collection('admin')
        .doc('start')
        .get()
        .then((value) => value['start']);
  }

  @override
  Widget build(BuildContext context) {
    int _numberValue = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Target Settings'),
      ),
      body: Container(
        color: COLOR_SCHEME['faint']!.withOpacity(0.5),
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Click here to set the target ',
                ),
                onChanged: (value) {
                  setState(() {
                    _numberValue = int.tryParse(value) ?? 0;
                    setTarget(value);
                  });
                },
              ),
              SizedBox(height: 40.0),
              InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      start = selectedDate;
                      setStart(start);
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Choose Start Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(start?.toString().substring(0,11) ?? 'Select a date'),
                ),
              ),
              SizedBox(height: 40.0),
              InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      end = selectedDate;
                      setEnd(end);
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Choose End Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(end?.toString().substring(0,11) ?? 'Select a date'),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
