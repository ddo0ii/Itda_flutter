import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itda/goal_edit.dart';
import 'goal_edit.dart';
import 'package:itda/goal_list.dart';
import 'goal_list.dart';


class GoalEditPage extends StatefulWidget{
  String email;
  GoalEditPage({Key key,@required this.email}) : super(key: key);

  @override
  _GoalEditPageState createState() => _GoalEditPageState();
}

class _GoalEditPageState extends State<GoalEditPage> {
  final _todaytextController = TextEditingController();
  final _weektextController = TextEditingController();
  final _yeartextController = TextEditingController();

  String today =" ";
  String week = "";
  String year="";
  String nickname = "";
  String dream = "";
  String todayHint = "";
  String weekHint = "";
  String yearHint = "";
  FirebaseUser user ;
  bool _todayBool = false;
  bool _weekBool = false;
  bool _yearBool = false;

  void _todayhandleSubmitted(String text) {
    todayUpdate(text);
    if(this.mounted) {
      setState(() {
        today = text;
      });
    }
    _todaytextController.clear();
  }
  void _weekhandleSubmitted(String text) {
    weekUpdate(text);
    if(this.mounted) {
      setState(() {
        week = text;
      });
    }

    _weektextController.clear();
  }
  void _yearhandleSubmitted(String text) {
    yearUpdate(text);
    if(this.mounted) {
      setState(() {
        year = text;
      });
    }

    _yeartextController.clear();
  }

  Widget _todaybuildTextComposer(double width, double height) {
    return  Container(
      width: width,
      height: height,
      child:  TextField(
        controller: _todaytextController,
        onSubmitted: _todayhandleSubmitted,
        decoration:  InputDecoration(
            filled: true,
            fillColor: HexColor("#fff7ef"),
            border: InputBorder.none,
            hintText: todayHint),
      ),
    );
  }

  Widget _weekbuildTextComposer(double width, double height)  {
    return  Container(
      width: width,
      height: height,
      child:  TextField(
        controller: _weektextController,
        onSubmitted: _weekhandleSubmitted,
        decoration:  InputDecoration(
            filled: true,
            fillColor: HexColor("#fff7ef"),
            border: InputBorder.none,
            hintText: weekHint),
      ),
    );
  }

  Widget _yearbuildTextComposer(double width, double height)  {
    return  Container(
      width: width,
      height: height,
      child:  TextField(
        controller: _yeartextController,
        onSubmitted: _yearhandleSubmitted,
        decoration:  InputDecoration(
            filled: true,
            fillColor: HexColor("#fff7ef"),
            border: InputBorder.none,
            hintText: yearHint),
      ),
    );
  }

