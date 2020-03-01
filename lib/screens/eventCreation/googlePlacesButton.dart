import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:physio_tracker_app/services/location.dart' as location;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GooglePlacesButton extends StatefulWidget {
  GooglePlacesButton(
      {Key key, @required this.text, this.geoPoint, this.address, this.city})
      : super(key: key);
  String text;
  String address;
  String city;
  Geoflutterfire geo = Geoflutterfire();
  GeoFirePoint point;
  GeoPoint geoPoint;
  bool addressSet;

  @override
  _GooglePlacesButtonState createState() => _GooglePlacesButtonState();
}

class _GooglePlacesButtonState extends State<GooglePlacesButton> {
  @override
  void initState() {
    widget.addressSet = false;
    if (widget.geoPoint != null) {
      widget.point = widget.geo.point(
          latitude: widget.geoPoint.latitude,
          longitude: widget.geoPoint.longitude);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        splashColor: Colors.transparent,
        color:
            widget.addressSet ? Theme.of(context).accentColor : Colors.black12,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: widget.addressSet ? Colors.white : Colors.black54,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20),
              child: AutoSizeText(
                widget.text,
                style: TextStyle(
                    fontSize: 16.0,
                    color: widget.addressSet ? Colors.white : Colors.black54,
                    fontWeight: widget.addressSet
                        ? FontWeight.normal
                        : FontWeight.bold),
                maxLines: 3,
              ),
            ),
          ],
        ),
        onPressed: () async {
          final Prediction p = await PlacesAutocomplete.show(
              context: context,
              apiKey: location.kGoogleApiKey,
              hint: 'Search Location');
          if (p != null) {
            final PlacesDetailsResponse detail =
                await location.places.getDetailsByPlaceId(p.placeId);
            final double lat = detail.result.geometry.location.lat;
            final double lng = detail.result.geometry.location.lng;
            final String address = detail.result.formattedAddress;

            widget.city = '';
            String adminAreaLvl1 = '';
            String adminAreaLvl2 = '';

            for (AddressComponent comp in detail.result.addressComponents) {
              if (comp.types.contains('locality')) {
                widget.city = comp.shortName;
              } else if (comp.types.contains('administrative_area_level_2')) {
                adminAreaLvl2 = comp.shortName;
              } else if (comp.types.contains('administrative_area_level_1')) {
                adminAreaLvl1 = comp.shortName;
              }
            }

            if (widget.city == '') {
              widget.city = adminAreaLvl2 != '' ? adminAreaLvl2 : adminAreaLvl1;
            }

            widget.address = address;
            setState(() {
              widget.text = address;
              widget.addressSet = true;
            });

            widget.point = widget.geo.point(latitude: lat, longitude: lng);
          }
        },
        disabledColor: Theme.of(context).accentColor.withOpacity(0.4),
      ),
    );
  }
}
