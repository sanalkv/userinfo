import 'package:flutter/material.dart';
import 'signup.dart';
import 'database.dart';
import 'display.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      title: "USER INFO",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Colors.blue,
        buttonColor: Colors.blue,
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  final formkey = GlobalKey<FormState>();
  final scaffoldkey = GlobalKey<ScaffoldState>();
  bool result = false;

  Future<bool> check() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      var db = Dbhelper();
      result = await db.logincheck(email, password);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient grad = LinearGradient(
        colors: [Colors.white, Colors.purple[100]],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);

    return Scaffold(
      key: scaffoldkey,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: grad),
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[
                  Container(
                    height: screenAwareSize(70, context),
                  ),
                  Center(
                    child: Icon(Icons.lock,size: screenAwareSize(50, context),color: Colors.blue,)
                  ),
                  Container(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "enter Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (val) =>
                        !(val.contains("@")) ? "enter email" : null,
                    onSaved: (val) => email = val,
                  ),
                  Container(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                     validator: (val) => val.isEmpty ? "enter password " : null,
                    onSaved: (val) => password = val,
                  ),
                  Container(
                    height: 15,
                  ),
                  RaisedButton(
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Future<bool> res = check();
                      if (await res) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Display(email: email),
                          ),
                        );
                      } else {
                        SnackBar snackBar = new SnackBar(
                          content: Text("email or password wrong"),
                        );
                        scaffoldkey.currentState.showSnackBar(snackBar);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "Don't have an account ? Sign up",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double baseHeight = 640;
  double screenAwareSize(double size, BuildContext context) {
    return size * MediaQuery.of(context).size.height / baseHeight;
  }
}
