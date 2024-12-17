import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'core/helper/cache_helper.dart';
import 'core/helper/dio_helper.dart';
import 'features/controller/alazan_cubit.dart';
import 'features/view/alazan_screen.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await DioHelper.init();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("Notification Action: ${response.actionId}");
      if (response.actionId != null && response.actionId == 'stop_sound') {
        print("Stop sound button pressed.");
        stopSound(); // استدعاء دالة stopSound لإيقاف الصوت
      } else {
        print("No action or invalid actionId.");
      }
    },
  );
  runApp(MyApp(flutterLocalNotificationsPlugin));
}

void stopSound() async {
  try {
    await _audioPlayer.stop();
    print("Sound stopped via notification action.");
  } catch (e) {
    print("Error stopping sound: $e");
  }
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const MyApp(this.flutterLocalNotificationsPlugin, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => AlazansCubit()..getAlazan(),
        child: AlazanScreen(
          flutterLocalNotificationsPlugin,
          audioPlayer: _audioPlayer,
        ),
      ),
    );
  }
}
