import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:physio_tracker_app/screens/eventFilter/subTile.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;

class PriceRangeFilter extends StatefulWidget {
  static const RangeValues defaultValues = RangeValues(0, 1000);
  static RangeValues values = defaultValues;

  static _PrceRangeFilterState priceRangeFilterState;

  @override
  _PrceRangeFilterState createState() => generateState();

  _PrceRangeFilterState generateState() {
    priceRangeFilterState = _PrceRangeFilterState();
    return priceRangeFilterState;
  }

  TextFormField minTextField;
  TextFormField maxTextField;
}

class _PrceRangeFilterState extends State<PriceRangeFilter> {
  FocusNode minFocusNode;
  FocusNode maxFocusNode;
  TextEditingController minController;
  TextEditingController maxController;

  @override
  void initState() {
    super.initState();
    minFocusNode = FocusNode();
    maxFocusNode = FocusNode();
    minController = TextEditingController();
    maxController = TextEditingController();

    minFocusNode.addListener(() {
      minFocusListener();
    });

    maxFocusNode.addListener(() {
      maxFocusListener();
    });
  }

  @override
  void dispose() {
    super.dispose();
    minFocusNode.dispose();
    maxFocusNode.dispose();
    minController.dispose();
    maxController.dispose();
  }

  void resetFilter() {
    setState(() {
      PriceRangeFilter.values = PriceRangeFilter.defaultValues;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.minTextField = minimumTextField();
    widget.maxTextField = maximumTextField();

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView(children: <Widget>[
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        FlatButton(
                          splashColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: Text(copy.filterDrawerLeftButtonText,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentColor)),
                          onPressed: () {
                            resetFilter();
                          },
                        ),
                        const Text('Price Range',
                            style: TextStyle(fontSize: 20)),
                        FlatButton(
                          splashColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: Text(copy.filterDrawerRightButtonText,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentColor)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: SubTile(
                      tileHeading: 'Event Price',
                      trailingWidget: null,
                    ),
                  ),
                  customRangeSlider(),
                  Container(
                      padding: const EdgeInsets.only(top: 40),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                              height: 45,
                              width: 150,
                              child: widget.minTextField),
                          const Text('-',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          Container(
                              height: 45,
                              width: 150,
                              child: widget.maxTextField),
                        ],
                      ))
                ]))));
  }

  Widget customRangeSlider() {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.attach_money,
                size: 18,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: RangeSlider(
                    min: PriceRangeFilter.defaultValues.start,
                    max: PriceRangeFilter.defaultValues.end,
                    values: PriceRangeFilter.values,
                    labels: RangeLabels(
                        '\$${PriceRangeFilter.values.start.round()}',
                        '\$${PriceRangeFilter.values.end.round()}'),
                    onChanged: (RangeValues _values) {
                      setState(() {
                        PriceRangeFilter.values = _values;
                      });
                    },
                  )),
              Icon(
                Icons.attach_money,
                size: 25,
              ),
            ]));
  }

  Widget minimumTextField() {
    return TextFormField(
      focusNode: minFocusNode,
      keyboardAppearance: Theme.of(context).brightness,
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      maxLines: 1,
      controller: TextEditingController(
          text: PriceRangeFilter.values.start.toInt().toString()),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Min Price',
      ),
      onChanged: (String val) {
        minController.text = val;
      },
    );
  }

  void minFocusListener() {
    if (!minFocusNode.hasFocus) {
      setState(() {
        if (double.parse(minController.text) <= PriceRangeFilter.values.end &&
            double.parse(minController.text) >=
                PriceRangeFilter.defaultValues.start)
          PriceRangeFilter.values = RangeValues(
              double.parse(minController.text), PriceRangeFilter.values.end);
      });
    }
  }

  void maxFocusListener() {
    if (!maxFocusNode.hasFocus) {
      setState(() {
        if (double.parse(maxController.text) >= PriceRangeFilter.values.start &&
            double.parse(maxController.text) <=
                PriceRangeFilter.defaultValues.end)
          PriceRangeFilter.values = RangeValues(
              PriceRangeFilter.values.start, double.parse(maxController.text));
      });
    }
  }

  Widget maximumTextField() {
    return TextFormField(
      focusNode: maxFocusNode,
      keyboardAppearance: Theme.of(context).brightness,
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      maxLines: 1,
      controller: TextEditingController(
          text: PriceRangeFilter.values.end.toInt().toString()),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Max Price',
      ),
      onChanged: (String val) {
        maxController.text = val;
      },
    );
  }
}
