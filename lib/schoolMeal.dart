import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:itda/help.dart';
import 'package:itda/schoolMeal.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itda/schoolMeal_edit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';

var Pass;
class SchoolMeal extends StatefulWidget {
  @override
  _SchoolMealState createState() => _SchoolMealState();
}

class _SchoolMealState extends State<SchoolMeal> {
  var today_date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  int favoriteNum = 0;
  FirebaseUser user;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = -1;
  dynamic data;
  final _formKey = GlobalKey<FormState>();

  String _date1, _date2, _date3, _date4, _date5, _date6, _date7 = "1";
  File _image1, _image2, _image3, _image4, _image5, _image6, _image7, _image8, _image9, _image10, _image11, _image12, _image13, _image14 = null;
  String pic1, pic2, pic3, pic4, pic5, pic6, pic7, pic8, pic9, pic10, pic11, pic12, pic13, pic14 = "픽쳐";
  String pic1n = "식단";
  String pic2n = "알레르기정보";
  String schoolName = "학교이름";
  bool admin;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _schoolImgUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String _ImageURL1,_ImageURL2, _ImageURL3, _ImageURL4, _ImageURL5,_ImageURL6, _ImageURL7, _ImageURL8,_ImageURL9, _ImageURL10, _ImageURL11, _ImageURL12, _ImageURL13, _ImageURL14 = "url";

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
        admin = snapshot.data["admin"];
      });
    });
  }

  Future<String> getSchoolMeal() async {
    _schoolImgUser = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("schoolMealList").document(school);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        _image1 = snapshot.data["_image1"];
        _image2 = snapshot.data["_image2"];
        pic1 = snapshot.data["pic1"];
        pic2 = snapshot.data["pic2"];
        pic1n = snapshot.data["pic1n"];
        pic2n = snapshot.data["pic2n"];
        _date1 = snapshot.data["_date1"];
        _date2 = snapshot.data["_date2"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    _prepareService();
  }

  void _prepareService() async {
    _schoolImgUser = await _firebaseAuth.currentUser();
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(school).orderBy('email', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildGridView(context);
      },
    );
  }

  Widget _buildGridView(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //상단 이미지
                  Container(
                    child: Image(
                      image: AssetImage('assets/oneline.png'),
                      height: screenWidth*0.12,
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //학교 이미지
                              Container(
                                width: screenWidth*0.15,
                                child: Image.asset('assets/school_green.png'),
                                //color: Colors.white,
                              ),
                              Container(height: screenWidth*0.025,),
                              //학교 이름
                              Container(
                                child: Text(
                                  school,
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
                        Container(height: screenWidth*0.02,),
                        //바
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
                                  size: screenWidth*0.07,
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
                        Container(height: screenWidth*0.02,),
                      ],
                    ),
                  ),
                  _dayItems(pic1, pic2, '시작 일  :  ', '마지막 일  :  ', _date1, _date2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getSchoolMeal();
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: HexColor("#e9f4eb"),
          centerTitle: true,
          actions: [
            InkWell(
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: HexColor("#fbb359"),
                  //size: 12,
                ),
              ),
              onTap: (){
                if(admin == true) {
                  getSchoolMeal();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SchoolMealEdit()));
                }
              },
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "식사를 ",
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
      body: _buildBody(context),
    );
  }

  Widget _dayItems(String ImgRPath1, String ImgRPath2, String day1, String day2, String dating1, String dating2){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Column(
        children: <Widget>[
          //닐짜
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(width: screenWidth*0.05,),
              Container(
                child: Text(
                  day1,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: "Arita-dotum-_OTF",
                    fontStyle: FontStyle.normal,
                    fontSize: screenWidth*0.04,
                  ),
                ),
              ),
              Container(
                child: dating1 == null ?
                Text('')
                    :
                Text(
                    dating1,
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
            ],
          ),
          Container(height: screenWidth*0.02,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(width: screenWidth*0.05,),
              Container(
                child: Text(
                  day2,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: "Arita-dotum-_OTF",
                    fontStyle: FontStyle.normal,
                    fontSize: screenWidth*0.04,
                  ),
                ),
              ),
              Container(
                child: dating2 == null ?
                Text('')
                    :
                Text(
                    dating2,
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
            ],
          ),
          Container(height: screenWidth*0.03,),
          //식단이미지
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            width: screenWidth*0.9,
            height: screenWidth*0.7,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffb5c8bc),
              ),
              color: Colors.white,
            ),
            child: _smallImageItem(ImgRPath1),
          ),
          //알레르기 정보
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: screenWidth*0.03,
                ),
                Container(
                  width: screenWidth*0.4,
                  height: screenWidth*0.1,
                  decoration: BoxDecoration(
                      color: const Color(0xfffbb359)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '알레르기 정보',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Arita-dotum-_OTF",
                          fontStyle: FontStyle.normal,
                          fontSize: screenWidth*0.04,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth*0.9,
                  height: screenWidth*0.5,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xfffbb359)
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: _ssmallImageItem(ImgRPath2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: screenWidth*0.02,),
        ],
      ),
    );
  }

  Widget _smallImageItem(String sImgPath){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: Container(
                  width: screenWidth*0.8,
                  height: screenWidth*0.6,
                  child: sImgPath == null ?
                  Container(child: Image.asset('assets/add_photo.png'),)
                      : Container(
                    height: screenHeight*0.12,
                    width: screenWidth*0.8/4.0,
                    decoration: BoxDecoration(
                      color: Color(0xffd1dad5),
                      image: DecorationImage(image: NetworkImage(sImgPath),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ssmallImageItem(String sImgPath){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: Container(
                  width: screenWidth*0.8,
                  height: screenWidth*0.4,
                  child: sImgPath == null ?
                  Container(child: Image.asset('assets/add_photo.png'),)
                      : Container(
                    height: screenHeight*0.12,
                    width: screenWidth*0.8/4.0,
                    decoration: BoxDecoration(
                      color: Color(0xffd1dad5),
                      image: DecorationImage(image: NetworkImage(sImgPath),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}