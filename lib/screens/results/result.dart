import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:physio_tracker_app/widgets/shared/app_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physio_tracker_app/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:physio_tracker_app/models/completed_exercise.dart';
import 'package:physio_tracker_app/screens/results/resultDetail.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Result extends StatefulWidget {
  const Result({Key key, @required this.exercise}) : super(key: key);
  final CompletedExercise exercise;
  @override
  _Result createState() => _Result();
}



class _Result extends State<Result> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 14;
  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;
  bool _rememberMe = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x,  showingTooltipIndicators: [0, 1], barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        y: y2,
        color: rightBarColor,
        width: width,
      ),
    ]);
  }
  @override
  void initState() {
    super.initState();
    var items = <BarChartGroupData>[];

    for (int i = 0; i < widget.exercise.correct_reps_array.length; i++) {
      items.add(makeGroupData(0, widget.exercise.correct_reps_array[i].toDouble(), widget.exercise.total_reps_array[i].toDouble()));
    }

    rawBarGroups = items;
    print(rawBarGroups.toString());

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.exercise);
    Widget makeTransactionsIcon() {
      const double width = 4.5;
      const double space = 3.5;
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width,
            height: 10,
            color: Colors.white.withOpacity(0.4),
          ),
          const SizedBox(
            width: space,
          ),
          Container(
            width: width,
            height: 28,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(
            width: space,
          ),
          Container(
            width: width,
            height: 42,
            color: Colors.white.withOpacity(1),
          ),
          const SizedBox(
            width: space,
          ),
          Container(
            width: width,
            height: 28,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(
            width: space,
          ),
          Container(
            width: width,
            height: 10,
            color: Colors.white.withOpacity(0.4),
          ),
        ],
      );
    }

    print(showingBarGroups);

    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    BarChartData(
                      maxY: 50,
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipPadding: const EdgeInsets.all(0),
                            tooltipBottomMargin: 8,
                            getTooltipItem: (
                                BarChartGroupData group,
                                int groupIndex,
                                BarChartRodData rod,
                                int rodIndex,
                                ) {
                              return BarTooltipItem(
                                rod.y.round().toString(),
                                TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          touchCallback: (response) {
                            if (response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex = response.spot.touchedBarGroupIndex;
                            //touchedGroupIndex = response.spot.touchedBarGroupIndex;
                            Navigator.of(context)
                                .push<dynamic>(DefaultPageRoute<dynamic>(
                                pageRoute: ResultDetail(exercise: widget.exercise, index: touchedGroupIndex, )));
                          }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 20,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Mon';
                              case 1:
                                return 'Tue';
                              case 2:
                                return 'Wed';
                              case 3:
                                return 'Thu';
                              case 4:
                                return 'Fri';
                              case 5:
                                return 'Sat';
                              case 6:
                                return 'Sun';
                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 32,
                          reservedSize: 14,
                          getTitles: (value) {
                            if (value == 0) {
                              return '0';
                            } else if (value == 5) {
                              return '5';
                            } else if (value == 10) {
                              return '10';
                            } else if (value == 15) {
                              return '15';
                            }
                            else if (value == 20) {
                              return '20';
                            }
                            else if (value == 25) {
                              return '25';
                            }
                            else if (value == 30) {
                              return '30';
                            }
                            else if (value == 35) {
                              return '35';
                            }
                            else if (value == 40) {
                              return '40';
                            }
                            else {
                              return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }


}

class Day {
  final int reps;
  final String date; // 3/15

  Day(this.reps, this.date);
}