import 'package:wellness_app/commons.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          print("User is logged in: ${snapshot.data!.uid}");
          return const HomePage();
        }

        print("User is logged out.");
        return const AuthPage();
      },
    );
  }
}