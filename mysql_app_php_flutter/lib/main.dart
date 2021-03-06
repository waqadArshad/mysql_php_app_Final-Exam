import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql_app_php_flutter/services/services.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'model/User.dart';

void main() {
  runApp(MaterialApp(home: Form()));
}

Widget DrawerNav(BuildContext context) {
  var navMenu = Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Tic Tac\n    Toe',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'Home',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Form()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text(
            'Contact Me',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactUs()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text(
            'Exit',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
  return navMenu;
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Widget splashWidget = SplashScreenView(
      navigateRoute: Form(),
      duration: 5000,
      imageSize: 280,
      imageSrc: "images/tictactoelogo.png",
      text: "Waqad\nSP18-BCS-112",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.green[200],
        Colors.blue,
        Colors.red,
        Colors.pink[100],
      ],
      backgroundColor: Colors.yellow,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splash screen',
      home: splashWidget,
    );
  }
}

// ignore: use_key_in_widget_constructors
class Form extends StatefulWidget {
  const Form({Key key}) : super(key: key);
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {

  List<User> _userList=[];
  final nameCon = TextEditingController();
  final emailCon = TextEditingController();
  final phoneCon = TextEditingController();
  final skillCon = TextEditingController();
  final bloodCon = TextEditingController();
  final addressCon = TextEditingController();

  User _selectedUser;
  bool _isUpdating;
  String _titleProgress;
  @override
  void initState(){
    super.initState();
    _isUpdating=false;
    _titleProgress= "Flutter Data Table";
    _getUsers();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _clearValues() {
    nameCon.text = '';
    emailCon.text = '';
    phoneCon.text = '';
    skillCon.text = '';
    bloodCon.text = '';
    addressCon.text = '';
  }

  _getUsers() {
    _showProgress('Loading Employees...');
    Services.getUsers().then((users) {
      print("inside _getUser");
      setState(() {
        _userList = users;

      });
      print("uselist is $_userList");
      _showProgress("Flutter DataTable");
      print("Length: ${_userList.length}");
    });
  }

  _addUser(){
    if (nameCon.text.trim().isEmpty ||
        emailCon.text.trim().isEmpty) {
      print("Empty fields");
      return;
    }
    _showProgress('Adding Employee...');
    Services.addUser(nameCon.text, emailCon.text,
        phoneCon.text, skillCon.text, bloodCon.text,
        addressCon.text)
        .then((result) {
      if ('success' == result) {
        _getUsers();
      }
      _clearValues();
    });
  }

  _deleteUser(String email) {
    _showProgress('Deleting Employee...');
    Services.deleteUser(email).then((result) {
      if ('success' == result) {
        setState(() {
          // _userList.remove(user);
        });
        _getUsers();
      }
    });
  }

  _updateUser(User user) {
    _showProgress('Updating Employee...');
    Services.updateUser(
        nameCon.text, emailCon.text,
        phoneCon.text, skillCon.text, bloodCon.text,
        addressCon.text)
        .then((result) {
      if ('success' == result) {
        _getUsers();
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _setValues(User user) {
    nameCon.text = user.name;
    emailCon.text = user.email;
    setState(() {
      _isUpdating = true;
    });
  }

  // SingleChildScrollView _dataBody() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.vertical,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: DataTable(
  //         columns: [
  //           DataColumn(
  //               label: Text("ID"),
  //               numeric: false,
  //               tooltip: "This is the User id"),
  //           DataColumn(
  //               label: Text(
  //                 "NAME",
  //               ),
  //               numeric: false,
  //               tooltip: "This is the name"),
  //           DataColumn(
  //               label: Text("EMAIL"),
  //               numeric: false,
  //               tooltip: "This is the email"),
  //           DataColumn(
  //               label: Text("DELETE"),
  //               numeric: false,
  //               tooltip: "Delete Action"),
  //         ],
  //         rows: _userList
  //             .map(
  //               (user) => DataRow(
  //             cells: [
  //               DataCell(
  //                 Text(user.id),
  //                 onTap: () {
  //                   print("Tapped " + user.name);
  //                   _setValues(user);
  //                   _selectedUser = user;
  //                 },
  //               ),
  //               DataCell(
  //                 Text(
  //                   user.name.toUpperCase(),
  //                 ),
  //                 onTap: () {
  //                   print("Tapped " + user.name);
  //                   _setValues(user);
  //                   _selectedUser = user;
  //                 },
  //               ),
  //               DataCell(
  //                 Text(
  //                   user.email.toUpperCase(),
  //                 ),
  //                 onTap: () {
  //                   print("Tapped " + user.name);
  //                   _setValues(user);
  //                   _selectedUser = user;
  //                 },
  //               ),
  //               DataCell(
  //                 IconButton(
  //                   icon: Icon(Icons.delete),
  //                   onPressed: () {
  //                     _deleteUser(user);
  //                   },
  //                 ),
  //                 onTap: () {
  //                   print("Tapped " + user.name);
  //                 },
  //               ),
  //             ],
  //           ),
  //         )
  //             .toList(),
  //       ),
  //     ),
  //   );
  // }

  Widget textFieldBuiilder(TextEditingController cont, String label) {
    return Container(
      padding: EdgeInsets.all(16),
      width: 400,
      child: Center(
        child: TextField(
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff3F26DF), width: 3.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3.0),
              ),
              hintText: 'Enter $label',
              labelText: '$label',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 20,
              ),
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
              )),
          obscureText: false,
          controller: cont,
        ),
      ),
    );
  }

