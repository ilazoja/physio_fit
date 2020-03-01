import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart' as calendar;

const Color mainColor = Colors.black;
const Color secondaryColor = Colors.white;

Color accent = greyAccent;
Color greyAccent = Colors.grey[800];
Color favouriteColor =  const Color(0xffC51104);
const String mainFont = 'Avenir-Reg';
const String mainFontLight = 'Avenir-Lig';
const String mainFontBold = 'Avenir-Med';

final ThemeData themeData = ThemeData(
    accentColor: accent,
    primaryColor: mainColor,
    primaryColorLight: Colors.white,
    splashColor: Colors.grey[100],
    scaffoldBackgroundColor: secondaryColor,
    bottomAppBarColor: secondaryColor,
    brightness: Brightness.light,
    //keyboard color
    appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        textTheme: const TextTheme(
            title: TextStyle(
                fontSize: 22.0, color: mainColor, fontFamily: mainFont)),
        color: secondaryColor,
        iconTheme: const IconThemeData(color: mainColor)),
    cursorColor: mainColor,
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      buttonColor: accent,
      disabledColor: accent.withOpacity(0.4),
    ),
    dividerColor: accent,
    textTheme: const TextTheme(
        subhead: TextStyle(
          //google places search result
          fontSize: 18,
          color: mainColor,
          fontFamily: mainFont,
        ),
        button: TextStyle(
            fontSize: 18.0, color: secondaryColor, fontFamily: mainFont),
        body2: TextStyle(
            fontSize: 18.0, color: Colors.white30, fontFamily: mainFont),
        //Hint Text
        body1:
            TextStyle(fontSize: 14.0, color: mainColor, fontFamily: mainFont),
        display4: TextStyle(
          fontSize: 18.0,
          color: mainColor,
          fontFamily: mainFontBold,
        ),
        //Eventbox title
        display3: TextStyle(
            fontSize: 14.0,
            color: secondaryColor,
            height: 0.9,
            fontFamily: mainFont),
        //event box pricing
        display2: TextStyle(
            fontSize: 12.0, color: mainColor, fontFamily: mainFontLight),
        //Event location
        display1: TextStyle(
            fontSize: 28.0,
            color: mainColor,
            fontFamily: mainFont,
            fontWeight: FontWeight.bold)),
    iconTheme: const IconThemeData(color: mainColor),
    sliderTheme: SliderThemeData(
      showValueIndicator: ShowValueIndicator.always,
      valueIndicatorColor: Colors.orange,
      thumbColor: Colors.orange,
      inactiveTrackColor: Colors.orange.withOpacity(0.2),
      activeTrackColor: Colors.orange
    )
    );

LoginTheme loginTheme = LoginTheme(
    logoStyle: const TextStyle(
        fontSize: 60.0, color: Colors.white, fontFamily: mainFont),
    hintStyle: const TextStyle(
        fontSize: 18.0, color: Colors.white, fontFamily: mainFontLight),
    secondaryTextStyle: const TextStyle(
        fontSize: 18.0, color: Colors.white, fontFamily: mainFontLight),
    secondaryTextStyleBolded: const TextStyle(
        fontSize: 18.0,
        color: Colors.white,
        fontFamily: mainFont,
        fontWeight: FontWeight.bold),
    primaryColor: Colors.white,
    accentColor: const Color(0xff50E3C2));

class LoginTheme {
  LoginTheme({
    this.logoStyle,
    this.hintStyle,
    this.primaryColor,
    this.accentColor,
    this.secondaryTextStyle,
    this.secondaryTextStyleBolded,
  });

  TextStyle logoStyle;
  TextStyle hintStyle;
  Color primaryColor;
  Color accentColor;
  TextStyle secondaryTextStyle;
  TextStyle secondaryTextStyleBolded;
}

class AccountTheme {
  AccountTheme({this.secondaryColor, this.followTextStyle, this.followNumStyle, this.nameStyle,
      this.locationStyle, this.profileButtonTextStyle, this.timelineStyle});

  Color secondaryColor;

  TextStyle followTextStyle;
  TextStyle followNumStyle;
  TextStyle nameStyle;
  TextStyle locationStyle;
  TextStyle profileButtonTextStyle;
  TextStyle timelineStyle;
}

AccountTheme accountTheme = AccountTheme(
  secondaryColor: const Color(0xff8C8C8C),
  followTextStyle: const TextStyle(fontFamily: mainFont, color: secondaryColor, fontSize: 12),
  followNumStyle: const TextStyle(fontFamily: mainFontBold, color: mainColor, fontSize: 21, fontWeight: FontWeight.bold),
  nameStyle: const TextStyle(fontFamily: mainFontBold, color: mainColor, fontSize: 21, fontWeight: FontWeight.bold),
  locationStyle: const TextStyle(fontFamily: mainFont, color: secondaryColor, fontSize: 14, fontWeight: FontWeight.bold),
  profileButtonTextStyle: const TextStyle(fontFamily: mainFont, color: mainColor, fontSize: 16),
  timelineStyle: const TextStyle(fontFamily: mainFont, color: mainColor, fontSize: 14, fontWeight: FontWeight.bold),
);

