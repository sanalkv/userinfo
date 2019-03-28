import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database.dart';
import 'user.dart';
import 'display.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formkey = GlobalKey<FormState>();
  final scaffoldkey = GlobalKey<ScaffoldState>();
  String email;
  String fullname;
  String mobile;
  String gender = "male";
  String age;
  String password;
  int groupvalue = 1;

  Future submit() async {
    if (formkey.currentState.validate()) {
      var db = Dbhelper();
      formkey.currentState.save();
      var object = User(fullname, email, mobile, gender, age, password);

      Future<bool> res = db.signup_check(email, mobile);
      if (await res) {
        SnackBar snackBar = new SnackBar(
          content: Text("email or mobile no. already registered"),
        );
        scaffoldkey.currentState.showSnackBar(snackBar);
      } else {
        db.savedetails(object);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Display(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient grad = LinearGradient(
        colors: [Colors.white, Colors.purple[100]],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
    return Scaffold(
      key: scaffoldkey,
      appBar: null,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: grad),
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.only(top:10.0,left: 10.0, right: 10.0,bottom:5.0 ),
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Icon(Icons.supervised_user_circle,size:screenAwareSize(50, context),color: Colors.blue,)
                  ),
                  Container(
                    height: 20,
                  ),
                  TextFormField(
                    
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      hintText: "Full Name.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (val) => val.isEmpty ? "enter full name" : null,
                    onSaved: (val) => fullname = val,
                  ),
                  Container(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "enter Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (val) =>
                        !(val.contains("@")) ? 'Enter email' : null,
                    onSaved: (val) => email = val,
                  ),
                  Container(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: "Mobile no.",
                      hintText: "Mobile no.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (val) =>
                        !(val.length == 10) ? 'enter 10 digit number' : null,
                    onSaved: (val) => mobile = val,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Radio(
                          activeColor: Colors.blue,
                          groupValue: groupvalue,
                          value: 1,
                          onChanged: (v) => gender_check(v)),
                      Text(
                        "Male",
                        style: TextStyle(
                            color: Colors.blue, fontFamily: "Times New Roman"),
                      ),
                      Radio(
                          activeColor: Colors.blue,
                          groupValue: groupvalue,
                          value: 2,
                          onChanged: (v) => gender_check(v)),
                      Text(
                        "Female",
                        style: TextStyle(
                            color: Colors.blue, fontFamily: "Times New Roman"),
                      ),
                    ],
                  ),
                  TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                    ],
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: "Age",
                      hintText: "Age",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (val) => val.isEmpty ? "enter age" : null,
                    onSaved: (val) => age = val,
                  ),
                  Container(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "password",
                      hintText: "password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (val) => val.length < 6
                        ? 'password length should be more than 6'
                        : null,
                    onSaved: (val) => password = val,
                    obscureText: true,
                  ),
                  Container(height: 20),
                  RaisedButton(
                    child:
                        Text("SIGNUP", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      submit();
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

  void gender_check(int e) {
    setState(() {
      if (e == 1) {
        gender = "male";
        groupvalue = 1;
      } else if (e == 2) {
        gender = "female";
        groupvalue = 2;
      }
    });
  }

  double baseHeight = 640;
  double screenAwareSize(double size, BuildContext context) {
    return size * MediaQuery.of(context).size.height / baseHeight;
  }
}
