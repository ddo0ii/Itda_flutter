import 'package:flutter/material.dart';
import 'signup.dart';
import 'profile.dart';
import 'home.dart';
import 'goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final databaseReference = Firestore.instance;

String _email;
String _password;
final FirebaseAuth _auth = FirebaseAuth.instance;


GlobalKey<FormState> _loginKey = GlobalKey<FormState>(debugLabel: '_loginkey');
final form = _loginKey.currentState;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();


  void validateAndSubmit() async {
    if (form.validate()) {
      try {
        form.save();
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(
            email: _email, password: _password)).user;
        print('Signed In: ${user.uid}');
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print('Error: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenHeight*0.2,),
              Container(
                width: screenWidth*0.25,
                child: Image.asset('assets/Font.png'),
              ),
              SizedBox(height: screenHeight*0.28,),
              Form(
                key: _loginKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: screenWidth*0.8,
                      height: screenWidth*0.18,
                      color: HexColor("#e9f4eb"),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: '아이디',
                          filled: true,
                          fillColor: HexColor("#e9f4eb"),
                        ),
                        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                        onSaved: (value) => _email = value,
                      ),
                    ),
                    Container(height: screenWidth*0.02,),
                    Container(
                      width: screenWidth*0.8,
                      height: screenWidth*0.18,
                      color: HexColor("#e9f4eb"),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: '비밀번호',
                          filled: true,
                          fillColor: HexColor("#e9f4eb"),
                        ),
                        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                        onSaved: (value) => _password = value,
                        obscureText: true,
                      ),
                    ),
                    Container(height: screenWidth*0.03,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ButtonTheme(
                            minWidth: screenWidth*0.39,
                            height: screenWidth*0.13,
                            child: RaisedButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: HexColor("#53975c")),
                              ),
                              child: Text(
                                '회원가입',
                                style: TextStyle(
                                  fontSize: screenWidth*0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignupPage()));
                              },
                            ),
                          ),
                          Container(width: screenWidth*0.02,),
                          ButtonTheme(
                            minWidth: screenWidth*0.39,
                            height: screenWidth*0.13,
                            child: RaisedButton(
                              color: HexColor("#55965e"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                '로그인',
                                style: TextStyle(
                                  fontSize: screenWidth*0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                validateAndSubmit();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.icon,
        this.hint,
        this.obsecure = false,
        this.validator,
        this.onSaved});
  final FormFieldSetter<String> onSaved;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        autofocus: true,
        obscureText: obsecure,
        style: TextStyle(
          fontSize: screenWidth*0.04,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth*0.04,),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 30, right: 10),
            )),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}