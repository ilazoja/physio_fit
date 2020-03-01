# Physio Tracker


## Folder Structure
```
flutter-app/
- android/
- assets/
    - fonts/
- build/
- ios/
- lib/
    - main.dart
    - routes.dart
    - themeData.dart
    - copy.dart
    - screens/
        - screenFolder/
            - widgets/
            - screenName.dart
            - index.dart
    - util/
        - utilFunction.dart
    - widgets/
        - globalWidget.dart
    - services/
        - service.dart
- test/
```
## Copy deck
For all text that can be potenially changed based on client needs, put a variable in copyDeck.dart for it. This way if a text on a particular page needs to be changed, we can simply just change this variable file without searching through the code. Ensure proper variable naming is be used so this method is helpful.

In the file you are calling the variables file put 'import ../../copyDeck.dart as copy' then the variable can be used in that file as 'copy.variableName'

## ThemeData

Theme data is a good way to keep the projects theme easily adaptable. Below are guidelines on how and where we should use these themeData attributes.

If there is a theme you would like to use that is not apart of themeData or does not fall into an appropriate attribute / classification feel free to add it.

Note for material widgets, themeData will be automatically applied the widget and there is not need to explicitly list them unless required

### Determining if you should use ThemeData for your Widget

Easy way to determine if you should use themeData for a color is to ask yourself, 'If we were to change the apps color scheme to dark mode would this color change?'
Likewise for buttonStyles, textThemes, etc.

If yes, using themeData in this case would help the transfer however be sure the classification / attribute used make sense. Or else it take away from the entire purpose.


### Current classifications

Add to this depending on what widgets you use each for.
```
primaryColor: Used for apps primary text color, icon color, button color, etc.
scaffoldBackgroundColor: Background color of each page only
bottomAppBarColor: Bottom app color use only
appBarTheme: Top App bar theme only (currently only setting color)
cursorColor: Cursor color of all text fields
buttonTheme: Default button theme across app, override values in particular widget if needed
fontFamily: App font
textTheme:
    - subheading: subheading in list view, can be used in planner headings, event details title
    - button: button text styles
    - body1: any regular body text - black
    - display4: Search box text
    - display3: Events box heading text
    - display2: Events box location text
    - display1: Events box pricing text with shadow
    - body2: Hint Text
iconTheme: default icon theme that get inherited by all material icons
```
