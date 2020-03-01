import 'package:auto_size_text/auto_size_text.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/screens/account/image_type.dart';
import 'package:physio_tracker_app/services/cloudStorage.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/widgets/shared/appBarPage.dart';
import 'package:physio_tracker_app/widgets/shared/circularProgressDialog.dart';
import 'package:physio_tracker_app/widgets/shared/defaultTextField.dart';
import 'package:physio_tracker_app/widgets/shared/standardAlertDialog.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:physio_tracker_app/widgets/shared/standardButton.dart';
import 'package:physio_tracker_app/screens/eventCreation/widgets/subHeadingRow.dart';
import 'package:physio_tracker_app/screens/eventCreation//widgets/repeatDialog.dart';
import 'package:physio_tracker_app/screens/eventCreation/widgets/cancelDialog.dart';
import '../../copyDeck.dart' as copy;
import './headerImage.dart';
import 'googlePlacesButton.dart';

class EventCreation extends StatefulWidget {
  const EventCreation({Key key, @required this.user, this.event})
      : super(key: key);
  final FirebaseUser user;
  final Event event;

  @override
  _EventCreationState createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
  bool eventUpdate;
  int initialCapacity = 0;
  TextEditingController titleTextController;
  TextEditingController priceTextController;
  TextEditingController durationTextController;
  TextEditingController daysCancelTextController;
  TextEditingController descriptionTextController;
  TextEditingController capacityTextController;
  TextEditingController contactTextController;
  TextEditingController additionalInfoController;
  GooglePlacesButton googlePlacesButton;
  Brightness appBarBrightness;

  //List<dynamic> additionalInfo;
  List<dynamic> eventImageSrcUrls;
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US').add_jm();
  DateTime dateTimeStart;
  List<dynamic> dateTimeStartList;
  DateTime dateTimeEnd;
  DateTime dateTimeCancellation;
  List<bool> categoriesSelected;
  Duration eventStartRestriction = const Duration(days: 1);
  Duration minEventDuration = const Duration(minutes: 5);
  String cancellationDropdownValue;
  String repeatDropdownValue;

