import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:itda/help.dart';
import 'package:itda/schoolMeal.dart';
import 'package:itda/mealList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class ConnectMeal extends StatefulWidget {
  @override
  _ConnectMealState createState() => _ConnectMealState();
}

class _ConnectMealState extends State<ConnectMeal> {
  Firestore _firestore = Firestore.instance;
  FirebaseUser user ;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = 0;
  dynamic data;

  Future<String> getUser () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("loginInfo").document(user.email);

    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        nickname =snapshot.data["nickname"];
        school = snapshot.data["schoolname"];
        grade = snapshot.data["grade"];
        clas = snapshot.data["class"];
        point = snapshot.data["point"];
      });
    });
  }

  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xffe9f4eb),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.help,
                color: Color(0xfffbb359),
              ),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpPage()));
              },
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "식사를 ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                width: 28,
                child: Image.asset('assets/Itda_black.png'),
              ),
            ],
          )
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage('assets/oneline.png'),
                  height: screenHeight*0.07,
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(height: screenHeight*0.15,),
                    Container(
                      child: Text(
                          "우리학교 식단을 보고\n내가먹고 싶은 메뉴를 계획하여\n가정과 학교에서 볼 수 있어요.",
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Arita-dotum-_OTF",
                            fontStyle: FontStyle.normal,
                            fontSize: screenWidth*0.04,
                          ),
                          textAlign: TextAlign.center
                      ),
                    ),
                    Container(height: screenHeight*0.015,),
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
                              size: screenWidth*0.05,
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
                    Container(height: screenHeight*0.02,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: _buildConnectItem('assets/school_white.png', '우리 학교 식단'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SchoolMeal()));
                            },
                          ),
                          Container(width: screenWidth*0.05,),
                          InkWell(
                            child: _buildConnectItem('assets/rice_white.png', '우리들의 식단'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MealList()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: screenHeight*0.5,),
            ],
          ),
        ),
      ),

    );
  }
  Widget _buildConnectItem(String imgPath, String linkName) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      width: screenWidth*0.35,
      height: screenWidth*0.35,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: Color(0xffb5c8bc),
          offset: Offset(0,10),
          blurRadius: 20,
          spreadRadius: 0,
        )] ,
        color: Color(0xff53975c),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: screenWidth*0.12,
            height: screenWidth*0.12,
            child: Image.asset(imgPath),
            //color: Colors.white,
          ),
          Container(
            height: screenWidth*0.025,
          ),
          Container(
            child: Text(
              linkName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: "Arita-dotum-_OTF",
                fontStyle: FontStyle.normal,
                fontSize: screenWidth*0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }
}