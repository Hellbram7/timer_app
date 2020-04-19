import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {

  runApp(myapp());

}

class myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Watch",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homepage(),
      
    );
  }
}

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> with TickerProviderStateMixin{
  TabController tb;
  int hour = 0;
  int min = 0;
  int sec = 0;
  String timetodisplay = "";
  bool started = true;
  bool stopped = true;
  int timefortimer;
  bool canceltimer = false;

  @override
  void initState() {
    tb = TabController(length: 2, vsync: this,);
    super.initState();
  }

  void start() {
    setState(() {
      started = false;
      stopped = false;
    });
    timefortimer = ((hour*3600) + (min*60) + sec);
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
         if(timefortimer < 1 || canceltimer == true) {
         t.cancel();
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homepage(),
         ));
       }
       else if(timefortimer < 60) {
         timefortimer = timefortimer - 1;
         timetodisplay = timefortimer.toString();
       }
       else if(timefortimer < 3600) {
          int m = timefortimer ~/ 60;
          int s = timefortimer - (60*m);
          timetodisplay = m.toString() + ":" + s.toString();
          timefortimer = timefortimer - 1;
       }
       else {
         int h = timefortimer ~/ 3600;
         int t = timefortimer - (3600*h);
         int m = t ~/ 60;
         int s = t - (60*m);
         timetodisplay = h.toString() + ":" + m.toString() + ":" + s.toString();
         timefortimer = timefortimer - 1;
       }
      });
    });
  }

  void stop() {
    started = true;
    stopped = true;
    canceltimer = true;
    timetodisplay = "";
  }

  Widget timer() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "HH",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                      ),
                    ),
                    NumberPicker.integer(initialValue: hour, minValue: 0, maxValue: 23, 
                    listViewWidth: 60.0,
                    onChanged: (val) {
                      setState(() {
                        hour = val;
                      });
                    }
                    ),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "MM",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                      ),
                    ),
                    NumberPicker.integer(initialValue: min, minValue: 0, maxValue: 59, 
                    listViewWidth: 60.0,
                    onChanged: (val) {
                      setState(() {
                        min = val;
                      });
                    }
                    ),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "SS",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                      ),
                    ),
                    NumberPicker.integer(initialValue: sec, minValue: 0, maxValue: 59,
                    listViewWidth: 60.0,
                    onChanged: (val) {
                      setState(() {
                        sec = val;
                      });
                    }
                    ),
                  ],
                ),
              ],
            ),
            ),

            Expanded(
            flex: 1,
            child: Text(
              timetodisplay,
              style: TextStyle(
                fontSize: 50,
                fontFamily: "Hind",
                fontWeight: FontWeight.bold,
                color:  Colors.blue,
              ),
            ),
            ),

            Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 12.0),
                  color: Colors.blue,
                  onPressed: started ? start : null,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                 RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 12.0),
                  onPressed: stopped ? null : stop,
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                   ),
                  child: Text(
                    "Stop",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            ),
        ],
      ),
    );
  }

  bool startpressed = true;
  bool stoppressed = true;
  bool resetpressed = true;
  String stoptimetodisplay = "00:00:00";
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);

  void starttimer() {
    Timer(dur, keeprunning);
  }

  void keeprunning() {
      if(swatch.isRunning) {
        starttimer();

      }
      setState(() {
        stoptimetodisplay = swatch.elapsed.inHours.toString().padLeft(2, "0") + ":" +
                            (swatch.elapsed.inMinutes%60).toString().padLeft(2, "0") + ":" +
                            (swatch.elapsed.inSeconds%60).toString().padLeft(2, "0") ;

      });
  }

  void startstopwatch() {
    setState(() {
      stoppressed = false;
      startpressed = false;
    });
    swatch.start();
    starttimer();
  }

  void stopstopwatch() {
    setState(() {
      stoppressed = true;
      resetpressed = false;
    });
    swatch.stop();
    
  }

    void resetstopwatch() {
      setState(() {
        startpressed = true;
        resetpressed = true;
      });
      swatch.reset();
      stoptimetodisplay = "00:00:00";
    
  }
  Widget stopwatch() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              child: Text(
              stoptimetodisplay,
              style: TextStyle(
                fontSize: 50.0,
                color: Colors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
            ),
            ),
           Expanded(
             flex: 4,
             child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: stoppressed ? null : stopstopwatch,
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Stop",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: resetpressed ? null : resetstopwatch,
                          color: Colors.teal,
                          padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Reset",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                         RaisedButton(
                          onPressed: startpressed ?  startstopwatch : null,
                          color: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Start",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  ],
                ),
             ),
           ),
        ],
      ),
    );
          
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Watch"
        ),
        bottom: TabBar(
          tabs: <Widget>[
            Text(
               "Timer"
            ),
            Text(
              "Stopwatch"
            ),
          ],
          labelStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          labelPadding: EdgeInsets.only(bottom: 10.0),
          unselectedLabelColor: Colors.white54,
          controller: tb,
          ),
      ),
      body: TabBarView(
        children: <Widget>[
            timer(),
            stopwatch(),
        ],
        controller: tb,
      ),
      
    );
  }
}
