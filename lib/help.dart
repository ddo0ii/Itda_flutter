//import 'dart:html';

import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: HexColor("#55965e"),
            ),
            onPressed: () =>
                Navigator.of(context).pop()
            ,
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(height: screenWidth*0.1,),
              Container(
                width: screenWidth*0.18,
                child: Image.asset('assets/Itda_black.png'),
              ),
              Container(height: screenWidth*0.2,),
              Container(
                  width: screenWidth*0.9,
                  height: screenWidth*0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.whatshot,
                              size: screenWidth*0.13,
                              color: Colors.black
                          )
                        ],
                      ),
                      Container(width: screenWidth*0.1,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "??? ????????? ??????",
                              style: TextStyle(
                                fontSize: screenWidth*0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            width: screenWidth*0.6,
                            child: Text(
                              "?????????19 ????????? ???????????? ????????? ??? ????????? ????????? ????????? ????????? ???????????? ?????????, ???????????? ????????? ?????? ????????? ????????? ????????? ?????? ????????? ?????? ??????????????? ????????? ????????? ?????? ????????? ????????? ???????????? ???????????? ?????? ????????? ?????? ????????? ??????????????????  ???????????? ????????? ??? ?????? ?????? ??????????????? ??????????????? ?????????. ?????????19 ??????, ????????? ????????? ????????? ????????? ????????? ?????? ?????? ????????????. ????????? ??????, ????????? ???????????? ?????? ??????, ??????, ?????? ???????????? ?????? ????????????????????? ???????????? I??T??T??A(??????) ????????????????????? ???????????? ???????????????.",
                              style: TextStyle(
                                fontSize: screenWidth*0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              Container(
                width: screenWidth*0.9,
                child: Divider(thickness: 1),
              ),
              Container(
                  width: screenWidth*0.9,
                  height: screenWidth*1.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.restaurant,
                              size: screenWidth*0.13,
                              color: Colors.black
                          )
                        ],
                      ),
                      Container(width: screenWidth*0.1,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "????????? ??????",
                              style: TextStyle(
                                fontSize: screenWidth*0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            width: screenWidth*0.6,
                            child: Text(
                              "????????? ?????? ????????? ?????? ????????? ????????? ????????? ??????????\n????????? ?????? ?????? ????????? ???????????? ?????? ???????????? ????????? ?????????????",
                              style: TextStyle(
                                fontSize: screenWidth*0.035,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            child: Text(
                              "??? ?????? ???",
                              style: TextStyle(
                                fontSize: screenWidth*0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            width: screenWidth*0.6,
                            child: Text(
                              "????????? ?????? ????????? ?????????????????? ???????????? ???????????? ?????? ?????? ????????? ????????? ?????????. ?????? ???????????? ?????? ????????? ??? ????????? ?????? ????????? ?????? ????????? ?????? ?????? ?????? ?????? ??? ????????????. ?????? ?????? ????????? ??????????????? ????????? ????????????????????? ??? ??????????????????. I??T??T??A ???????????? ?????? ?????? ????????? ????????? ?????? ??????????????? ?????? ??? ????????? ?????? ??? ????????????. ?????? ??????????????? e-mail ??? ?????? ???????????????. ????????? ?????? ???????????? ?????? ???????????? ?????? ????????? I??T??T??A ??????????????? ???????????? ????????? ??????????????????. ?????? ????????? ????????? ???????????? ?????? ????????? ?????? ????????? ?????? ????????? ?????? IT ???????????? ?????? ??? ????????????.",
                              style: TextStyle(
                                fontSize: screenWidth*0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              Container(
                width: screenWidth*0.9,
                child: Divider(thickness: 1),
              ),
              Container(
                  width: screenWidth*0.9,
                  height: screenWidth*1.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.favorite,
                              size: screenWidth*0.13,
                              color: Colors.black
                          )
                        ],
                      ),
                      Container(width: screenWidth*0.1,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "????????? ??????",
                              style: TextStyle(
                                fontSize: screenWidth*0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            width: screenWidth*0.6,
                            child: Text(
                              "?????? ????????? ???????????? ???, ?????????, ????????? ???????????? ???????????? ????????? ????????? ????????? ????????? ?????? ????????? ??????????",
                              style: TextStyle(
                                fontSize: screenWidth*0.035,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            child: Text(
                              "??? ?????? ???",
                              style: TextStyle(
                                fontSize: screenWidth*0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            width: screenWidth*0.6,
                            child: Text(
                              "????????? ???????????? ????????? ???, ?????????, ????????? ??????????????????. I??T??T??A ???????????? ?????? ????????? ????????? ???????????? ?????? ????????? ????????? ?????????. ???????????? ????????? ????????? ???????????? ????????????. ????????? ????????? ????????? ????????? ????????? ?????? ???????????? ???????????? ????????? ???????????????. ???????????? ???????????? ????????? ????????? ???????????? ????????? ????????? ?????? ????????? ?????? ????????? ????????? ???????????? IT???????????? ?????? ??? ????????????.",
                              style: TextStyle(
                                fontSize: screenWidth*0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              Container(
                width: screenWidth*0.9,
                child: Divider(thickness: 1),
              ),
              Container(
                  width: screenWidth*0.9,
                  height: screenWidth*1.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.description,
                              size: screenWidth*0.13,
                              color: Colors.black
                          )
                        ],
                      ),
                      Container(width: screenWidth*0.1,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "????????? ??????",
                              style: TextStyle(
                                fontSize: screenWidth*0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            width: screenWidth*0.6,
                            child: Text(
                              "????????? ???????????? ???????????? ????????? 1????????? ??????, 1???, 1?????? ?????? ?????? ????????? ??? ????????????. ????????? ???????????? ???????????? ????????? ?????? ???????????? ????????? ????????? ???????????? ???????????? ?????? ??? ????????????.",
                              style: TextStyle(
                                fontSize: screenWidth*0.035,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            child: Text(
                              "??? ?????? ???",
                              style: TextStyle(
                                fontSize: screenWidth*0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            width: screenWidth*0.6,
                            child: Text(
                              "????????? ????????? ???????????? ?????? ??? ??????, ????????? ????????? ???????????????. ?????? ?????? ????????? ??????????????? ??????????????? ????????? ??? ?????? ?????????????????? ????????? ????????? ?????????. I??T??T??A ???????????? ?????? ?????? ?????? ????????? ???????????? ????????? ???????????? ?????? ?????? ???????????? ????????? ?????? ??? ????????? ?????? ?????? ???????????? ????????? ??? ????????????. ???????????? ????????? ????????? ????????? ????????? ?????? ?????? ?????? ???????????? ?????? ??? ????????????. ????????? ??????????????? ???????????? ???????????? ?????? ????????? ???????????? IT???????????? ?????? ??? ????????????.",
                              style: TextStyle(
                                fontSize: screenWidth*0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
            ],
          ),
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