OnboardingTheme onboardingTheme = OnboardingTheme(
    backgroundColor: Colors.white,
    dotsColor: Colors.black,
    dotsActiveColor: accent,
    personalizationButtonColor: Colors.white,
    personalizationButtonText: const TextStyle(
        color: Colors.black87, fontSize: 17, fontFamily: mainFontBold),
    onboardingTitleTextStyle: const TextStyle(
        fontSize: 21, color: Colors.black, fontFamily: mainFontBold),
    persTitleTextStyle: const TextStyle(
        fontSize: 30, color: Colors.black, fontFamily: mainFontBold));

class OnboardingTheme {
  OnboardingTheme({
    this.backgroundColor,
    this.personalizationButtonColor,
    this.personalizationButtonText,
    this.persTitleTextStyle,
    this.onboardingTitleTextStyle,
    this.dotsColor,
    this.dotsActiveColor,
  });

  Color backgroundColor;
  Color personalizationButtonColor;
  TextStyle personalizationButtonText;
  TextStyle persTitleTextStyle;
  TextStyle onboardingTitleTextStyle;
  Color dotsColor;
  Color dotsActiveColor;
}

CalendarCarouselTheme calendarCarouselTheme = CalendarCarouselTheme(
    weekdayTextStyle: themeData.textTheme.body1,
    weekendTextStyle: themeData.textTheme.body1,
    thisMonthDayBorderColor: Colors.grey,
    todayButtonColor: Colors.white,
    todayTextStyle: themeData.textTheme.body1,
    todayBorderColor: favouriteColor,
    selectedTextStyle: themeData.textTheme.body1.copyWith(color: Colors.white),
    weekFormat: false,
    markedDateIconBorderColor: themeData.accentColor,
    markedDateIconBuilder: (calendar.Event list) {
      return Container(
        width: 5.0,
        height: 5.0,
        decoration: BoxDecoration(
          color: themeData.accentColor,
          shape: BoxShape.circle,
        ),
      );
    },
    markedDateIconMaxShown: 1,
    selectedDayButtonColor: themeData.accentColor,
    selectedDayBorderColor: Colors.white,
    daysHaveCircularBorder: true);

class CalendarCarouselTheme {
  CalendarCarouselTheme(
      {this.weekdayTextStyle,
      this.weekendTextStyle,
      this.thisMonthDayBorderColor,
      this.todayButtonColor,
      this.todayTextStyle,
      this.todayBorderColor,
      this.weekFormat,
      this.markedDateIconBorderColor,
      this.markedDateIconBuilder,
      this.markedDateIconMaxShown,
      this.selectedDayButtonColor,
      this.selectedDayBorderColor,
        this.selectedTextStyle,
      this.daysHaveCircularBorder});

  TextStyle weekdayTextStyle;
  TextStyle weekendTextStyle;
  Color thisMonthDayBorderColor;
  Color todayButtonColor;
  TextStyle todayTextStyle;
  Color todayBorderColor;
  bool weekFormat;
  Color markedDateIconBorderColor;
  Function markedDateIconBuilder;
  int markedDateIconMaxShown;
  Color selectedDayButtonColor;
  Color selectedDayBorderColor;
  TextStyle selectedTextStyle;
  bool daysHaveCircularBorder;
}

ChatTheme chatTheme = ChatTheme(
    greyColor: const Color(0xffaeaeae),
    greyColor2: const Color(0xFFDBDBDB),
    greyColor3: Colors.grey[100],
    lightAccent: Colors.teal[300],
    convoHeading: const TextStyle(
      fontSize: 18.0,
      color: mainColor,
      fontFamily: mainFontBold,
    ),
    convoTime: const TextStyle(
      fontSize: 14.0,
      color: mainColor,
      fontFamily: mainFont,
    ),
    convoTimeUnread: TextStyle(
      fontSize: 14.0,
      color: accent,
      fontFamily: mainFontBold,
      fontWeight: FontWeight.bold
    ),
    convoBody: const TextStyle(
      fontSize: 15.0,
      color: mainColor,
      fontFamily: mainFont,
    ),
    segmentedTitle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontFamily: 'Default',
        fontSize: 15)
    );

class ChatTheme {
  ChatTheme(
      {this.greyColor,
      this.greyColor2,
      this.greyColor3,
      this.lightAccent,
      this.convoHeading,
      this.convoTime,
      this.convoTimeUnread,
      this.convoBody,
      this.segmentedTitle});

  Color greyColor, greyColor2, greyColor3, lightAccent;
  TextStyle convoHeading, convoTime, convoTimeUnread, convoBody, segmentedTitle;
}
