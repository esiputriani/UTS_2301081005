
import 'package:flutter_uts_a_2301081005/home_page.dart';
import 'package:flutter_uts_a_2301081005/setting_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            color: Colors.green,
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(20),
            child: Text(
              "Menu",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(MyHome.routesName);
            },
            leading: Icon(Icons.home),
            title: Text("Warnet"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(SettingPage.routesName);
            },
            leading: Icon(Icons.logout),
            title: Text("Keluar"),
          ),
        ],
      ),
    );
  }
}
