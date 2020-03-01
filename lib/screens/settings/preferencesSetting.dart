import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/shared/subHeading.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceSetting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreferenceSettingState();
  List<String> categoriesSelected = <String>[];

  Future<void> savePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList('user-prefered-categories', categoriesSelected);
  }
}

class _PreferenceSettingState extends State<PreferenceSetting> {
  @override
  void initState() {
    _getCurrentUserPreferences().then((List<String> userPrefs) {
      setState(() {
        widget.categoriesSelected = userPrefs;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: SubHeading(
              heading: copy.preferencesSubHeading,
            )),
        Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            child: Wrap(
                spacing: 5.0, // gap between adjacent chips
                children: _getChips()))
      ],
    );
  }

  Future<List<String>> _getCurrentUserPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('user-prefered-categories');
  }

  List<Widget> _getChips() {
    final List<Widget> chips = <Widget>[];

    for (String category in copy.categories) {
      chips.add(Theme(
          data: ThemeData.dark(),
          child: FilterChip(
            label: Text(category,
                style: Theme.of(context).textTheme.body1.copyWith(
                    color: widget.categoriesSelected.contains(category)
                        ? Colors.white
                        : Colors.black54)),
            selected: widget.categoriesSelected.contains(category),
            onSelected: (bool val) => setState(() {
              if (val) {
                widget.categoriesSelected.add(category);
              } else {
                widget.categoriesSelected.remove(category);
              }
            }),
            selectedColor: Theme.of(context).accentColor,
            backgroundColor: Colors.white70,
          )));
    }

    return chips;
  }
}
