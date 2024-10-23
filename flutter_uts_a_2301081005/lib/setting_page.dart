import 'package:flutter_uts_a_2301081005/drawer.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  static const routesName = '/setting';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WARNET"),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Text(
          "SAMPAI JUMPA KEMBALI",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}