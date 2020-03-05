import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../copyDeck.dart' as copy;

class SearchField extends StatelessWidget {
  const SearchField(this._textController);

  final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CupertinoTextField(
              keyboardAppearance: Theme.of(context).brightness,
              controller: _textController,
              decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.07),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0))),
              placeholder: copy.searchPatients,
              prefix: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 5.0),
                  child: Icon(Icons.search, color: Theme.of(context).accentColor)),
              cursorColor: Theme.of(context).cursorColor,
              placeholderStyle: Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).accentColor),
              style: Theme.of(context).textTheme.display4.copyWith(color: Theme.of(context).primaryColor),
              clearButtonMode: OverlayVisibilityMode.editing,
            )));
  }
}
