import 'package:flutter/material.dart';
import 'package:barcode_scanner/barcode_list_scanner_controller.dart';

void main() => runApp(const MaterialApp(home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Device Demo')),
      body: BarcodeScannerWithController(),
    );
  }
}