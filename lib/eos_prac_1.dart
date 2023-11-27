import 'package:basic/timer_item.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ClassApp extends StatefulWidget {
  const ClassApp({super.key});

  @override
  State<ClassApp> createState() => _ClassAppState();
}

class _ClassAppState extends State<ClassApp> {
  var _time = 0;
  var _totalTime = 0;
  var _isRunning = false;
  var _timer;
  List<TimerItem> timeItems = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    setState(() {
      if (_isRunning) {
        _time++;
        _totalTime++;
      }
    });
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _time = 0;
      _totalTime = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var sec = (_time % 60).toString().padLeft(2, '0');
    var min = ((_time ~/ 60) % 60).toString().padLeft(2, '0');
    var hour = (_time ~/ 3600).toString().padLeft(2, '0');

    var totalSec = (_totalTime % 60).toString().padLeft(2, '0');
    var totalMin = ((_totalTime ~/ 60) % 60).toString().padLeft(2, '0');
    var totalHour = (_totalTime ~/ 3600).toString().padLeft(2, '0');

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('EOS BASIC'),
            centerTitle: true,
            backgroundColor: Colors.green,
            leading: Icon(Icons.dehaze),
            actions: [Icon(Icons.settings_outlined)],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _resetTimer,
                  child: Image.asset(
                    'assets/soccerBall.jpg',
                    width: 150,
                    height: 150,
                  ),
                ),
                Text(
                  "$totalHour:$totalMin:$totalSec",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 100,
                ),
                Divider(
                  height: 3,
                  color: Colors.black,
                ),
              ],
            ),
          ))),
    );
  }
}
