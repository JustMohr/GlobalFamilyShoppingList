
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialDialog {

  static void tutorialCheck(final BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('firstTime_global_shopping_list'); --> for reset

    if (prefs.getBool('firstTime_global_shopping_list') != null)
      return;

    //prefs.setBool('firstTime_global_shopping_list', false);

    _tutorialDialog(context);
  }

  static _tutorialDialog(final BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (contextX) {
          return Dialog();
        }
    );
  }
}







class Dialog extends StatefulWidget {
  const Dialog({Key? key}) : super(key: key);

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> {

  String btnText = 'weiter';
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width * 0.65,
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.lightBlue,
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (value) => setState(() { btnText = (value==0)? 'weiter':'Verstanden'; }),
                    children: [
                      _tutorialPage(
                          'Produkte entfernen',
                          'deleteScreen.png',
                          'Um ein Produkt aus der Liste zu entfernen, wische es nach Links weg.'
                      ),
                      _tutorialPage(
                          'ID einsehen/teilen',
                          'showID.png',
                          'Um die ID mit anderen zu Teilen, klicke auf den Button'
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 2,
                        effect: WormEffect(
                            dotWidth: 10,
                            dotHeight: 10
                        ),
                      ),
                    ),
                  ),
                  _TutorialFooter(context)
                ],
              )
          ),
        ),
      ),
    );
  }

  Widget _tutorialPage(String title, String imgName, String description) {
    return Container(
      child: Stack(
        children: [
          _TutorialHead(title),
          _TutorialImg(imgName, description),
        ],
      ),
    );
  }

  Widget _TutorialHead(String title) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Text(
          title,
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }

  Widget _TutorialImg(String imgName, String description) {
    return Center(
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/$imgName'),
              SizedBox(height: 20,),
              Text(textAlign: TextAlign.center, description)
            ],
          ),
        )
    );
  }

  Widget _TutorialFooter(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
          padding: EdgeInsets.all(17),
          child: InkWell(
            child: Text(
              '$btnText',
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () {
              if (_pageController.page == 1)
                Navigator.pop(context);
              else
                _pageController.animateToPage(1, duration: Duration(milliseconds: 450), curve: Curves.fastOutSlowIn);
            },
          )
      ),
    );
  }
}

