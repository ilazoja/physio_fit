import 'package:flutter/material.dart';
import 'package:physio_tracker_app/screens/eventFilter/filter.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/screens/explore/widgets/filter/priceRangeFilter.dart';
import 'package:physio_tracker_app/helpers/stringHelper.dart';

class PriceFilterButton extends StatefulWidget {
  const PriceFilterButton({Key key, @required this.parentContainerHeight})
      : super(key: key);
  static _PriceFilterButtonState filterButtonState;

  final double parentContainerHeight;

  @override
  _PriceFilterButtonState createState() => generateState();

  _PriceFilterButtonState generateState() {
    filterButtonState = _PriceFilterButtonState();
    return filterButtonState;
  }
}

class _PriceFilterButtonState extends State<PriceFilterButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final Color buttonColor = Colors.grey[100];
    final Color secondaryColor = Theme.of(context).accentColor;
    final Color buttonColorSelected = Theme.of(context).accentColor;
    final bool filterSet =
        PriceRangeFilter.values != PriceRangeFilter.defaultValues;

    final String buttonText = filterSet
        ? StringHelper.getPriceButtonText(PriceRangeFilter.values)
        : copy.priceFilterButtonText;

    return AnimatedSize(
        duration: Duration(milliseconds: 250),
        vsync: this,
        child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SizedBox(
                height: widget.parentContainerHeight * 0.7,
                child: RaisedButton(
                  splashColor: Colors.transparent,
                  elevation: 0.3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    buttonText,
                    style: Theme.of(context).textTheme.body1.copyWith(
                          color: filterSet ? buttonColor : secondaryColor,
                        ),
                  ),
                  color: filterSet ? buttonColorSelected : buttonColor,
                  onPressed: () {
                    showModalBottomSheet<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {},
                              child: PriceRangeFilter(),
                              );
                        }).then((void val) {
                      setState(() {
                        Filter.updateEffectedWidgets();
                      });
                    });
                  },
                ))));
  }
}
