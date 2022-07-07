import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itda/help.dart';
import 'package:itda/makeMeal.dart';
import 'package:itda/readMeal.dart';

class MealList extends StatefulWidget {
  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  String mealKey="";
  Firestore _firestore = Firestore.instance;
  FirebaseUser user ;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = -1;
  dynamic data;

  Future<String> getUser () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("loginInfo").document(user.email);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      if(this.mounted) {
        setState(() {
          email =snapshot.data["email"];
          nickname =snapshot.data["nickname"];
          school = snapshot.data["schoolname"];
          grade = snapshot.data["grade"];
          clas = snapshot.data["class"];
          point = snapshot.data["point"];
        });
      }
    });
  }

  Future<String> settingDocument () async {
    DocumentReference documentReference2 = await Firestore.instance.collection('mealingList').add({});
    print(documentReference2.documentID);
    if(this.mounted) {
      setState(() {
        mealKey = documentReference2.documentID;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => MakeMeal(mealKey: mealKey)));
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Image(
                image: AssetImage('assets/oneline.png'),
                height: screenWidth*0.15,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: screenWidth*0.12,
                          height: screenWidth*0.12,
                          child: Image.asset('assets/rice_green.png'),
                          //color: Colors.white,
                        ),
                        Container(
                          width: screenWidth*0.05,
                        ),
                        Container(
                          child: Text(
                            '우리들의 식단',
                            style: TextStyle(
                              color: Color(0xff53975c),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Arita-dotum-_OTF",
                              fontStyle: FontStyle.normal,
                              fontSize: screenWidth*0.04,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: screenWidth*0.025,),
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
                  Container(height: screenWidth*0.025,),
                  Container(
                    child: Text(
                        "친구들이 만든 식단은 어떨까요?\n가정에서도, 영양 선생님도 보시고 응원해주세요",
                        style: TextStyle(
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Arita-dotum-_OTF",
                          fontStyle: FontStyle.normal,
                          fontSize: screenWidth*0.035,
                        ),
                        textAlign: TextAlign.center
                    ),
                  ),
                ],
              ),
            ),
            Container(height: screenWidth*0.025,),
            _mlist(),
            Container(height: screenWidth*0.025,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xfffff7ef),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    ),
                  ),
                  child: GestureDetector(
                    child: _wPBuildConnectItem('assets/itda_orange.png', '식단짜기'),
                    onTap: () => {
                      settingDocument(),
                    },
                  ),
                ),
              ],
            ),
            Container(height: screenWidth*0.025,),
          ],
        ),
      ),
    );
  }
  Widget _wPBuildConnectItem(String wPimgPath, String wPlinkName) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      width: screenWidth*0.2,
      height: screenWidth*0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: screenWidth*0.07,
            height: screenWidth*0.07,
            child: Image.asset(wPimgPath),
            //color: Colors.white,
          ),
          Container(
            height: screenWidth*0.015,
          ),
          Container(
            child: Text(
              wPlinkName,
              style: TextStyle(
                color: Color(0xfffbb359),
                fontWeight: FontWeight.w700,
                fontFamily: "Arita-dotum-_OTF",
                fontStyle: FontStyle.normal,
                fontSize: screenWidth*0.025,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _mlist () {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    //final srecord = SRecord.fromSnapshot(data);
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('mealList').snapshots(),
          builder: (context, snapshot) {
            final items = snapshot.data.documents;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/user.png'),
                      backgroundColor: Colors.white,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(item['nickname'],
                          style: TextStyle(
                            fontSize: screenWidth*0.055,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black,
                          ),
                        ),
                        Container(width: screenWidth*0.03,),
                        Text(item['school'],
                          style: TextStyle(
                            fontSize: screenWidth*0.04,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Text(item['grade']),
                        Text('학년 '),
                        Text(item['clas']),
                        Text('반'),
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReadMeal(mealKey: item['mealKey']))),
                    },
                    //selected: true,
                  ),
                );
              },
            );
          }
      ),
    );
  }
}