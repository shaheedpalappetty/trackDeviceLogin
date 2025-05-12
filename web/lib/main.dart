import 'package:flutter/material.dart';
import 'package:web/homepage.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    fullScreen: true,
    alwaysOnTop: true,
    skipTaskbar: true,
    title: 'Kiosk Mode App',
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setFullScreen(true);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setSkipTaskbar(true);
    await windowManager.setPreventClose(true);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyKioskApp());
}

class MyKioskApp extends StatelessWidget {
  const MyKioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Kiosk Mode App',
      debugShowCheckedModeBanner: false,
      home: KioskHomePage(),
    );
  }
}