  @override
  void initState() {
    dateTimeStartList = <dynamic>[];
    eventUpdate = widget.event != null;
    appBarBrightness = Brightness.light;
    categoriesSelected = List<bool>(copy.categories.length);
    categoriesSelected =
        categoriesSelected.map((bool val) => val = false).toList();
    titleTextController =
        TextEditingController(text: eventUpdate ? widget.event.title : null);
    priceTextController = TextEditingController(
        text: eventUpdate ? widget.event.price.toStringAsFixed(2) : null);
    capacityTextController = TextEditingController(
        text: eventUpdate ? widget.event.capacity.toString() : null);
    descriptionTextController = TextEditingController(
        text: eventUpdate ? widget.event.description : null);
    contactTextController = TextEditingController(
        text: eventUpdate ? widget.event.hostContact : null);
    additionalInfoController = TextEditingController();
    durationTextController = TextEditingController(
        text: eventUpdate ? widget.event.duration.toStringAsFixed(0) : null);
    daysCancelTextController = TextEditingController(
        text:
            eventUpdate ? widget.event.daysCancelBy.toStringAsFixed(0) : null);

    if (!eventUpdate) {
      googlePlacesButton = GooglePlacesButton(text: 'Location');
      _addDateField();
    } else {
      eventImageSrcUrls = <dynamic>[widget.event.imageSrc];
      eventImageSrcUrls = eventImageSrcUrls + widget.event.multiImageSrc;
      // additionalInfo = additionalInfo + widget.event.additionalInfo;
      setSelectedCategoriesBool();
      initialCapacity = widget.event.capacity;
      if (copy.cancellationPolicyValues
          .contains(widget.event.cancellationPolicy)) {
        cancellationDropdownValue = widget.event.cancellationPolicy;
      }
      additionalInfoController = TextEditingController(
          text: widget.event.additionalInfo == null ||
                  widget.event.additionalInfo.isEmpty
              ? null
              : widget.event.additionalInfo[0]);
      googlePlacesButton = GooglePlacesButton(
          text: widget.event.address,
          address: widget.event.address,
          city: widget.event.city,
          geoPoint: widget.event.geoPoint);
      dateTimeStartList = <DateTime>[widget.event.date];
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleTextController.dispose();
    priceTextController.dispose();
    capacityTextController.dispose();
    descriptionTextController.dispose();
    contactTextController.dispose();
    additionalInfoController.dispose();
    durationTextController.dispose();
    daysCancelTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPage(
            title: eventUpdate
                ? copy.editEventAppBarText
                : copy.eventCreationAppBarText,
            brightness: appBarBrightness),
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              GestureDetector(
                onTap: uploadEventPhoto(context),
                child: HeaderImage(
                  imageSrcUrls: eventImageSrcUrls,
                  containerHeight: MediaQuery.of(context).size.height / 2.8,
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              DefaultTextField(
                textController: titleTextController,
                hintText: copy.titleEventText,
                required: true,
              ),
              _getDivider(),
              DefaultTextField(
                textController: descriptionTextController,
                hintText: copy.descriptionText,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                required: true,
              ),
              _getGreySpace(),
              DefaultTextField(
                textController: capacityTextController,
                hintText: copy.capacityText,
                keyboardType: TextInputType.number,
                required: true,
              ),
              _getDivider(),
              DefaultTextField(
                  textController: priceTextController,
                  hintText: copy.priceEventText,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  required: true),
              _getDivider(),
              DefaultTextField(
                  textController: contactTextController,
                  hintText: copy.phoneEventText,
                  keyboardType: TextInputType.phone,
                  required: true),
              _getDivider(),
              DefaultTextField(
                  textController: additionalInfoController,
                  hintText: copy.additionalInfo,
                  keyboardType: TextInputType.multiline,
                  required: false,
                  maxLines: 6),
              //Start Date Time
              SubHeadingRow(heading: copy.eventTime),
              DefaultTextField(
                  textController: durationTextController,
                  hintText: copy.duration,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  required: true),
              _getDivider(),
              _getAllDateWidget(),
              eventUpdate
                  ? Container()
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            child: Row(children: <Widget>[
                              Icon(Icons.add),
                              const Padding(padding: EdgeInsets.all(2)),
                              AutoSizeText(copy.addDate, maxFontSize: 16),
                            ]),
                            onPressed: _addDateField,
                          ),
                          RaisedButton(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.refresh),
                                  const Padding(padding: EdgeInsets.all(2)),
                                  AutoSizeText(copy.reoccur, maxFontSize: 16)
                                ],
                              ),
                              onPressed: repeatEveryFunction()),
                        ],
                      ),
                    ),

              Container(
                child: googlePlacesButton,
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 12.0),
                child: Text(
                  copy.categoriesEventText,
                  style: Theme.of(context)
                      .textTheme
                      .display4
                      .copyWith(color: Colors.black54, fontSize: 17.0),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                  child: Wrap(
                      spacing: 5.0, // gap between adjacent chips
                      children: _getFlutterChips())),
              SubHeadingRow(heading: copy.cancellationPolicy),
              DefaultTextField(
                textController: daysCancelTextController,
                hintText: copy.daysCancelByText,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: false),
              ),
              _getDivider(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: DropdownButton<String>(
                    hint: Text(copy.policy),
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 16.0),
                    underline: const Padding(padding: EdgeInsets.all(5)),
                    onChanged: (String newValue) {
                      setState(() {
                        cancellationDropdownValue = newValue;
                      });
                    },
                    value: cancellationDropdownValue,
                    items: copy.cancellationPolicyValues
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
              ),
