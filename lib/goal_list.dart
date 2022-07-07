import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'goal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'help.dart';


var Pass;
class Goal_ListPage extends StatefulWidget{
  String schoolName;
  Goal_ListPage({Key key,@required this.schoolName}) : super(key: key);
  @override
  _Goal_ListPageState createState() => _Goal_ListPageState();
}

class _Goal_ListPageState extends State<Goal_ListPage> {
  int favoriteNum = 0;
  FirebaseUser user ;

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(widget.schoolName).orderBy('email', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildGridView(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildGridView(BuildContext context, List<DocumentSnapshot> snapshot){
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
      childAspectRatio: 8.0 / 9.0,
      children: snapshot.map((data) => _buildGridCards(context, data)).toList(),
    );

  }

  Widget _buildGridCards(BuildContext context, DocumentSnapshot data) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    final record = Record.fromSnapshot(data);


    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(width: 1, color: Colors.green),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                'assets/user.png',
                fit: BoxFit.contain,
              )
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(10,0,0,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      FittedBox(
                        fit:BoxFit.cover,
                        child: Text(
                          record.nickname,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth*0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FittedBox(
                    fit:BoxFit.cover,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text(
                          record.school,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth*0.03,
                            color: HexColor("#b4c7bb"),
                          ),
                        ),
                        Text(
                          " "+record.grade+"학년",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: HexColor("#b4c7bb"),
                          ),
                        ),
                        Text(
                          " " + record.clas + "반",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: HexColor("#b4c7bb"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap:() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GoalPage(email: record.email)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "더보기",
                                style: TextStyle(
                                  color: HexColor("#fbb359"),
                                  fontSize: screenWidth*0.04,
                                ),
                              ),
                              SizedBox(width: 10,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenWidth*0.02,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: HexColor("#e9f4eb"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.help,
                color: HexColor("#fbb359"),
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
                "목표를 ",
                style: TextStyle(
                  fontSize: 18,
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
}


class Record{
  final String nickname;
  final String school;
  final String clas;
  final String grade;
  final String email;

  Record.fromMap(Map<String, dynamic> map)
      : assert(map['nickname'] != null),
        assert(map['schoolname'] != null),
        assert(map['class'] != null),
        assert(map['grade'] != null),
        assert(map['email'] != null),
        nickname = map['nickname'],
        school = map['schoolname'],
        clas = map['class'],
        email =map['email'],
        grade = map['grade'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);


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
