import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/screens/explore/explore.dart'; 
 


class ExploreProviderWrapper extends StatelessWidget {
  const ExploreProviderWrapper({Key key, @required this.textController}) : super(key: key);
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return  StreamProvider<List<Event>>.value(value: CloudDatabase.streamUpcommingEvents(),
            child: Explore(textController: textController,),);
  }
}

