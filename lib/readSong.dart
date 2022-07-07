import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medcorder_audio/medcorder_audio.dart';
import 'package:itda/help.dart';
import 'package:itda/connectSong.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:itda/help.dart';

class ReadSong extends StatefulWidget {
  String songKey="키";
  final LocalFileSystem localFileSystem;
  ReadSong({Key key,@required this.songKey, this.localFileSystem}) : super(key: key);
  @override
  _ReadSongState createState() => _ReadSongState();
}

class _ReadSongState extends State<ReadSong> {
  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  dynamic data;
  final _formKey = GlobalKey<FormState>();
  int favoriteNum = 0;
  int totalFavoriteNum ;
  int point;
  int index;
  final _chatController = TextEditingController();
  String comment = "";

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  MedcorderAudio audioModule = new MedcorderAudio();
  bool canRecord = false;
  double recordPower = 0.0;
  double recordPosition = 0.0;
  bool isRecord = false;
  bool isPlay = false;
  double playPosition = 0.0;
  String file = "";

  String semail="이메일";
  String snickname="닉네임";
  String sschool = "학교";
  String sgrade = "학년";
  String sclas = "반";
  String ssubject = "";
  String scontent = "";
  String srecord = "";
  String sindexing = "";
  String songKey = "키값";

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _songfireUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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
        index = snapshot.data["index"];
      });
    });
  }
  Future<String> getSong () async {
    _songfireUser = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference =  Firestore.instance.collection("songList").document(widget.songKey);
    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      setState(() {
        semail =snapshot.data["semail"];
        snickname =snapshot.data["snickname"];
        sschool = snapshot.data["sschool"];
        sgrade = snapshot.data["sgrade"];
        sclas = snapshot.data["sclas"];
        ssubject = snapshot.data["ssubject"];
        scontent = snapshot.data["scontent"];
        srecord = snapshot.data["srecord"];
        sindexing = snapshot.data["sindexing"];
        songKey = snapshot.data["songKey"];
        totalFavoriteNum = snapshot.data["total"];
      });
    });
  }

  void _songPrepareService() async {
    _songfireUser = await _firebaseAuth.currentUser();
  }

  Future _initSettings() async {
    final String result = await audioModule.checkMicrophonePermissions();
    if (result == 'OK') {
      await audioModule.setAudioSettings();
      setState(() {
        canRecord = true;
      });
    }
    return;
  }

  Widget _chatList () {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('songList').document(widget.songKey).collection("songChatInfo").orderBy("index").snapshots(),
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
    DocumentReference documentReference =  Firestore.instance.collection("songList").document(widget.songKey)
        .collection("songLikeInfo").document(user.email);

    await documentReference.get().then<dynamic>(( DocumentSnapshot snapshot) async {
      if(this.mounted) {
        setState(() {
          favoriteNum = snapshot.data['favoriteNum'];
        });
      }
    });
  }

  Future<void> totalLikeUpdate (int num) async {
    DocumentReference documentReference = await Firestore.instance.collection("songList").document(widget.songKey);

    await documentReference.updateData(<String, dynamic>{
      'total' : totalFavoriteNum+num,
    });
  }

  Future<void> likeAddUpdate () async {
    DocumentReference documentReference = await Firestore.instance.collection("songList").document(widget.songKey)
        .collection("songLikeInfo").document(user.email);

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

    DocumentReference documentReference2 = await Firestore.instance.collection("loginInfo").document(widget.songKey);
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

    DocumentReference documentReference = await Firestore.instance.collection("songList").document(widget.songKey)
        .collection("songChatInfo").document("$index");

    documentReference.setData(<String, dynamic>{
      'nickname' : _nickname,
      'comment' : comment,
      'index' : index,
    });
  }

  Future<void> likeSubUpdate () async {
    DocumentReference documentReference = await Firestore.instance.collection("songList").document(widget.songKey)
        .collection("songLikeInfo").document(user.email);

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

  @override
  void initState() {
    super.initState();
    getUser();
    getSong();
    getLike();
    _songPrepareService();
    _initSettings();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    getUser();
    getSong();
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: screenWidth*0.15,),
                Container(
                  width: screenWidth*0.6,
                  height: screenWidth*0.15,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: Color(0xffb5c8bc),
                      offset: Offset(0,10),
                    )] ,
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
                        child: Image.asset('assets/ink.png'),
                        //color: Colors.white,
                      ),
                      Container(width: screenWidth*0.05),
                      Container(
                        child: Text(
                          '노래로 마음을 잇다',
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
                Container(
                  height: screenWidth*0.2,
                  width: screenWidth*1.0,
                  decoration: BoxDecoration(
                      color: const Color(0xffe9f4eb)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: screenWidth*0.04),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("$sschool $sgrade 학년  $sclas 반",
                                  style: TextStyle(
                                    fontSize: screenWidth*0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: screenWidth*0.02,),
                                Text("$snickname 작성",
                                  style: TextStyle(
                                    fontSize: screenWidth*0.03,
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: screenWidth*0.1),
                            Container(
                              child: InkWell(
                                onTap: onPlayAudio,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: screenWidth*0.07,
                                        child: Image.asset('assets/listen.png'),
                                        //color: Colors.white,
                                      ),
                                      Container(
                                        height: screenWidth*0.02,
                                      ),
                                      Container(
                                        child: Text(
                                          '녹음 듣기',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Arita-dotum-_OTF",
                                            fontStyle: FontStyle.normal,
                                            fontSize: screenWidth*0.03,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //width: 200.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: screenWidth*1.0,
                  height: screenWidth*1.2,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffe9f4eb),
                        width: 1.0,
                      ),
                      color: const Color(0xffffffff)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: screenWidth*0.02,),
                      Text('제목',
                        style: TextStyle(
                          fontSize: screenWidth*0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenWidth*0.02,),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        width: screenWidth*1.0,
                        height: screenWidth*0.15,
                        decoration: BoxDecoration(
                            color: const Color(0x69e9f4eb)
                        ),
                        child: Text(ssubject),
                      ),
                      SizedBox(height: screenWidth*0.02,),
                      Text('나의 느낀점(다짐)',
                        style: TextStyle(
                          fontSize: screenWidth*0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenWidth*0.02,),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        width: screenWidth*1.0,
                        height: screenWidth*0.8,
                        decoration: BoxDecoration(
                            color: const Color(0x69e9f4eb)
                        ),
                        child: Text(scontent),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth*0.03,),
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
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xfffff7ef),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                        ),
                        child: InkWell(
                          child: _wPBuildConnectItem('assets/list.png','목록'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
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
      height: screenWidth*0.17,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: screenWidth*0.07,
            child: Image.asset(wPimgPath),
            //color: Colors.white,
          ),
          Container(
            height: screenWidth*0.02,
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

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(srecord, isLocal: true);
  }
}