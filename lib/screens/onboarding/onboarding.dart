import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/rendering.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:physio_tracker_app/services/location.dart' as location;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:physio_tracker_app/widgets/shared/standardButton.dart';
import '../../copyDeck.dart' as copy;
import 'package:flutter_svg/flutter_svg.dart';

// A list that keeps track of all the selected preferences at the end of onboarding
List<String> _selectedPreferences = <String>[];

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomeScreen> {
  int currentIndexPage;
  int pageLength;

  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 4;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double dotsHeight = MediaQuery.of(context).size.height * 0.9;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(0, 0),
          child: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        body: Stack(
          children: <Widget>[
            PageView(
              children: <Widget>[
                Walkthrough(
                  title: copy.onboardingScreenOne,
                  description: copy.onboardingDescriptionOne,
                  backgroundImage: 'assets/illustrations/onboardingScreen1.svg',
                ),
                Walkthrough(
                    title: copy.onboardingScreenTwo,
                    description: copy.onboardingDescriptionTwo,
                    backgroundImage:
                        'assets/illustrations/onboardingScreen2.svg'),
                Walkthrough(
                    title: copy.onboardingScreenThree,
                    description: copy.onboardingDescriptionThree,
                    backgroundImage:
                        'assets/illustrations/onboardingScreen3.svg'),
                EndWalkthrough(
                  dotsHeight: dotsHeight,
                ),
              ],
              onPageChanged: (int value) {
                setState(() => currentIndexPage = value);
              },
            ),
            Positioned(
              top: dotsHeight,
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Align(
                    alignment: Alignment.center,
                    child: DotsIndicator(
                      dotsCount: pageLength,
                      position: currentIndexPage,
                      decorator: DotsDecorator(
                          color: onboardingTheme.dotsColor,
                          activeColor: onboardingTheme.dotsActiveColor),
                    )),
              ),
            )
          ],
        ));
  }
}

class Walkthrough extends StatelessWidget {
  const Walkthrough(
      {Key key,
      @required this.title,
      @required this.description,
      @required this.backgroundImage})
      : super(key: key);
  final String title;
  final String description;
  final String backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SvgPicture.asset(
                backgroundImage,
                fit: BoxFit.fitWidth,
                height: MediaQuery.of(context).size.height),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: AutoSizeText(
              title,
              style: onboardingTheme.onboardingTitleTextStyle,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 8.7),
        ],
      ),
    );
  }
}

class EndWalkthrough extends StatelessWidget {
  const EndWalkthrough({Key key, @required this.dotsHeight}) : super(key: key);
  final double dotsHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      //Background
      Container(
        decoration: BoxDecoration(color: onboardingTheme.backgroundColor),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
      // Personalization buttons
      Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 22)),
          PersonalizationButtonSet(
            buttonOneName: copy.onboardingButton1,
            imageOne: 'assets/images/entertainment.jpeg',
            buttonTwoName: copy.onboardingButton2,
            imageTwo: 'assets/images/nightlife.jpeg',
          ),
          PersonalizationButtonSet(
            buttonOneName: copy.onboardingButton3,
            imageOne: 'assets/images/technology.jpeg',
            buttonTwoName: copy.onboardingButton4,
            imageTwo: 'assets/images/professional.jpeg',
          ),
          PersonalizationButtonSet(
            buttonOneName: copy.onboardingButton5,
            imageOne: 'assets/images/fitness.jpeg',
            buttonTwoName: copy.onboardingButton6,
            imageTwo: 'assets/images/beauty.jpeg',
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AutoSizeText(
              copy.selectCategories,
              style: onboardingTheme.onboardingTitleTextStyle,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 6.0),
        ],
      ),

      SaveButton()
    ]);
  }
}

class PersonalizationButtonSet extends StatelessWidget {
  const PersonalizationButtonSet(
      {Key key,
      @required this.buttonOneName,
      @required this.imageOne,
      @required this.buttonTwoName,
      @required this.imageTwo})
      : super(key: key);
  final String buttonOneName;
  final String imageOne;
  final String buttonTwoName;
  final String imageTwo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SquaredButton(
          category: buttonOneName,
          imageLocation: imageOne,
        ),
        SquaredButton(
          category: buttonTwoName,
          imageLocation: imageTwo,
        ),
      ],
    );
  }
}

class SquaredButton extends StatefulWidget {
  const SquaredButton(
      {Key key, @required this.category, @required this.imageLocation})
      : super(key: key);
  final String imageLocation;
  final String category;

  @override
  _ButtonPressedState createState() => _ButtonPressedState();
}

class _ButtonPressedState extends State<SquaredButton> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    List<Color> selectedGradient = <Color>[
      Theme.of(context).accentColor.withOpacity(0.5),
      Theme.of(context).accentColor.withOpacity(0.5),
      Theme.of(context).accentColor.withOpacity(0.5),
    ];
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    double buttonPadding = 10.0;
    if (deviceHeight > 570.0) {
      buttonPadding = 25.0;
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: GestureDetector(
            child: Stack(children: <Widget>[
              Container(
                width: deviceWidth / 2 * 0.85,
                height: deviceHeight / 5 * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                      image: AssetImage(widget.imageLocation),
                      fit: BoxFit.cover),
                ),
              ),
              _isSelected
                  ? Container(
                      width: deviceWidth / 2 * 0.85,
                      height: deviceHeight / 5 * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: selectedGradient,
                              stops: const <double>[0, 0.5, 1])),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.check_circle_outline,
                            color: Colors.white, size: 40),
                      ),
                    )
                  : Container(),
            ]),
            onTap: () {
              setState(() {
                _isSelected = !_isSelected;
                if (_isSelected)
                  _selectedPreferences.add(widget.category);
                else
                  _selectedPreferences.remove(widget.category);
              });
            },
          ),
        ),
        Container(
            padding: EdgeInsets.only(bottom: buttonPadding),
            child: AutoSizeText(
              widget.category,
              style: onboardingTheme.personalizationButtonText,
              maxLines: 1,
            ))
      ],
    );
  }
}

class SaveButton extends StatelessWidget {
  Future<void> setPersonalization() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('user-prefered-categories', _selectedPreferences);
    // Mark onboarding personalization complete
    prefs.setBool('onboarding-personalization-seen', true);
  }

  @override
  Widget build(BuildContext context) {
    final double dotsHeight = MediaQuery.of(context).size.height * 0.94;
    return Positioned(
        top: dotsHeight * 0.85,
        width: MediaQuery.of(context).size.width,
        child: Container(
            padding: const EdgeInsets.all(16.0),
            child: StandardButton(
              text: copy.personalizationSaveButton,
              onPressed: () async {
                setPersonalization().then((void f){
                  location.initLocationServices().then((void f){
                    Navigator.pushReplacementNamed(context, '/home');
                  });
                });
              },
            )));
  }
}
