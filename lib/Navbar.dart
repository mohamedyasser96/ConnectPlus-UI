import 'package:connect_plus/events.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/dummyPage.dart';
import 'package:connect_plus/Profile.dart';
import 'package:connect_plus/emergencyContact.dart';
import 'package:connect_plus/homepage.dart';
import 'package:connect_plus/login.dart';
import 'package:connect_plus/offersPage.dart';
import 'package:connect_plus/Offers.dart';
import 'package:connect_plus/Calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key key, this.title}) : super(key: key);
  final String title;
  // This widget is the root of your application.
  @override
  NavDrawerState createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer>
    with AutomaticKeepAliveClientMixin<NavDrawer> {
  @override
  bool get wantKeepAlive => true;
  var ip;
  var port;
  var offerCategories = [];
  final LocalStorage localStorage = new LocalStorage("Connect+");
  SharedPreferences prefs;

  void initState() {
    super.initState();
    setEnv().then((value) => getCategories());
  }

  Future setEnv() async {
    prefs = await SharedPreferences.getInstance();
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  void getCategories() async {
//    var ip = await EnvironmentUtil.getEnvValueForKey('SERVER_IP');
//    print(ip)
//    Working for android emulator -- set to actual ip for use with physical device
    var url = 'http://' + ip + ':' + port + '/offerCategories/getCategories';
    var token = localStorage.getItem("token");
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200)
      setState(() {
        offerCategories = json.decode(response.body)['offerCategories'];
      });
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              './assets/logo2.png',
            ),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [
            //       Colors.secondaryColor.withAlpha(255),
            //       Colors.primaryColor.withAlpha(255),
            //     ],
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //   ),
            // ),
          ),
          
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              )
            },
          ),
          ExpansionTile(
              leading: Icon(Icons.person),
              title: Text('Committees'),
              children: <Widget>[
                ExpansionTile(
                  leading: Padding(padding: EdgeInsets.only(left: 60.0)),
                  title: Text("ERGs",
                      style: TextStyle(color: Colors.black)),
                  children: <Widget>[
                    ListTile(
                      leading: Padding(padding: EdgeInsets.only(left: 75.0)),
                      title: Text('GENNEXT',
                          style: TextStyle(color: Colors.grey)),
                      onTap: () => print(""),
                    ),
                    ListTile(
                      leading: Padding(padding: EdgeInsets.only(left: 75.0)),
                      title: Text('DT Belmasry',
                          style: TextStyle(color: Colors.grey)),
                      onTap: () => print(""),
                    ),
                    ListTile(
                      leading: Padding(padding: EdgeInsets.only(left: 75.0)),
                      title: Text('WIA',
                          style: TextStyle(color: Colors.grey)),
                      onTap: () => print(""),
                    ),
                    ListTile(
                      leading: Padding(padding: EdgeInsets.only(left: 75.0)),
                      title: Text('MOSAIC',
                          style: TextStyle(color: Colors.grey)),
                      onTap: () => print(""),
                    )
                  ],
                ),
                ListTile(
                  leading: Padding(padding: EdgeInsets.only(left: 60.0)),
                  title: Text('Internal Comms',
                      style: TextStyle(color: Colors.grey)),
                  onTap: () => print(""),
                ),
                ExpansionTile(
                  leading: Padding(padding: EdgeInsets.only(left: 60.0)),
                  title: Text("Engagement Teams",style: TextStyle(color: Colors.black)),
                  children: <Widget>[
                    ListTile(
                      leading: Padding(padding: EdgeInsets.only(left: 75.0)),
                      title: Text('Wezaret ELSAADA (Deploy)',
                          style: TextStyle(color: Colors.grey)),
                      onTap: () => print(""),
                    ),
                    ListTile(
                      leading: Padding(padding: EdgeInsets.only(left: 75.0)),
                      title: Text('FUN CREW (CS)',
                          style: TextStyle(color: Colors.grey)),
                      onTap: () => print(""),
                    ),
                  ],
                ),
              ]),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Offers'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Offers()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Events'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Events()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.local_activity),
            title: Text('Activities'),
            // onTap: () => {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Activities()),
            //   )
            // },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Calendar'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Calendar()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text('Emergency Contacts'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => emergencyContact()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              prefs.remove("token"),
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => login()),
                  (Route<dynamic> route) => false)
            },
          ),
        ],
      ),
    );
  }
}
