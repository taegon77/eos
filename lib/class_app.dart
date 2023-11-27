import 'package:eos/timer_item.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// class TimerItem {
//   bool isRunning = false;
//   int time = 0;
//   var name = "과목 이름";
//   TimerItem(this.name);
// }

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
  var _nowRunning;
  List<TimerItem> timerItems = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    setState(() {
      if (_isRunning) {
        timerItems.forEach((element) {
          if (element.isRunning) element.time++;
        });
        _totalTime++;
      }
    });
  }

  void _startTimer(index) {
    setState(() {
      if (_isRunning == true) {
        timerItems[_nowRunning].isRunning = false;
      }
      _isRunning = true;
      timerItems[index].isRunning = true;
      _nowRunning = index;
    });
  }

  void _pauseTimer(index) {
    setState(() {
      timerItems[index].isRunning = false;
      if (!timerItems.any((element) => element.isRunning)) _isRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _totalTime = 0;
      timerItems.forEach((element) {
        element.time = 0;
        element.isRunning = false;
      });
    });
  }

  void _resetEachTimer(index) {
    setState(() {
      _totalTime = _totalTime - timerItems[index].time;
      timerItems[index].time = 0;
      timerItems[index].isRunning = false;
      _isRunning = false;
    });
  }

  void addItem(String subjectName) {
    timerItems.add(TimerItem(subjectName));
  }

  @override
  Widget build(BuildContext context) {
    var totalSec = (_totalTime % 60).toString().padLeft(2, '0');
    var totalMin = ((_totalTime ~/ 60) % 60).toString().padLeft(2, '0');
    var totalHour = (_totalTime ~/ 3600).toString().padLeft(2, '0');

    return Scaffold(
        appBar: AppBar(
          title: const Text('EOS BASIC'),
          centerTitle: true,
          backgroundColor: Colors.green,
          leading: Icon(Icons.dehaze),
          actions: [Icon(Icons.settings_outlined)],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  TextEditingController controller = TextEditingController();

                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SizedBox(
                        height: 300,
                        child: Column(
                          children: [
                            Text(
                              '과목명을 입력하세요',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 10,
                              ),
                              child: TextField(
                                controller: controller,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                addItem(controller.text);
                                print(controller.text);
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.check_circle_outline,
                                size: 40,
                              ),
                            )
                          ],
                        )),
                  );
                });
          },
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
                  'assets/배경_1.jpg',
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
              Expanded(
                  child: ListView.builder(
                      itemCount: timerItems.length,
                      itemBuilder: (context, index) {
                        var sec = (timerItems[index].time % 60)
                            .toString()
                            .padLeft(2, '0');
                        var min = ((timerItems[index].time ~/ 60) % 60)
                            .toString()
                            .padLeft(2, '0');
                        var hour = (timerItems[index].time ~/ 3600)
                            .toString()
                            .padLeft(2, '0');

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          timerItems[index].isRunning
                                              ? _pauseTimer(index)
                                              : _startTimer(index);
                                        },
                                        icon: timerItems[index].isRunning
                                            ? Icon(
                                                Icons.pause_circle,
                                                size: 40,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.play_circle,
                                                size: 40,
                                                color: Colors.green,
                                              ),
                                      ),
                                      if (timerItems[index].time != 0)
                                        IconButton(
                                            padding: EdgeInsets.all(0),
                                            onPressed: () {
                                              _resetEachTimer(index);
                                            },
                                            icon: Icon(
                                              Icons.stop_circle,
                                              size: 40,
                                              color: Colors.redAccent,
                                            )),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      timerItems[index].name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                  Text(
                                    "$hour:$min:$sec",
                                    style: TextStyle(fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 3,
                              color: Colors.black,
                            ),
                          ],
                        );
                      }))
            ],
          ),
        )));
  }
}

// import 'package:eos/class_app.dart';
// import 'package:flutter/material.dart';
// import 'package:eos/answer_app.dart';
// import 'package:eos/assign_app.dart';

// void main() {
//   runApp(
//     MaterialApp(
//       home: ClassApp(),
//     ),
//   );
// }
