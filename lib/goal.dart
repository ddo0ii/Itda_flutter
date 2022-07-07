import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itda/goal_edit.dart';
import 'goal_edit.dart';
import 'package:itda/goal_list.dart';
import 'goal_list.dart';
import 'dart:io';


class GoalPage extends StatefulWidget{
  String email;
  GoalPage({Key key,@required this.email}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {

  String today =" ";
  String week = "";
  String year="";
  String nickname = "";
  String dream = "";
  String comment = "";
  FirebaseUser user ;
  bool _todayBool = false;
  bool _weekBool = false;
  bool _yearBool = false;
  int favoriteNum = 0;
  int totalFavoriteNum ;
  int point;
  int index;
  final _chatController = TextEditingController();

  Widget _chatList () {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('loginInfo').document(widget.email).collection("chatInfo").orderBy("index").snapshots(),
        builder: (context, snapshot) {
          final items = snapshot.data.documents;
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                child: ListTile(
                  title: Text(item['nickname'],
                    style: TextStyle(
                      fontSize: screenWidth*0.055,
                      fontWeight: FontWeight.bold,
                      //color: Colors.black,
                    ),
                  ),
                  subtitle: Text(item['comment'],
                    style: TextStyle(
                      fontSize: screenWidth*0.035,
                    ),
                  ),
                ),
              );
            },
          );
        }
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
          totalFavoriteNum = snapshot.data["total"];
          point = snapshot.data["point"];
          index = snapshot.data["index"];
        });
      }
    });

  }


  //좋아요를 눌렀는지 아닌지 알기 위
  Future<String> getLike () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("loginInfo").document(user.email)
    .collection("likeInfo").document(widget.email);

    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      if(this.mounted) {
        setState(() {
          favoriteNum = snapshot.data['favoriteNum'];
        });
      }
    });
  }

  Future<void> totalLikeUpdate (int num) async {
    DocumentReference documentReference = await Firestore.instance.collection("loginInfo").document(widget.email);

    await documentReference.updateData(<String, dynamic>{
      'total' : totalFavoriteNum+num,
    });
  }

  Future<void> likeAddUpdate () async {
    DocumentReference documentReference = await Firestore.instance.collection("loginInfo").document(user.email)
        .collection("likeInfo").document(widget.email);

    documentReference.setData(<String, dynamic>{
      'favoriteNum' : 1,
    });

    favoriteNum = 1;
  }

  void _chathandleSubmitted(String text) {
    _setChat(text);
    if(this.mounted) {
      setState(() {
        comment = text;
      });
    }
    _chatController.clear();
  }

  Widget _chatbuildTextComposer(double width, double height) {

    return  Container(
      width: width,
      height: height,
      child:  TextField(
        controller: _chatController,
        decoration:  InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10,0,0,0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: HexColor("#53965c")),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: HexColor("#53965c")),
          ),
          hintText: "응댓 입력..."
        ),
      ),
    );
  }

  Future<void> _setChat (String comment) async {
    String _nickname;
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference3 =  Firestore.instance.collection("loginInfo").document(user.email);

    await documentReference3.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      if(this.mounted) {
        setState(() {
          _nickname = snapshot.data["nickname"];
        });
      }
    });

    DocumentReference documentReference2 = await Firestore.instance.collection("loginInfo").document(widget.email);
    index += 1;

    documentReference2.updateData(<String, dynamic>{
      'index' : index
    });

    await documentReference2.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      if(this.mounted) {
        setState(() {
          index = snapshot.data['index'];
        });
      }
    });

    DocumentReference documentReference = await Firestore.instance.collection("loginInfo").document(widget.email)
        .collection("chatInfo").document("$index");

    documentReference.setData(<String, dynamic>{
      'nickname' : _nickname,
      'comment' : comment,
      'index' : index,
    });
  }

  Future<void> likeSubUpdate () async {
    DocumentReference documentReference = await Firestore.instance.collection("loginInfo").document(user.email)
        .collection("likeInfo").document(widget.email);

    documentReference.setData(<String, dynamic>{
      'favoriteNum' : 0,
    });

    favoriteNum = 0;
  }

  Future<void> pointUpdate(int num) async {
    final user = await FirebaseAuth.instance.currentUser();

    DocumentReference documentReference = await Firestore.instance.collection("loginInfo").document(user.email);

    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      if(this.mounted) {
        setState(() {
          point = snapshot.data['point'];
        });
      }
    });
    print("$point + $num");
    return Firestore.instance.collection('loginInfo').document(user.email).updateData(<String, dynamic>{
      'point' : point+num ,
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


  Future<void> _editChecker() async {
    final user = await FirebaseAuth.instance.currentUser();
    if(user.email == widget.email){
      return  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoalEditPage(email: widget.email)));
    }
    else
      return null;
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getLike();
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
          actions: [
            InkWell(
              child: Container(
                width: screenWidth*0.1,
                height: screenHeight*0.1,
                child: Image.asset("assets/modify.png"),
              ),
              onTap: (){
                _editChecker();
              },
            ),
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
                width: screenWidth*0.06,
                child: Image.asset("assets/Itda_black.png"),
              ),
            ],
          )
      ),
      backgroundColor: Colors.white,
      body:  SingleChildScrollView(
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
                      " 님의 꿈은"
                  )
                ],
              ),
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
                      " 입니다"
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(screenWidth*0.05, 0,0,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "좋아요",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        favoriteNum == 1 ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: screenHeight*0.033,
                      ),
                      onPressed: (){
                        getLike();
                        if(favoriteNum == 1) {
                          setState(() {
                            likeSubUpdate(); //FavoriteNUm 을 0으로
                            totalLikeUpdate (-1);
                            pointUpdate(-100);
                          });
                        }
                        else{
                          setState(() {
                            likeAddUpdate(); ////FavoriteNUm 을 1으로
                            totalLikeUpdate (1);
                            pointUpdate(100);
                          });
                        }
                      },
                    ),
                    Text(
                      "$totalFavoriteNum",
                      style: TextStyle(
                        fontSize: screenWidth*0.033,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(screenWidth*0.033, screenHeight*0.01, screenWidth*0.033, screenHeight*0.01),
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
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            width: screenWidth*0.8,
                            height: screenWidth*0.07,
                            decoration: BoxDecoration(
                              color: HexColor("#fff7ef"),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0,0,0),
                                ),
                                Text(
                                  today,
                                  style: TextStyle(
                                      fontSize: screenWidth*0.033,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    Container(height: screenHeight*0.02),
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
                              onChanged: null
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            width: screenWidth*0.8,
                            height: screenHeight*0.04,
                            decoration: BoxDecoration(
                              color: HexColor("#fff7ef"),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0,0,0),
                                ),
                                Text(
                                  week,
                                  style: TextStyle(
                                      fontSize: screenWidth*0.033,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    Container(height: screenHeight*0.02),
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
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            width: screenWidth*0.8,
                            height: screenHeight*0.04,
                            decoration: BoxDecoration(
                              color: HexColor("#fff7ef"),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0,0,0),
                                ),
                                Text(
                                  year,
                                  style: TextStyle(
                                      fontSize: screenWidth*0.033,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              Container(
                width: screenWidth*0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight*0.07,),
                    _chatbuildTextComposer(screenWidth*0.8,screenHeight*0.04),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: HexColor("#53965c"),
                      ),
                      onPressed: (){
                        if(_chatController.text.isNotEmpty) {
                          pointUpdate(100);
                          _chathandleSubmitted(_chatController.text);
                        }
                      },
                    )
                  ],
                ),
              ),
              _chatList(),
            ],
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