  Future<String> getUser () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("loginInfo").document(widget.email);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      if(this.mounted) {
        setState(() {
          today = snapshot.data["today"];
          week = snapshot.data["week"];
          year = snapshot.data["year"];
          nickname = snapshot.data["nickname"];
          dream = snapshot.data["dream"];
          _todayBool = snapshot.data["todaycheck"];
          _weekBool = snapshot.data["weekcheck"];
          _yearBool = snapshot.data["yearcheck"];
          todayHint = snapshot.data["today"];
          weekHint = snapshot.data["week"];
          yearHint = snapshot.data["year"];
        });
      }
    });
  }

  Future<void> todayUpdate(String today) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'today' : today,
    });
  }

  Future<void> weekUpdate(String week) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'week' : week,
    });
  }

  Future<void> yearUpdate(String year) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'year' : year,
    });
  }

  Future<void> _todayCheckUpdate(bool check) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'todaycheck' : check,
    });
  }

  Future<void> _weekCheckUpdate(bool check) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'weekcheck' : check,
    });
  }

  Future<void> _yearCheckUpdate(bool check) async {
    final user = await FirebaseAuth.instance.currentUser();
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'yearcheck' : check,
    });
  }

  Future<void> _todayChecker(bool check) async {
    final user = await FirebaseAuth.instance.currentUser();

    if(user.email == widget.email){
      return  _todayCheck(check);
    }
    else
      return null;
  }

  Future<void> _weekChecker(bool check) async {
    final user = await FirebaseAuth.instance.currentUser();

    if(user.email == widget.email){
      return  _weekCheck(check);
    }
    else
      return null;
  }

  Future<void> _yearChecker(bool check) async {
    final user = await FirebaseAuth.instance.currentUser();

    if(user.email == widget.email){
      return  _yearCheck(check);
    }
    else
      return null;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void _todayCheck(bool check){
    _todayCheckUpdate(check);
    if(this.mounted) {
      setState(() {
        _todayBool = check;
      });
    }
  }

  void _weekCheck(bool check){
    _weekCheckUpdate(check);
    if(this.mounted) {
      setState(() {
        _weekBool = check;
      });
    }
  }

  void _yearCheck(bool check){
    _yearCheckUpdate(check);
    if(this.mounted) {
      setState(() {
        _yearBool = check;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    getUser();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: HexColor("#e9f4eb"),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: (){
                Navigator.of(context).pop();
              }
          ),
          actions: [

          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "목표를 ",
                style: TextStyle(
                  fontSize: screenWidth*0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                width: 28,
                child: Image.asset("assets/Itda_black.png"),
              ),
            ],
          )
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: screenHeight*0.025,),
              Text(
                "친구들의 목표를 보며 응원의 댓글을 남기면\n 더 잘할 수 있어요",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth*0.035,
                ),
              ),
              Container(height: screenHeight*0.02,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      width: screenWidth*0.35,
                      child: Divider(thickness: 1),
                    ),
                    Container(
                      child: Icon(
                        Icons.star,
                        color: Color(0xfffbb359),
                        size: screenWidth*0.04,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      width: screenWidth*0.35,
                      child: Divider(thickness: 1),
                    ),
                  ],
                ),
              ),
              Container(height: screenHeight*0.01,),
              Container(
                height: screenWidth * 0.4,
                width: screenWidth * 0.4,
                child:  Image.asset(
                  'assets/tree.png',
                  fit: BoxFit.contain,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nickname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*0.05,
                      color: HexColor("#53975c"),
                    ),
                  ),
                  Text(
                      "님의 꿈은"
                  )
                ],
              ),
              Container(height: screenHeight*0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dream,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*0.05,
                      color: HexColor("#fbb359"),
                    ),
                  ),
                  Text(
                      "입니다"
                  )
                ],
              ),
              Container(height: screenHeight*0.01),
              Container(
                padding: EdgeInsets.all(screenWidth*0.033),
                width: screenWidth*0.9,
                height: screenHeight*0.35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0) //                 <--- border radius here
                    ),
                    border: Border.all(color: HexColor("#96fab259"))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "오늘의 목표",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth*0.03,
                          ),
                        ),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: HexColor("#fab259")),
                          child: Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              checkColor: Colors.white,
                              activeColor: HexColor("#fab259"),
                              value: _todayBool,
                              onChanged: _todayChecker
                          ),
                        ),
                      ],
                    ),
                    _todaybuildTextComposer(screenWidth*0.8,screenWidth*0.07),
                    Container(height: screenHeight*0.02,),
                    Row(
                      children: [
                        Text(
                          "이번 달의 목표",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth*0.03,
                          ),
                        ),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: HexColor("#fab259")),
                          child: Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              checkColor: Colors.white,
                              activeColor: HexColor("#fab259"),
                              value: _weekBool,
                              onChanged: _weekChecker
                          ),
                        ),
                      ],
                    ),
                    _weekbuildTextComposer(screenWidth*0.8,screenWidth*0.07),
                    Container(height: screenHeight*0.02,),
                    Row(
                      children: [
                        Text(
                          "올해의 목표",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth*0.03,
                          ),
                        ),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: HexColor("#fab259")),
                          child: Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              checkColor: Colors.white,
                              activeColor: HexColor("#fab259"),
                              value: _yearBool,
                              onChanged: _yearChecker
                          ),
                        ),
                      ],
                    ),
                    _yearbuildTextComposer(screenWidth*0.8,screenWidth*0.07),
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