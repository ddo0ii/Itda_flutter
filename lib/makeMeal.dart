//https://minwook-shin.github.io/flutter-use-image-picker/ -->imagepicker
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itda/help.dart';
import 'package:itda/mealList.dart';

class MakeMeal extends StatefulWidget {
  String mealKey="키";
  MakeMeal({Key key,@required this.mealKey}) : super(key: key);
  @override
  _MakeMealState createState() => _MakeMealState();
}

class _MakeMealState extends State<MakeMeal> {
  File _image1, _image2, _image3, _image4, _image5, _image6 = null;
  final _formKey = GlobalKey<FormState>();
  bool tansu = false;
  bool danback = false;
  bool jibang = false;
  bool vitamin = false;
  bool moogi = false;
  bool water = false;

  String pic1 = "픽쳐";
  String pic2 = "픽쳐";
  String pic3 = "픽쳐";
  String pic4 = "픽쳐";
  String pic5 = "픽쳐";
  String pic6 = "픽쳐";
  String pic1n = "픽쳐";
  String pic2n = "픽쳐";
  String pic3n = "픽쳐";
  String pic4n = "픽쳐";
  String pic5n = "픽쳐";
  String pic6n = "픽쳐";


  static int mindex = 1;
  String mindexing = "$mindex";

  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = -1;
  dynamic data = "데이터";
  int total = 0;

