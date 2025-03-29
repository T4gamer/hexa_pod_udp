import 'package:flutter/material.dart';
import 'package:hexapod_udp/udp_service.dart';

import 'horizontal_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UDPService().initialize(
    ip: '192.168.4.1',
    port: 1234,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEXAPOD CONTROL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HexaPodControlPage(),
    );
  }
}