//Additional Info
//              Container(
//                padding:
//                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                color: Colors.black12,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    AutoSizeText(copy.additionalInfo,
//                        style: Theme.of(context).textTheme.body1.copyWith(
//                            fontSize: 16.0,
//                            color: Colors.black54,
//                            fontWeight: FontWeight.bold)),
//                    IconButton(
//                        icon: Icon(Icons.add),
//                        onPressed: () => _displayDialog(context))
//                  ],
//                ),
//              ),
//              _getAdditionalInfoItems(),
              cancelEvent(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: StandardButton(
                    text:
                        eventUpdate ? copy.updateEvent : copy.createEventButton,
                    onPressed: saveEventAndExit),
              ),
            ],
          ),
        ));
  }

  Function repeatEveryFunction() {
    if (dateTimeStartList.length == 1 && dateTimeStartList[0] != null) {
      return () {
        showDialog<BuildContext>(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: MediaQuery.of(context).size.height / 6.5),
                child: RepeatDialog(
                    firstDate: dateTimeStartList[0],
                    callback: (List<DateTime> reoccuringDates) {
                      setState(() {
                        dateTimeStartList = dateTimeStartList + reoccuringDates;
                      });
                    }),
              );
            });
      };
    } else {
      return null;
    }
  }

  Widget cancelEvent() {
    if (eventUpdate) {
      return Container(
          padding: const EdgeInsets.only(top: 10, left: 20),
          child: InkWell(
              child: AutoSizeText('Cancel Event',
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.red)),
              onTap: () => showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return CancelDialog(confirmationFunc: cancelEventFunc);
                  })));
    } else {
      return Container();
    }
  }

  void cancelEventFunc() {
    CloudDatabase.updateDocumentValue(
        collection: 'events',
        document: widget.event.id,
        key: db_key.eventCancelledDBKey,
        value: true);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    final Map<String, dynamic> map = <String, dynamic>{
      'message': copy.eventDetailUpdate,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
    };
    CloudDatabase.addAnouncementToEvent(
        widget.event, map, onAnnouncementCallback);
  }

  List<String> getSelectedCategoriesString() {
    final List<String> selectedCategories = <String>[];
    categoriesSelected.asMap().forEach((int index, bool isSelected) {
      if (isSelected) {
        selectedCategories.add(copy.categories[index]);
      }
    });

    return selectedCategories;
  }

  void onAnnouncementCallback(bool success) {
    if (success) {
      print('Notified Guests!');
    } else {
      print('Failed to deliver your updates to guests !');
    }
  }

  void setSelectedCategoriesBool() {
    for (int i = 0; i < copy.categories.length; i++) {
      if (widget.event.categories.contains(copy.categories[i])) {
        categoriesSelected[i] = true;
      }
    }
  }

  void saveEventAndExit() {
    if (titleTextController.text.isEmpty ||
        googlePlacesButton.text == 'Location' ||
        priceTextController.text.isEmpty ||
        capacityTextController.text.isEmpty ||
        dateTimeStartList == null ||
        dateTimeStartList[0] == null ||
        durationTextController.text.isEmpty ||
        descriptionTextController.text.isEmpty ||
        contactTextController.text.isEmpty ||
        !categoriesSelected.contains(true) ||
        eventImageSrcUrls == null ||
        eventImageSrcUrls.isEmpty) {
      StandardAlertDialog(
          context, copy.missingFieldsTitle, copy.missingFieldsContent);
      return;
    }

    if (int.parse(capacityTextController.text) < initialCapacity) {
      StandardAlertDialog(context, copy.lowerCapacity, '');
      return;
    }

    if (durationTextController.text != null &&
        double.parse(durationTextController.text) <= 0) {
      StandardAlertDialog(context, copy.endBeforeStart, '');
      return;
    }
    String multiDateKey =
        '${widget.user.uid}/${DateTime.now().microsecondsSinceEpoch}';
    List<Map<String, dynamic>> eventListMap = <Map<String, dynamic>>[];
    for (DateTime currentDate in dateTimeStartList) {
      final Map<String, dynamic> eventMap = <String, dynamic>{
        db_key.titleDBKey: titleTextController.text,
        db_key.priceDBKey: double.parse(priceTextController.text) ?? 0.0,
        db_key.dateDBKey: currentDate,
        db_key.durationDBKey: double.parse(durationTextController.text) ?? 0,
        db_key.descriptionDBKey: descriptionTextController.text,
        db_key.daysCancelByDBKey: daysCancelTextController.text == null ||
                daysCancelTextController.text.isEmpty
            ? 0
            : double.parse(daysCancelTextController.text),
        db_key.capacityDBKey: int.parse(capacityTextController.text) ?? 0,
        db_key.hostContactDBKey: contactTextController.text,
        db_key.categoriesDBKey: getSelectedCategoriesString(),
        db_key.cancellationPolicyDBKey: cancellationDropdownValue,
        db_key.eventCancelledDBKey: false,
        db_key.additionalInfoDBKey: additionalInfoController.text.isNotEmpty
            ? <String>[additionalInfoController.text]
            : null,
        db_key.imageSrcDBKey: eventImageSrcUrls[0],
        db_key.hostIdDBKey: widget.user.uid,
        db_key.multiImageSrcDBKey: (eventImageSrcUrls.length > 1)
            ? eventImageSrcUrls.sublist(1)
            : null,
        db_key.propertyDBKey: <String, dynamic>{
          db_key.locationDBKey: googlePlacesButton.point.data,
          db_key.cityDBKey: googlePlacesButton.city,
          db_key.addressDBKey: googlePlacesButton.address,
        },
        db_key.multiDateDBKey: eventUpdate
            ? widget.event.multiDateKey
            : dateTimeStartList.length > 1 ? multiDateKey : null,
    db_key.soldOutDateDBKey: null
      };
      eventListMap.add(eventMap);
    }

    if (eventUpdate) {
      CloudDatabase.updateDocumentValueWithMap(
          collection: 'events',
          document: widget.event.id,
          map: eventListMap[0],
          callback: () {
            Navigator.of(context, rootNavigator: true).pop();
            final Map<String, dynamic> map = <String, dynamic>{
              'message': copy.eventDetailUpdate,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
            };
            CloudDatabase.addAnouncementToEvent(
                widget.event, map, onAnnouncementCallback);
          });
    } else {
      CloudDatabase.createNewEventsMultiDate(eventListMap);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

// TODO(arvinth): upload after save button pressed, would need to display
  // asset image instead of network one image have been selected
  Function uploadEventPhoto(BuildContext context) {
    return () {
      MultiImagePicker.pickImages(
        maxImages: 6,
      ).then((List<Asset> resultList) {
        if (resultList.isNotEmpty) {
          CircularProgressDialog(context, () async {
            try {
              CloudStorage.uploadImages(
                id: '${widget.user.uid}/${DateTime.now().microsecondsSinceEpoch}',
                assets: resultList,
                imageType: ImageType.EVENT,
              ).then((List<String> url) {
                if (url != null && url.isNotEmpty) {
                  setState(() {
                    eventImageSrcUrls = url;
                  });
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  StandardAlertDialog(context, 'There was an error.',
                      'One or more pictures are not formatted correctly');
                }
              });
            } catch (e) {
              print(e);
              Navigator.pop(context);
            }
          });
        }
      });
    };
  }

  Widget _getGreySpace() {
    return Container(
        color: Colors.black12,
        padding: const EdgeInsets.symmetric(vertical: 15));
  }

  Widget _getDivider() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: const Divider(
          color: Colors.black26,
          height: 3,
        ));
  }

  List<Widget> _getFlutterChips() {
    final List<Widget> chips = <Widget>[];
    for (int i = 0; i < copy.categories.length; i++) {
      chips.add(Theme(
          data: ThemeData.dark(),
          child: FilterChip(
            label: Text(copy.categories[i],
                style: Theme.of(context).textTheme.body1.copyWith(
                    color:
                        categoriesSelected[i] ? Colors.white : Colors.black54)),
            selected: categoriesSelected[i],
            onSelected: (bool val) => setState(() {
              categoriesSelected[i] = val;
            }),
            selectedColor: Theme.of(context).accentColor,
            backgroundColor: Colors.white70,
          )));
    }
    return chips;
  }

