import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

enum FormType { login, register }

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _gradeController = TextEditingController();
  final _classController = TextEditingController();
  final _dreamController = TextEditingController();

  String _email;
  String email;
  String _password;
  String _passwordCheck;
  String _nickname;
  String _school;
  String _grade;
  String _class;
  String _dream;
  int _value = 1;

  List<String> schoolList = [
  "곡강초등학교","구룡포초등학교", "구정초등학교", "기계초등학교", "기북초등학교", "남성초등학교", "달전초등학교", "대도초등학교", "대보초등학교", "대송초등학교",
  "대이초등학교", "대잠초등학교", "대해초등학교", "동해초등학교", "두호남부초등학교", "두호초등학교", "문덕초등학교", "문충초등학교", "상대초등학교", "송라초등학교",
  "송림초등학교", "신광초등학교", "신흥초등학교", "양서초등학교", "양포초등학교", "양학초등학교", "연일초등학교", "연일형산초등학교", "오천초등학교", "용흥초등학교",
  "월포초등학교", "유강초등학교", "이동초등학교", "인덕초등학교", "장기초등학교", "장기초모포분교", "장량초등학교", "장성초등학교", "죽도초등학교", "죽장초등학교",
  "죽장초상옥분교", "죽천초등학교", "창포초등학교", "청림초등학교", "청하초등학교", "초곡초등학교", "포항남부초등학교", "포항대흥초등학교", "포항동부초등학교",
  "포항송곡초등학교", "포항송도초등학교", "포항양덕초등학교", "포항영흥초등학교", "포항원동초등학교", "포항장원초등학교", "포항장흥초등학교", "포항제철지곡초등학교", "포항제철초등학교",
  "포항중앙초등학교", "포항초등학교", "포항항도초등학교", "포항해맞이초등학교", "학천초등학교", "항구초등학교", "효자초등학교", "흥해남산초등학교", "흥해서부초등학교", "흥해초등학교",
  ];
  FormType _formType = FormType.login;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;

  void validateAndSubmit(String school) async {
    final form = formKey.currentState;

    if (form.validate()) {
      try {
        form.save();
        FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password))
            .user;
        print('Registered User: ${user.uid}');
        createRecord(_email,
          _nicknameController.text,
          school,
          _gradeController.text,
          _classController.text,
          _dreamController.text,
        );
      } catch (e) {

        print('Error1: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void createRecord(String email, String nickname, String schoolName, String grade, String clas, String dream) async {
    await databaseReference.collection("loginInfo")
        .document(email)
        .setData({
      'nickname': nickname,
      'schoolname' : schoolName,
      'grade' : grade,
      'class' : clas,
      'point' : 0,
      'email' : email,
      'today' : "오늘의 목표를 입력해주세요",
      'week'  : "이번 달의 목표를 입력해주세요",
      'year'  : "올해의 목표를 입력해주세요",
      'dream' : dream,
      'todaycheck' : false,
      'weekcheck' : false,
      'yearcheck' : false,
      'total' : 0,
      'index' : 0,
      'admin' : false,

    });

    await databaseReference.collection(schoolName)
        .document(email)
        .setData({
      'nickname': nickname,
      'schoolname' : schoolName,
      'grade' : grade,
      'class' : clas,
      'point' : 0,
      'email' : email,
      'today' : "오늘의 목표를 입력해주세요",
      'week'  : "이번 달의 목표를 입력해주세요",
      'year'  : "올해의 목표를 입력해주세요",
      'dream' : dream,
      'todaycheck' : false,
      'weekcheck' : false,
      'yearcheck' : false,
      'total' : 0,
      'index' : 0,

    });

    Navigator.of(context).pop();
  }

  void setSchool(String school){
    print(school);

    setState(() {
      _school = school;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: HexColor("#55965e"),
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Container(
                width: queryData.size.width * 0.1,
                height: queryData.size.width * 0.1,
                child: Image.asset("assets/Itda_black.png"),
              ),
              SizedBox(height: queryData.size.width * 0.1,),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "이메일 (형식: abc@abc.com)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: queryData.size.width * 0.8,
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,                      // Added this
                          contentPadding: const EdgeInsets.fromLTRB(10,0,0,0),
                          border: InputBorder.none,
                          labelText: '이메일',
                          filled: true,
                          fillColor: HexColor("#e9f4eb"),
                        ),
                        validator: (value){
                          if(value.isEmpty) {
                            return '이메일을 입력해주세요';
                          }
                          if(!(value.contains('@') && value.contains('.')))
                            return '이메일 형식을 다시 확인해주세요';
                          email = value;
                          return null;
                        },
                        onSaved: (value) => _email = value,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: queryData.size.width * 0.05,),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "비밀번호 입력 (6자리 이상)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: queryData.size.width * 0.8,
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,                      // Added this
                          contentPadding: const EdgeInsets.fromLTRB(10,0,0,0),
                          border: InputBorder.none,
                          labelText: '비밀번호',
                          filled: true,
                          fillColor: HexColor("#e9f4eb"),
                        ),
                        validator: (value){
                          if (value.isEmpty ) {
                            return '비밀번호를 입력해주세요';
                          }
                          if(value.length < 6)
                            return "비밀번호를 6자리 이상 입력해주세요";
                          _passwordCheck = value;
                          return null;
                        },
                        onSaved: (value) => _password = value,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: queryData.size.width * 0.05,),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "비밀번호 확인",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: queryData.size.width * 0.8,
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,                      // Added this
                          contentPadding: const EdgeInsets.fromLTRB(10,0,0,0),
                          border: InputBorder.none,
                          labelText: '비밀번호 확인',
                          filled: true,
                          fillColor: HexColor("#e9f4eb"),
                        ),
                        validator: (value){
                          if (value.isEmpty || value != _passwordCheck) {
                            if(value.isEmpty)
                              return '입력한 비밀번호를 다시 입력해주세요';
                            if(value != _passwordCheck)
                              return '비밀번호를 다시 한 번 확인해주세요';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: queryData.size.width * 0.05,),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "닉네임 입력",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: queryData.size.width * 0.8,
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,                      // Added this
                          contentPadding: const EdgeInsets.fromLTRB(10,0,0,0),
                          border: InputBorder.none,
                          labelText: '닉네임',
                          filled: true,
                          fillColor: HexColor("#e9f4eb"),
                        ),
                        controller: _nicknameController,
                        validator: (value){
                          if (value.isEmpty) {
                            return "닉네임을 입력해주세요";
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: queryData.size.width * 0.05,),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "학교 입력",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: queryData.size.width * 0.8,
                      child: DropdownSearch(
                        mode: Mode.MENU,
                        selectedItem: _school,
                        showSelectedItem: true,
                        items: schoolList,
                        label: "학교를 입력해주세요",
                        onChanged: (item) {
                            _school = item;
                          //  print(item);
                        },
                        validator: (String item) {
                          if (item == null){
                            return "학교를 입력해주세요";
                          }
                          _school = item;
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(height: queryData.size.width * 0.05,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "학년 입력",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Container(
                          width: queryData.size.width * 0.35,
                          child: TextFormField(
                            decoration: InputDecoration(
                              isDense: true,                      // Added this
                              contentPadding: const EdgeInsets.fromLTRB(10,0,0,0),
                              border: InputBorder.none,
                              labelText: '학년',
                              filled: true,
                              fillColor: HexColor("#e9f4eb"),
                            ),
                            controller: _gradeController,
                            validator: (value){
                              if (value.isEmpty) {
                                return "학년을 입력해주세요";
                              }
                              _grade = value;
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: queryData.size.width * 0.1,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "반 입력",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Container(
                          width: queryData.size.width * 0.35,
                          child: TextFormField(
                            decoration: InputDecoration(
                              isDense: true,                      // Added this
                              contentPadding: const EdgeInsets.fromLTRB(10,0,0,0),
                              border: InputBorder.none,
                              labelText: '반',
                              filled: true,
                              fillColor: HexColor("#e9f4eb"),
                            ),
                            controller: _classController,
                            validator: (value){
                              if (value.isEmpty) {
                                return "반을 입력해주세요";
                              }
                              _class = value;
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: queryData.size.width * 0.05,),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "꿈 입력",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: queryData.size.width * 0.8,
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,                      // Added this
                          contentPadding: const EdgeInsets.fromLTRB(10,0,0,0),
                          border: InputBorder.none,
                          labelText: '꿈',
                          filled: true,
                          fillColor: HexColor("#e9f4eb"),
                        ),
                        controller: _dreamController,
                        validator: (value){
                          if (value.isEmpty) {
                            return "꿈을 입력해주세요";
                          }
                          _dream = value;
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: queryData.size.width * 0.05,),
              Center(
                child: Container(
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB((queryData.size.width * 0.8)/3, 10, (queryData.size.width * 0.8)/3, 10),
                    color: HexColor("#55965e"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      '가입하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      validateAndSubmit(_school);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}