import 'package:connect_plus/login.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:load/load.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connect_plus/registrationProfile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';

class registration extends StatefulWidget {
  registration({Key key, this.title}) : super(key: key);
  final String title;

  // This widget is the root of your application.
  @override
  _registrationState createState() => _registrationState();
}

class _registrationState extends State<registration> {
  final LocalStorage localStorage = new LocalStorage('Connect+');
  final fnController = TextEditingController();
  final emController = TextEditingController();
  final pwController = TextEditingController();
  final algorithm = PBKDF2();
  var asyncCall = false;
  var ip;
  var port;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  void initState() {
    super.initState();
    setEnv();
  }

  setEnv() {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  String hashPassword() {
    final hash = Password.hash(pwController.text, algorithm);
    return hash;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fnController.dispose();
    emController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    final firstNameField = TextField(
      controller: fnController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.05, height * 0.02, width * 0.02, height * 0.02),
          hintText: "Full Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    final emailField = TextField(
      controller: emController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.05, height * 0.02, width * 0.02, height * 0.02),
          hintText: "Email(@dell.com)",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    final passwordField = TextField(
      controller: pwController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.05, height * 0.02, width * 0.02, height * 0.02),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    final registerTitle = Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
            text: ' Register ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Utils.header,
                fontSize: size * 55,
                fontFamily: "Arial"))
      ]),
    );
    final loginPath = Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
            text: ' Already a user? ',
            style: TextStyle(
                color: Colors.black, fontSize: size * 25, fontFamily: "Arial")),
        TextSpan(
            text: ' Login',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Utils.header,
                fontSize: size * 25,
                fontFamily: "Arial"),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              })
      ]),
    );
    final registerButton = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          colors: [
            Utils.secondaryColor,
            Utils.primaryColor,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(
            width * 0.02, height * 0.023, width * 0.02, height * 0.023),
        onPressed: () {
          FocusScope.of(context).unfocus();
          setState(() {
            asyncCall = true;
          });
          Future.delayed(Duration(seconds: 1), () {
            register();
          });
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.normal)),
      ),
    );

    return Scaffold(
      body: ModalProgressHUD(
          inAsyncCall: asyncCall,
          opacity: 0.5,
          progressIndicator: LoadingText(),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Utils.background,
                    image: DecorationImage(
                      image: AssetImage("assets/logo2.png"),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(width * 0.05,
                            height * 0.32, width * 0.05, height * 0.03),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: height * 0.03),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: width * 0.01),
                                      child: registerTitle)),
                              SizedBox(height: height * 0.03),
                              Container(
                                width: width * 0.65,
                                child: firstNameField,
                              ),
                              SizedBox(height: height * 0.03),
                              Container(
                                width: width * 0.65,
                                child: emailField,
                              ),
                              SizedBox(height: height * 0.03),
                              Container(
                                width: width * 0.65,
                                child: passwordField,
                              ),
                              SizedBox(height: height * 0.027),
                              Container(
                                width: width * 0.6,
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: registerButton),
                              ),
                            ],
                          ),
                        ),
                      ),
                      loginPath
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void register() async {
    var url = 'http://' + ip + ':' + port + '/user/register';
    final msg = jsonEncode({
      'name': fnController.text,
      'email': emController.text,
      'password': hashPassword(),
    });
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: msg);
    if (response.statusCode == 200) {
      localStorage.setItem("user", json.decode(response.body)['user']);
      setState(() {
        asyncCall = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistrationProfile()),
      );
    } else {
      setState(() {
        asyncCall = false;
      });
      _showDialog(response.body);
    }
  }

  void _showDialog(err) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Oops!"),
          content: new Text(err),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget LoadingText() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new Text(
                "Loading...",
                style: TextStyle(fontSize: 30, color: Colors.orangeAccent),
              ),
            ],
          ),
        ));
  }
}
