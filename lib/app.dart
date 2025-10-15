import 'commons.dart';

class WellnessApp extends StatelessWidget {
  const WellnessApp({super.key});

  // This widget is the root of your application.//glowny widget apki
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      theme: lightTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      // home: const MyHomePage(title: 'Wellness App'),
    ); //ustawiam co ma byc home page
  }
}
