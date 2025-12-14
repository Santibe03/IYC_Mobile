import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'I&C',
      home: WelcomePage(), // 👈 ESTA ES LA QUE APARECE AL INICIAR
    );
  }
}
// pense que estaba en otra rama perdon, xdxd