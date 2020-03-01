import 'package:flutter/material.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;

class SearchHelpers {
  static List<Widget> addSearchResults(
      List<Widget> list, BuildContext context) {
    if (list.isEmpty) {
      // Return 'No Events Found'
      final List<Widget> emptyList = <Widget>[
        // Todo(anyone): add illustration instead
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(copy.plannerEmptyList,
              style: Theme.of(context).textTheme.display4),
        ))
      ];
      return emptyList;
    } else {
      return list;
    }
  }

  static bool likeFunction(String dataText, String searchText) {
    return dataText.toLowerCase().contains(searchText.toLowerCase());
  }
}
