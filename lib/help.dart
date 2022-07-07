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
                              "앱 개발의 이유",
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
                              "코로나19 상황과 인터넷과 모바일 등 기술과 통신의 급속한 발달로 만들어진 비대면, 언택트의 온라인 상황 속에서 건강한 생활을 위해 식사에 대해 이야기하고 행복한 생활을 위해 서로의 마음에 공감하며 슬기로운 미래 생활을 위해 목표를 공유함으로써  서로에게 응원할 수 있는 교육 프로그램을 제작하고자 합니다. 코로나19 이후, 나타난 가정과 학교의 소외와 단절을 잇는 교육 프로그램. 식사와 마음, 목표를 매개체로 나와 친구, 가족, 교육 공동체를 이어 자기관리역량을 높이고자 I·T·T·A(잇다) 어플리케이션을 개발하게 되었습니다.",
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
                              "식사를 잇다",
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
                              "우리가 직접 맛있고 영양 가득한 식단을 만들어 볼까요?\n그리고 만든 식단 정보를 부모님과 영양 선생님과 나누면 어떨까요?",
                              style: TextStyle(
                                fontSize: screenWidth*0.035,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            child: Text(
                              "앱 활용 법",
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
                              "건강한 식사 생활이 이루어지도록 영양소를 고려하여 내가 만든 식단을 나누어 봅시다. 다른 친구들도 쉽게 확인할 수 있도록 메뉴 이름과 사진 자료도 함께 넣어 주면 좋을 것 같습니다. 내가 만든 식단에 영양성분이 골고루 포함되었는지도 꼭 확인해주세요. I·T·T·A 게시판에 내가 만든 식단을 업로드 하면 친구들에게 격려 와 응원을 받을 수 있습니다. 영양 선생님께도 e-mail 을 통해 알려주세요. 그리고 우리 친구들도 다른 친구들이 만든 식단을 I·T·T·A 게시판에서 확인하고 똑같이 응원해주세요. 글을 쓰거나 친구를 응원하는 댓글 활동을 통해 건강한 식사 생활을 잇는 IT 포인트를 얻을 수 있습니다.",
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
                              "마음을 잇다",
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
                              "나의 감정을 알아가고 시, 이야기, 노래를 활용하여 친구들과 마음을 나누며 행복한 생활을 향해 나아가 볼까요?",
                              style: TextStyle(
                                fontSize: screenWidth*0.035,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            child: Text(
                              "앱 활용 법",
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
                              "그동안 답답했던 마음을 시, 이야기, 노래로 표현해보아요. I·T·T·A 게시판에 나의 마음을 알리고 친구들과 함께 마음을 나누어 보세요. 답답했던 마음이 조금은 가벼워질 것입니다. 그리고 나처럼 공감이 필요한 친구의 글을 확인하고 응원하는 댓글을 적어주세요. 답답하고 힘들었던 마음을 나누며 서로에게 진심의 마음을 담은 댓글을 통해 행복한 생활로 나아가는 IT포인트를 얻을 수 있습니다.",
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
                              "목표를 잇다",
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
                              "스스로 계획하고 실천하는 하루는 1주일이 되고, 1달, 1년이 되어 삶을 변화할 수 있습니다. 목표를 설정하는 방법뿐만 아니라 많은 이들에게 자신의 목표를 알린다면 실천하는 힘이 될 것입니다.",
                              style: TextStyle(
                                fontSize: screenWidth*0.035,
                              ),
                            ),
                          ),
                          Container(height: screenWidth*0.03,),
                          Container(
                            child: Text(
                              "앱 활용 법",
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
                              "오늘의 목표를 시작으로 이번 주 목표, 올해의 목표를 세워봅시다. 내가 세운 목표를 친구들에게 알림으로써 끝까지 그 일을 해내야겠다는 의지를 다지게 됩니다. I·T·T·A 게시판을 통해 내가 세운 목표를 공유하고 응원을 받는다면 나도 다른 친구들의 목표를 이룰 수 있기를 진심 어린 마음으로 응원할 수 있습니다. 목표에서 출발한 활동은 현재와 미래를 이어 나의 삶을 슬기롭게 바꿀 수 있습니다. 활동에 적극적으로 참여하며 슬기로운 미래 생활로 나아가는 IT포인트를 얻을 수 있습니다.",
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