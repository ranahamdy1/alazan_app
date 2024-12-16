import 'package:flutter/material.dart';
import 'core/helper/cache_helper.dart';
import 'core/helper/dio_helper.dart';
import 'features/view/alazan_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: const AlazanScreen(),
    );
  }
}