//  Removing additional item list function, keeping incase kiqback decides to
//  readd
//
//  Future<Dialog> _displayDialog(BuildContext context) async {
//    return showDialog<Dialog>(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: Text(copy.additionalInfo),
//            content: TextField(
//              keyboardAppearance: Theme.of(context).brightness,
//              maxLines: 3,
//              controller: additionalInfoController,
//              decoration: InputDecoration(hintText: 'Enter information here'),
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: const Text('ADD'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                  _addAdditionalItem(additionalInfoController.text);
//                },
//              ),
//              FlatButton(
//                child: const Text('CANCEL'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              )
//            ],
//          );
//        });
//  }
//
//  void _addAdditionalItem(String info) {
//    setState(() {
//      additionalInfo.add(info);
//    });
//    additionalInfoController.clear();
//  }
//
//  // Generate list of item widgets
//  Widget _getAdditionalInfoItems() {
//    if (additionalInfo != null && additionalInfo.isNotEmpty) {
//      final List<Widget> _infoWidgets = [];
//      for (int i = 0; i < additionalInfo.length; i++) {
//        _infoWidgets.add(_buildTodoItem(additionalInfo[i], i));
//      }
//      return Column(children: _infoWidgets);
//    } else {
//      return Container();
//    }
//  }

  void _addDateField() {
    setState(() {
      dateTimeStartList.add(null);
    });
  }

  Widget _getAllDateWidget() {
    if (dateTimeStartList != null && dateTimeStartList.isNotEmpty) {
      final List<Widget> _infoWidgets = [];
      for (int i = 0; i < dateTimeStartList.length; i++) {
        _infoWidgets.add(getDateTimeStartItem(dateTimeStartList[i], i));
      }
      return Column(children: _infoWidgets);
    } else {
      return Container();
    }
  }

  Column getDateTimeStartItem(DateTime value, int index) {
    return Column(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: DateTimeField(
                    resetIcon: null,
                    initialValue: value,
                    format: dateFormat,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 16.0),
                    decoration: InputDecoration(
                        labelText: index == 0
                            ? copy.dateTextStart + '*'
                            : copy.dateTextStart,
                        fillColor: Theme.of(context).cursorColor,
                        border: InputBorder.none),
                    onChanged: (DateTime date) {
                      if (!dateTimeStartList.contains(date)) {
                        setState(() {
                          dateTimeStartList[index] = date;
                        });
                      }
                    },
                    onShowPicker:
                        (BuildContext context, DateTime currentValue) async {
                      value = await showDatePicker(
                          context: context,
                          //only create dates ahead one day
                          firstDate: DateTime.now().add(eventStartRestriction),
                          initialDate: currentValue ??
                              DateTime.now().add(eventStartRestriction),
                          lastDate: DateTime(2100));
                      if (value != null) {
                        final TimeOfDay time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        value = DateTimeField.combine(value, time);
                      } else {
                        value = currentValue;
                      }
                      if (dateTimeStartList.contains(value)) {
                        StandardAlertDialog(context, copy.dateExists, '');
                        value = null;
                      }
                      return value;
                    },
                  ),
                ),
                index != 0
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        color: Colors.black45,
                        onPressed: () => {
                          setState(() {
                            print(index);
                            dateTimeStartList.removeAt(index);
                          })
                        },
                      )
                    : Container(),
              ],
            )),
        _getDivider()
      ],
    );
  }
//
//  // Generate a single item widget
//  Widget _buildTodoItem(String title, int index) {
//    return Column(
//      children: <Widget>[
//        Container(
//            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
//            child: Row(
//              children: <Widget>[
//                Expanded(
//                    child: AutoSizeText(title,
//                        style: Theme.of(context)
//                            .textTheme
//                            .body1
//                            .copyWith(fontSize: 16.0))),
//                IconButton(
//                  icon: Icon(Icons.clear),
//                  color: Colors.black45,
//                  onPressed: () => {
//                    setState(() {
//                      additionalInfo.removeAt(index);
//                    })
//                  },
//                ),
//              ],
//            )),
//        _getDivider()
//      ],
//    );
//  }
}
