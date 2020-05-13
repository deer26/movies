import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  FlutterLocalNotificationsPlugin plugin;

  @override
  void initState() {
    super.initState();

    var initSetAnd = new AndroidInitializationSettings("app_icon");
    // var initSetAnd = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initSetIOS = new IOSInitializationSettings();

    var initSet = new InitializationSettings(initSetAnd, initSetIOS);
    plugin = FlutterLocalNotificationsPlugin();
    plugin.initialize(initSet, onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _showNotifWithoutDefSound,
              child: Text("Notification default"),
            ),
            RaisedButton(
              onPressed: _showNotifSchedule,
              child: Text("Notification Schedule"),
            ),
            RaisedButton(
              onPressed: _showNotifPreiodic,
              child: Text("Notification Periodic Schedule"),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Notification without Sound"),
            ),
          ],
        ),
      ),
    );
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Here is your payload"),
        content: new Text("Payload =$payload"),
      ),
    );
  }

  Future _showNotifWithoutDefSound() async {
    var andPlatChanSpec = new AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        importance: Importance.Max);
    var iosPlatChanSpec = new IOSNotificationDetails();

    var platChanSpec =
        new NotificationDetails(andPlatChanSpec, iosPlatChanSpec);

    await plugin.show(
      0,
      "Selams",
      "İlk bildirimim",
      platChanSpec,
      payload: "Default_Sound",
    );
  }

  Future _showNotifSchedule() async {
    var scheduleNotifDateTime = DateTime.now().add(Duration(seconds: 10));

    var andPlatChnSpec = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        importance: Importance.Max);
    var iOsPlatChanSpec = IOSNotificationDetails();

    NotificationDetails platChanSpec =
        NotificationDetails(andPlatChnSpec, iOsPlatChanSpec);

    await plugin.schedule(2, "kurulmş", "10 sn önce tetiklendi",
        scheduleNotifDateTime, platChanSpec,
        payload: "Default_Sound");
  }

  Future _showNotifPreiodic() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeating channel id',
        'repeating channel name',
        'repeating description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await plugin.periodicallyShow(3, "Periodic", "This notif.send periodicly",
        RepeatInterval.EveryMinute, platformChannelSpecifics);
  }
}
