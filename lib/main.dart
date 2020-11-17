import 'package:billGeneration/constants.dart';
import 'package:billGeneration/screens/bill_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bill Generation',
      theme: ThemeData(
        primarySwatch: foregroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BillScreen(),
    );
  }
}