  Future<String> getUser () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("loginInfo").document(user.email);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        email =snapshot.data["email"];
        nickname =snapshot.data["nickname"];
        school = snapshot.data["schoolname"];
        grade = snapshot.data["grade"];
        clas = snapshot.data["class"];
        point = snapshot.data["point"];
      });
    });
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _imgUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _ImageURL1 = "url";
  String _ImageURL2 = "url";
  String _ImageURL3 = "url";
  String _ImageURL4 = "url";
  String _ImageURL5 = "url";
  String _ImageURL6 = "url";

  @override
  void initState() {
    super.initState();
    getUser();
    _prepareService();
    print('hello'+widget.mealKey);
  }

  void _prepareService() async {
    _imgUser = await _firebaseAuth.currentUser();
  }

  void setTapping()async{
    await Firestore.instance.collection('mealList').document(widget.mealKey)
        .setData({'email':email, 'nickname':nickname, 'school':school, 'clas':clas, 'grade':grade, 'mindexing':mindexing, 'mealKey':widget.mealKey,
      'tansu':tansu, 'danback':danback, 'jibang': jibang, 'vitamin' : vitamin, 'moogi' : moogi, 'water' : water,
      'pic1' : _ImageURL1, 'pic2' : _ImageURL2, 'pic3' : _ImageURL3, 'pic4' : _ImageURL4, 'pic5' : _ImageURL5, 'pic6' : _ImageURL6,
      'pic1n' : pic1n, 'pic2n' : pic2n, 'pic3n' : pic3n, 'pic4n' : pic4n, 'pic5n' : pic5n, 'pic6n' : pic6n, 'total':total});
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage('assets/oneline.png'),
                  height: screenWidth*0.1,
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
                          Container(
                            width: screenWidth*0.12,
                            height: screenWidth*0.12,
                            child: Image.asset('assets/rice_green.png'),
                            //color: Colors.white,
                          ),
                          Container(height: screenWidth*0.02,),
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
                    Container(height: screenWidth*0.02),
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
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(height: screenWidth*0.02,),
                    Container(
                      width: screenWidth*0.9,
                      height: screenWidth*0.8,
                      decoration: BoxDecoration(
                        color: Color(0xfff2f2f2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _smallImageItem(getGalleryImage1, _image1, pic1n, "one"),
                                _smallImageItem(getGalleryImage2, _image2, pic2n, "two"),
                                _smallImageItem(getGalleryImage3, _image3, pic3n, "three"),
                                _smallImageItem(getGalleryImage4, _image4, pic4n, "four"),
                              ],
                            ),
                          ),
                          Container(height: screenWidth*0.02,),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _bigImageItem(getGalleryImage5, _image5, pic5n, "five"),
                                _bigImageItem(getGalleryImage6, _image6, pic6n, "six"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(height: screenWidth*0.02,),
                          Container(
                            width: screenWidth*0.3,
                            height: screenWidth*0.1,
                            decoration: BoxDecoration(
                                color: const Color(0xfffbb359)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '영양소 확인',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Arita-dotum-_OTF",
                                    fontStyle: FontStyle.normal,
                                    fontSize: screenWidth*0.045,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: screenWidth*0.8,
                            height: screenWidth*0.35,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xfffbb359)
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _nutrients(tansu, "탄수화물"),
                                    _nutrients(danback, "단백질"),
                                    _nutrients(jibang, "지방"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _nutrients(vitamin, "비타민"),
                                    _nutrients(moogi, "무기질"),
                                    _nutrients(water, "물"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: screenWidth*0.02,),
                    Container(
                      width: screenWidth*0.8,
                      height: screenWidth*0.15,
                      decoration: BoxDecoration(
                        color: Color(0xfffff7ef),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      ),
                      child: InkWell(
                        child: GestureDetector(
                          child: _wPBuildConnectItem('assets/itda_orange.png', '잇기(올리기)'),
                          onTap: () {
                            setTapping();
                            Navigator.pop(context, MaterialPageRoute(builder: (context) => MealList()));
                          },
                        ),
                      ),
                    ),
                    Container(height: screenWidth*0.02,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void getGalleryImage1() async {
    File image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    //var image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image1 == null) return;
    setState(() {
      _image1 = image1;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}1_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image1);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL1 = downloadURL;
    });
  }
  void getGalleryImage2() async {
    File image2 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    if(image2 == null) return;
    setState(() {
      _image2 = image2;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}2_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image2);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL2 = downloadURL;
    });
  }
  void getGalleryImage3() async {
    File image3 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    if(image3 == null) return;
    setState(() {
      _image3 = image3;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}3_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image3);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL3 = downloadURL;
    });
  }
  void getGalleryImage4() async {
    File image4 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    if(image4 == null) return;
    setState(() {
      _image4 = image4;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}4_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image4);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL4 = downloadURL;
    });
  }
  void getGalleryImage5() async {
    File image5 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    if(image5 == null) return;
    setState(() {
      _image5 = image5;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}5_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image5);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL5 = downloadURL;
    });
  }
  void getGalleryImage6() async {
    File image6 = await ImagePicker.pickImage(source: ImageSource.gallery);
    DateTime nowtime = new DateTime.now();
    if(image6 == null) return;
    setState(() {
      _image6 = image6;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("foodImg/${_imgUser.uid}6_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(_image6);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _ImageURL6 = downloadURL;
    });
  }
  Widget _wPBuildConnectItem( String wPimgPath, String wPlinkName) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: screenWidth*0.08,
            height: screenWidth*0.08,
            child: Image.asset(wPimgPath),
            //color: Colors.white,
          ),
          Container(
            height: screenWidth*0.004,
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
  Widget _smallImageItem(Function gettingImg, File sImgPath, String sImgName, String i){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: gettingImg,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Container(
                    height: screenWidth*0.23,
                    width: screenWidth*0.8/4.0,
                    child: sImgPath == null ?
                    Container(child: Image.asset('assets/add_photo.png'),)
                        : Image.file(sImgPath),
                    decoration: BoxDecoration(
                      color: Color(0xffd1dad5),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Container(
                    height: screenWidth*0.08,
                    width: screenWidth*0.8/4.0,
                    child: TextFormField(
                      maxLines: 1,
                      //onChanged: (text) => sImgName = text,
                      onChanged: (String value) {
                        setState(() {
                          switch(i){
                            case "one":
                              pic1n = value;
                              break;
                            case "two" :
                              pic2n = value;
                              break;
                            case "three" :
                              pic3n = value;
                              break;
                            case "four" :
                              pic4n = value;
                              break;
                          }
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return '이름쓰기';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        //hintText: '이름쓰기',
                        //labelText: "Enter your username",
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
  Widget _bigImageItem(Function gettingImg, File bImgPath, String bImgName, String i){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: gettingImg,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: screenWidth*0.23,
                    width: screenWidth*0.7/2.0,
                    child: bImgPath == null ?
                    Container(child: Image.asset('assets/add_photo.png'),)
                        : Image.file(bImgPath),
                    decoration: BoxDecoration(
                      color: Color(0xffd1dad5),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Container(
                    height: screenWidth*0.09,
                    width: screenWidth*0.7/2.0,
                    child: TextFormField(
                      maxLines: 1,
                      onChanged: (String value) {
                        setState(() {
                          switch(i){
                            case "five":
                              pic5n = value;
                              break;
                            case "six" :
                              pic6n = value;
                              break;
                          }
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return '이름쓰기';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        //hintText: '이름쓰기',
                        //labelText: "Enter your username",
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
  Widget _nutrients(bool nuVal, String nuName){
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: nuVal,
          onChanged: (bool value) {
            setState(() {
              switch(nuName){
                case "탄수화물" :
                  tansu = value;
                  break;
                case "단백질" :
                  danback = value;
                  break;
                case "지방" :
                  jibang = value;
                  break;
                case "비타민" :
                  vitamin = value;
                  break;
                case "무기질" :
                  moogi = value;
                  break;
                case "물" :
                  water = value;
                  break;
              }
            });
          },
        ),
        Text(nuName,
          style: TextStyle(
            fontSize: screenWidth*0.03,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}