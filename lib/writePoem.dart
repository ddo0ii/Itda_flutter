import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:itda/connectPoem.dart';
import 'package:medcorder_audio/medcorder_audio.dart';
import 'package:itda/help.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class WritePoem extends StatefulWidget {
  String poemKey="키";
  //final LocalFileSystem localFileSystem;
  WritePoem({Key key,@required this.poemKey}) : super(key: key);
  // RecordAudio({localFileSystem})
  //     : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _WritePoemState createState() => _WritePoemState();
}

class _WritePoemState extends State<WritePoem> {
  static LocalFileSystem fs = LocalFileSystem();
  String semail="이메일";
  String snickname="닉네임";
  String sschool = "학교";
  String sgrade = "학년";
  String sclas = "반";
  String ssubject="제목";
  String scontent = "내용";
  String srecord = "녹음";
  static int sindex = 1;
  String sindexing = "$sindex";
  int total = 0;

  Firestore _firestore = Firestore.instance;
  FirebaseUser user;
  String email="이메일";
  String nickname="닉네임";
  String school = "학교";
  String grade = "학년";
  String clas = "반";
  int point = -1;
  dynamic data;
  final _formKey = GlobalKey<FormState>();

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;


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

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _poemfireUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _poemURL = "url";

  MedcorderAudio audioModule = new MedcorderAudio();
  bool canRecord = false;
  double recordPower = 0.0;
  double recordPosition = 0.0;
  bool isRecord = false;
  bool isPlay = false;
  double playPosition = 0.0;
  String file = "";

  @override
  void initState() {
    super.initState();
    getUser();
    _poemPrepareService();
    print('hello'+widget.poemKey);
    _init();
  }

  void _poemPrepareService() async {
    _poemfireUser = await _firebaseAuth.currentUser();
  }

  void poemSetTapping() async{
    await Firestore.instance.collection('poemList').document(widget.poemKey)
        .setData({
      'email':email, 'nickname':nickname, 'school':school, 'clas':clas, 'grade':grade,
      'semail':email, 'snickname':nickname, 'sschool':school, 'sclas':clas, 'sgrade':grade,
      'ssubject':ssubject, 'scontent':scontent, 'srecord': _poemURL, 'sindexing':sindexing,
      'poemKey':widget.poemKey, 'total':total});
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: screenWidth*0.1,),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                          '시로 마음을 잇다',
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
                  height: screenWidth*0.25,
                  decoration: BoxDecoration(
                      color: const Color(0xffe9f4eb)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: screenWidth*0.04),
                            Container(
                              child: InkWell(
                                onTap: () {
                                  switch (_currentStatus) {
                                    case RecordingStatus.Initialized:
                                      {
                                        _start();
                                        break;
                                      }
                                    case RecordingStatus.Recording:
                                      {
                                        _pause();
                                        break;
                                      }
                                    case RecordingStatus.Paused:
                                      {
                                        _resume();
                                        break;
                                      }
                                    case RecordingStatus.Stopped:
                                      {
                                        _init();
                                        break;
                                      }
                                    default:
                                      break;
                                  }
                                },
                                child: Container(
                                  child: _buildText(_currentStatus),
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth*0.04),
                            Container(
                              child: InkWell(
                                onTap: _currentStatus != RecordingStatus.Unset ? _stop : null,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: screenWidth*0.07,
                                        child: Image.asset('assets/stop.png'),
                                        //color: Colors.white,
                                      ),
                                      Container(
                                        height: screenWidth*0.03,
                                      ),
                                      Container(
                                        child: Text(
                                          '녹음 끝내기',
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
                            SizedBox(width: screenWidth*0.04),
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
                                        height: screenWidth*0.025,
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
                  height: screenWidth*1.2,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffe9f4eb),
                        width: 1.0,
                      ),
                      color: const Color(0xffffffff)
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('제목',
                              style: TextStyle(
                                fontSize: screenWidth*0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenWidth*0.03,),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                              width: screenWidth*0.85,
                              height: screenWidth*0.15,
                              decoration: BoxDecoration(
                                  color: const Color(0x69e9f4eb)
                              ),
                              child: TextFormField(
                                maxLines: 1,
                                onChanged: (text) => ssubject = text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '제목을 쓰세요';
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '제목을 쓰세요',
                                  //labelText: "Enter your username",
                                ),
                              ),
                            ),
                            SizedBox(height: screenWidth*0.03,),
                            Text('나의 느낀 점(다짐)',
                              style: TextStyle(
                                fontSize: screenWidth*0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenWidth*0.03,),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                              width: screenWidth*0.85,
                              height: screenWidth*0.8,
                              decoration: BoxDecoration(
                                  color: const Color(0x69e9f4eb)
                              ),
                              child: TextFormField(
                                maxLines: 30,
                                onChanged: (text) => scontent = text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '느낀 점을 쓰세요';
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '느낀 점을 쓰세요',
                                  //labelText: "Enter your username",
                                ),
                              ),
                            ),
                          ],
                        ),
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
                          child: _wPBuildConnectItem('assets/itda_orange.png','잇기(올리기)'),
                          onTap: () {
                            poemSetTapping();
                            Navigator.pop(context, MaterialPageRoute(builder: (context) => ConnectPoem()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth*0.03,),
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
      height: screenWidth*0.2,
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
  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    DateTime nowtime = new DateTime.now();
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = fs.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
    StorageReference storageReference = _firebaseStorage.ref().child("poemRcd/${_poemfireUser.uid}1_$nowtime");
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    await storageUploadTask.onComplete;
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _poemURL = downloadURL;
    });
  }

  Widget _buildText(RecordingStatus status) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    var text = "";
    var imgText = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = '녹음 시작';
          imgText = 'assets/record.png';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = '일시정지';
          imgText = 'assets/pause.png';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = '이어서 녹음';
          imgText = 'assets/record.png';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = '다시 녹음';
          imgText = 'assets/rerecord.png';
          break;
        }
      default:
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: screenWidth*0.055,
          child: Image.asset(imgText),
          //color: Colors.white,
        ),
        Container(
          height: screenWidth*0.02,
        ),
        Container(
          child: Text(
            text,
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
    );
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }
}