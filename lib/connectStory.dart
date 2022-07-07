import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itda/help.dart';
import 'package:itda/writeStory.dart';
import 'readStory.dart';

class ConnectStory extends StatefulWidget {
  @override
  _ConnectStoryState createState() => _ConnectStoryState();
}

class _ConnectStoryState extends State<ConnectStory> {
  String storyKey="";
  String stoKey = "";
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
      setState(() {
        nickname =snapshot.data["nickname"];
        school = snapshot.data["schoolname"];
        grade = snapshot.data["grade"];
        clas = snapshot.data["class"];
        point = snapshot.data["point"];
      });
    });
  }

  Future<String> storySettingDocument () async {
    DocumentReference storyDocumentReference = await Firestore.instance.collection('storyingList').add({});
    print(storyDocumentReference.documentID);
    if(this.mounted) {
      setState(() {
        storyKey = storyDocumentReference.documentID;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => WriteStory(storyKey: storyKey)));
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
              onPressed: () {
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
                "마음을 ",
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
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: screenHeight*0.08,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              width: screenWidth*0.6,
              height: screenHeight*0.06,
              decoration: BoxDecoration(
                color: Color(0xff53975c),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: screenWidth*0.065,
                    height: screenHeight*0.065,
                    child: Image.asset('assets/ink.png'),
                    //color: Colors.white,
                  ),
                  Container(width: screenWidth*0.05),
                  Container(
                    child: Text(
                      '이야기로 마음을 잇다',
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
            ),
            _slist(),
            SizedBox(height: screenHeight*0.01,),
            Container(
              child: Row(
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
                    child: InkWell(
                      child: _wPBuildConnectItem('assets/itda_orange.png', '글쓰기'),
                      onTap: () => {
                        storySettingDocument(),
                      },
                    ),
                  ),
                ],
              ),
            ),
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
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: screenWidth*0.2,
      height: screenHeight*0.08,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: screenWidth*0.07,
            height: screenHeight*0.025,
            child: Image.asset(wPimgPath),
            //color: Colors.white,
          ),
          Container(
            height: screenHeight*0.01,
          ),
          Container(
            child: Text(
              wPlinkName,
              style: TextStyle(
                color: Color(0xfffbb359),
                fontWeight: FontWeight.w700,
                fontFamily: "Arita-dotum-_OTF",
                fontStyle: FontStyle.normal,
                fontSize: screenWidth*0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _slist () {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('storyList').snapshots(),
          builder: (context, snapshot) {
            //if (!snapshot.hasData) return LinearProgressIndicator();
            final items = snapshot.data.documents;

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/user.png'),
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
                        Container(width: screenWidth*0.02,),
                        Text(item['school'],
                          style: TextStyle(
                            fontSize: screenWidth*0.04,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(item['ssubject'],),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReadStory(storyKey: item['storyKey'],))),
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
