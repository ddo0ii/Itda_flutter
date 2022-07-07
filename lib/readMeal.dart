//https://minwook-shin.github.io/flutter-use-image-picker/ -->imagepicker
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itda/help.dart';

class ReadMeal extends StatefulWidget {
  String mealKey;
  ReadMeal({Key key,@required this.mealKey}) : super(key: key);
  @override
  _ReadMealState createState() => _ReadMealState();
}

class _ReadMealState extends State<ReadMeal> {
  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  dynamic data;
  int favoriteNum = 0;
  int totalFavoriteNum ;
  int point;
  int index;
  final _chatController = TextEditingController();
  String comment = "";

  File _image1, _image2, _image3, _image4, _image5, _image6 = null;
  final _formKey = GlobalKey<FormState>();
  bool tansu = false;
  bool danback = false;
  bool jibang = false;
  bool vitamin = false;
  bool moogi = false;
  bool water = false;
  String pic1, pic2, pic3, pic4, pic5, pic6;
  String pic1n = "사진1";
  String pic2n = "사진2";
  String pic3n = "사진3";
  String pic4n = "사진4";
  String pic5n = "사진5";
  String pic6n = "사진6";
  static int mindex = 1;
  String mindexing = "$mindex";
  String mealKey="키값";

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _imgUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _ImageURL1 = "";
  String _ImageURL2 = "";
  String _ImageURL3 = "";
  String _ImageURL4 = "";
  String _ImageURL5 = "";
  String _ImageURL6 = "";

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
        index = snapshot.data["index"];
      });
    });
  }

  Future<String> getMeal() async {
    _imgUser = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("mealList").document(widget.mealKey);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        _image1 = snapshot.data["_image1"];
        _image2 = snapshot.data["_image2"];
        _image3 = snapshot.data["_image3"];
        _image4 = snapshot.data["_image4"];
        _image5 = snapshot.data["_image5"];
        _image6 = snapshot.data["_image6"];
        tansu = snapshot.data["tansu"];
        danback = snapshot.data["danback"];
        jibang = snapshot.data["jibang"];
        vitamin = snapshot.data["vitamin"];
        moogi = snapshot.data["moogi"];
        water = snapshot.data["water"];
        pic1 = snapshot.data["pic1"];
        pic2 = snapshot.data["pic2"];
        pic3 = snapshot.data["pic3"];
        pic4 = snapshot.data["pic4"];
        pic5 = snapshot.data["pic5"];
        pic6 = snapshot.data["pic6"];
        pic1n = snapshot.data["pic1n"];
        pic2n = snapshot.data["pic2n"];
        pic3n = snapshot.data["pic3n"];
        pic4n = snapshot.data["pic4n"];
        pic5n = snapshot.data["pic5n"];
        pic6n = snapshot.data["pic6n"];
        mindexing = snapshot.data["mindexing"];
        mealKey = snapshot.data["mealKey"];
        totalFavoriteNum = snapshot.data["total"];
      });
    });
  }

  Widget _chatList () {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('mealList').document(widget.mealKey).collection("mealChatInfo").orderBy("index").snapshots(),
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

  //좋아요를 눌렀는지 아닌지 알기 위
  Future<String> getLike () async {
    user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("mealList").document(widget.mealKey)
        .collection("mealLikeInfo").document(user.email);

    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      if(this.mounted) {
        setState(() {
          favoriteNum = snapshot.data['favoriteNum'];
        });
      }
    });
  }

  Future<void> totalLikeUpdate (int num) async {
    DocumentReference documentReference = await Firestore.instance.collection("mealList").document(widget.mealKey);

    await documentReference.updateData(<String, dynamic>{
      'total' : totalFavoriteNum+num,
    });
  }

  Future<void> likeAddUpdate () async {
    DocumentReference documentReference = await Firestore.instance.collection("mealList").document(widget.mealKey)
        .collection("mealLikeInfo").document(user.email);

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

    DocumentReference documentReference2 = await Firestore.instance.collection("loginInfo").document(widget.mealKey);
    documentReference2.updateData(<String, dynamic>{
      'index' : index+1
    });

    await documentReference2.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      if(this.mounted) {
        setState(() {
          index = snapshot.data['index'];
        });
      }
    });

    DocumentReference documentReference = await Firestore.instance.collection("mealList").document(widget.mealKey)
        .collection("mealChatInfo").document("$index");

    documentReference.setData(<String, dynamic>{
      'nickname' : _nickname,
      'comment' : comment,
      'index'  : index
    });
  }

  Future<void> likeSubUpdate () async {
    DocumentReference documentReference = await Firestore.instance.collection("mealList").document(widget.mealKey)
        .collection("mealLikeInfo").document(user.email);

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
    return Firestore.instance.collection('mealList').document(user.email).updateData(<String, dynamic>{
      'point' : point+num ,
    });

  }

  @override
  void initState() {
    super.initState();
    getUser();
    getMeal();
    getLike();
    _prepareService();
  }

  void _prepareService() async {
    _imgUser = await _firebaseAuth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    getMeal();
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
                  height: screenHeight*0.07,
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
                          Container(height: screenHeight*0.015,),
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
                    Container(height: screenHeight*0.015,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 00, 10, 0),
                            width: screenWidth*0.35,
                            child: Divider(thickness: 1),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 00, 0, 0),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(height: screenHeight*0.01,),
                    Container(
                      width: screenWidth*0.9,
                      height: screenHeight*0.4,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _smallImageItem(pic1, pic1n),
                                _smallImageItem(pic2, pic2n),
                                _smallImageItem(pic3, pic3n),
                                _smallImageItem(pic4, pic4n),
                              ],
                            ),
                          ),
                          Container(height: screenHeight*0.015,),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _bigImageItem(pic5, pic5n),
                                _bigImageItem(pic6, pic6n),
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
                          Container(height: screenHeight*0.015,),
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
                    Container(height: screenHeight*0.015,),
                    Container(height: screenWidth*0.02,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
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
                                ),
                                Container(width: screenWidth*0.03,),
                              ],
                            ),
                          ),
                          Container(width: screenWidth*0.03,),
                          Container(
                            width: screenWidth*0.2,
                            height: screenHeight*0.08,
                            decoration: BoxDecoration(
                              color: Color(0xfffff7ef),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                              ),
                            ),
                            child: InkWell(
                              child: _wPBuildConnectItem('assets/list.png','목록'),
                              onTap: () async{
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Container(width: screenWidth*0.05,),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth*0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight*0.07,),
                          _chatbuildTextComposer(screenWidth*0.75,screenHeight*0.04),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              color: HexColor("#53965c"),
                            ),
                            onPressed: (){
                              if(_chatController.text.isNotEmpty)
                                _chathandleSubmitted(_chatController.text);
                            },
                          )
                        ],
                      ),
                    ),
                    _chatList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
  Widget _smallImageItem(String sImgPath, String sImgName){
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
              Container(
                height: screenHeight*0.12,
                width: screenWidth*0.8/4.0,
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
                decoration: BoxDecoration(
                  color: Color(0xffd1dad5),
                ),
              ),
              Container(
                height: screenHeight*0.04,
                width: screenWidth*0.8/4.0,
                child: Text(sImgName),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(width: 2.0,),
        ],
      ),
    );
  }
  Widget _bigImageItem(String bImgPath, String bImgName){
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
              Container(
                height: screenHeight*0.12,
                width: screenWidth*0.7/2.0,
                child: bImgPath == null ?
                Container(child: Image.asset('assets/add_photo.png'),)
                    : Container(
                  height: screenHeight*0.12,
                  width: screenWidth*0.7/2.0,
                  decoration: BoxDecoration(
                    color: Color(0xffd1dad5),
                    image: DecorationImage(image: NetworkImage(bImgPath),),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xffd1dad5),
                ),
              ),
              Container(
                height: screenHeight*0.04,
                width: screenWidth*0.7/2.0,
                child: Text(bImgName),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(width: screenWidth*0.01,),
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
          onChanged: null,
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