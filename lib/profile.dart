import 'package:flutter/material.dart';
import 'help.dart';
import 'example.dart';
import 'goal.dart';

class ProfilePage extends StatelessWidget{
  String nickname = "닉네임";
  int point = 1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            "사용자 정보",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
          ),
        ),
        leading: FlatButton(
          child: Text(
            "로그아웃",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.help,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 100),
          Center(
            child: Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                    ])),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "세상을 잇는\n" + nickname + "을 오늘도 응원합니다!",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
          SizedBox(height: 30),
          Center(
              child: Text(
                "잇 포인트: $point",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.red
                ),
              ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.description,
                    size: 70,
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GoalPage()));
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