  Widget buttonBuilder(String name) {
    return Expanded(
      child: MaterialButton(
        color: Colors.amber,
        height: 50,
        child: Text(name,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        onPressed: () {
          if (name == "Add") {
            // insert function
            _addUser();
          } else if (name == "Delete") {
            // Delete function
            _deleteUser(emailCon.text);
          } else if (name == "Update") {
            // Update function
            // _updateUser(user);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      drawer: DrawerNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: prefer_const_literals_to_create_immutables
                  Text(
                    "Registration Form",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.amber,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
              textFieldBuiilder(nameCon, 'Name'),
              textFieldBuiilder(emailCon, 'Email'),
              textFieldBuiilder(phoneCon, 'Phone'),
              textFieldBuiilder(skillCon, 'Skill'),
              textFieldBuiilder(bloodCon, 'Blood Group'),
              textFieldBuiilder(addressCon, 'Address'),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          buttonBuilder("Add"),
                          SizedBox(
                            width: 20,
                          ),
                          buttonBuilder("Update"),
                          SizedBox(
                            width: 20,
                          ),
                          buttonBuilder("Delete"),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
              // _dataBody(),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactUs extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2nd Week App',
      home: Scaffold(
        drawer: DrawerNav(context),
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.home_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Form(),
                ),
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    //whole upper container
                    width: 360,
                    height: 80,
                    // padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        // Container(
                        //   padding: EdgeInsets.all(8.0),
                        //   margin: EdgeInsets.symmetric(vertical: 3.0),
                        //   child: Column(
                        //     children: <Widget>[
                        //       Image(image: AssetImage('assets/ic_launcher_mdpi.png')),
                        //     ],
                        //   ),
                        // ),

                        Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          margin: EdgeInsets.symmetric(vertical: 6.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Tosty ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 34),
                                  ),
                                  Text(
                                    'Software Solutions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              Text(
                                'and Network Designs, Lahore',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 360,
                    padding: EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: Text(
                      'LSD',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                // Meri Image wali Row
                children: <Widget>[
                  Container(
                    //whole meri pic wala container
                    width: 360,
                    height: 210,
                    padding: EdgeInsets.fromLTRB(44, 0, 0, 0),
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.all(8.0),
                          padding: EdgeInsets.symmetric(vertical: 90.0),
                          // color: Colors.amber,

                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  child: Text(
                                    'SP18',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          // color: Colors.brown,
                          // margin: EdgeInsets.symmetric(vertical: 8.0),
                          margin: EdgeInsets.fromLTRB(0, 0, 19, 0),
                          child: Column(
                            children: <Widget>[
                              // SizedBox(width: 55.0,
                              // ),
                              Image(
                                image: AssetImage('images/tictactoelogo.png'),
                                height: 180,
                                width: 260,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                //meri written info wali row
                children: <Widget>[
                  Container(
                    //whole upper container
                    width: 360,
                    height: 130,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.symmetric(vertical: 2.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Waqad',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                ),
                                Text(
                                  'Des: Lead Developer at Tosty Developers ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                                Text(
                                  'Phone No. # +92304-3211321',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                                // Image(image: AssetImage('assets/5.jpg'),
                                //   width: 250.0,
                                //   height: 30.0,),
                                Text(
                                  'Email: waqadarshad2@gmail.com',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                //Department info wali row
                children: <Widget>[
                  Container(
                    //whole upper container
                    width: 360,
                    height: 60,
                    // padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    color: Colors.blue,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(6.0),
                            margin: EdgeInsets.symmetric(vertical: 1.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Department of',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                                Text(
                                  'Mobile Development',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


