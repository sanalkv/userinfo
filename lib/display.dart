import 'package:flutter/material.dart';
import 'user.dart';
import 'database.dart';

class Display extends StatefulWidget {
  String email;
  Display({Key key, this.email}) : super(key: key);
  @override
  _DisplayState createState() => _DisplayState();
}

Future<List<User>> fetchdetails() async {
  var dbhelper = Dbhelper();
  Future<List<User>> list = dbhelper.getdetails();
  print(list);
  return list;
}

class _DisplayState extends State<Display> {
  String fullname;
  String email;
  String mobile;
  String gender;
  String age;

  @override
  Widget build(BuildContext context) {
    LinearGradient grad1 = LinearGradient(
        colors: [Colors.white, Colors.purple[100]],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
    LinearGradient grad = LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: grad1),
          child: FutureBuilder<List<User>>(
            future: fetchdetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              padding: const EdgeInsets.all(9.0),
                              height: screenAwareSize(205, context),
                              decoration: BoxDecoration(
                                  gradient: grad,
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.lightBlue),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[],
                                  ),
                                  Center(
                                      child: Icon(
                                    Icons.supervised_user_circle,
                                    size: screenAwareSize(45, context),
                                    color: Colors.indigo,
                                  )),
                                  Center(
                                    child: Text(
                                      snapshot.data[index].fullname,
                                      style: TextStyle(
                                        fontSize: screenAwareSize(25, context),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      "EMAIL :- " + snapshot.data[index].email,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      "MOBILE NO. : " +
                                          snapshot.data[index].mobile,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      "GENDER : " + snapshot.data[index].gender,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      "AGE : " + snapshot.data[index].age,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              )),
                        );
                      },
                    ),
                  );
                } else {
                  return Text("error");
                }
              } else {
                return Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
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
