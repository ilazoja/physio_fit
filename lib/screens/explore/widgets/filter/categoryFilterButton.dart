import 'package:flutter/material.dart';
import 'package:physio_tracker_app/screens/eventFilter/filter.dart';
import 'package:physio_tracker_app/services/location.dart' as location;
import 'package:physio_tracker_app/copyDeck.dart' as copy;

class CategoryFilterButton extends StatefulWidget {
  const CategoryFilterButton({Key key, @required this.parentContainerHeight})
      : super(key: key);
  static _CategoryFilterButtonState filterButtonState;

  final double parentContainerHeight;

  @override
  _CategoryFilterButtonState createState() => generateState();

  _CategoryFilterButtonState generateState() {
    filterButtonState = _CategoryFilterButtonState();
    return filterButtonState;
  }
}

class _CategoryFilterButtonState extends State<CategoryFilterButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final Color buttonColor = Colors.grey[100];
    final Color secondaryColor = Theme.of(context).accentColor;
    final Color buttonColorSelected = Theme.of(context).accentColor;
    final bool filterSet = Filter.numFilterSet > 0;
    final int numFilters = Filter.numFilterSet;
    String buttonText = copy.categoryFilterButtonText;

    if (filterSet) {
      buttonText = '$buttonText ( $numFilters )';
    }

    return AnimatedSize(
        duration: Duration(milliseconds: 250),
        vsync: this,
        child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SizedBox(
                height: widget.parentContainerHeight * 0.7,
                child: RaisedButton(
                  splashColor:
                      Colors.transparent,
                  elevation: 0.3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    buttonText,
                    style: Theme.of(context).textTheme.body1.copyWith(
                          color: filterSet ? buttonColor : secondaryColor,
                        ),
                  ),
                  color:
                      filterSet ? buttonColorSelected : buttonColor,
                  onPressed: () {
                    location.getLocationPermissionStatus().then((void func) {
                      Filter().showMenu(context);
                    });
                  },
                ))));
  }
}
