import 'package:alazan_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:alazan_app/features/controller/alazan_cubit.dart';
import 'package:alazan_app/features/controller/alazan_state.dart';

class AlazanScreen extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final AudioPlayer audioPlayer;

  AlazanScreen(this.flutterLocalNotificationsPlugin, {super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    startListeningToPlayerState();

    return BlocConsumer<AlazansCubit, AlazanState>(
      listener: (context, state) {
        if (state is AlazanSuccessState) {
          final prayerTimes = state.alazanModel?.data?.timings;
          if (prayerTimes != null) {
            _showNotification(
              flutterLocalNotificationsPlugin,
              'Prayer Time',
              'Fajr is at ${prayerTimes.fajr}',
            );
          }
        }
      },
      builder: (context, state) {
        if (state is AlazanLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AlazanSuccessState) {
          final timings = state.alazanModel?.data?.timings;
          if (timings != null) {
            return _buildPrayerScreen(timings);
          }
        }

        if (state is AlazanFailedState) {
          return Center(child: Text("Failed to load data: ${state.msg}"));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Scaffold _buildPrayerScreen(timings) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPrayerTile('Fajr', timings.fajr),
            _buildPrayerTile('Sunrise', timings.sunrise),
            _buildPrayerTile('Dhuhr', timings.dhuhr),
            _buildPrayerTile('Asr', timings.asr),
            _buildPrayerTile('Maghrib', timings.maghrib),
            _buildPrayerTile('Isha', timings.isha),
            const SizedBox(height: 20),
            const ElevatedButton(
              onPressed: stopSound,
              child: Text("Stop Sound"),
            ),
          ],
        ),
      ),
    );
  }

  void startListeningToPlayerState() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      print("Audio Player State: $state");
    });
  }

  Widget _buildPrayerTile(String prayer, String? time) {
    return Text(
      "$prayer: ${time ?? "Not available"}",
      style: const TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  void _showNotification(
      FlutterLocalNotificationsPlugin plugin, String title, String body) async {
    try {
      await audioPlayer.play(AssetSource('notification_sound.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'prayer_channel_id',
      'Prayer Notifications',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      actions: [
        AndroidNotificationAction(
          'stop_sound',  // تأكد من أن هذه القيمة هي نفسها التي تستخدمها في `onDidReceiveNotificationResponse`
          'Stop Sound',
          icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
      ],
    );


    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );


    await plugin.show(0, title, body, notificationDetails);
  }

}