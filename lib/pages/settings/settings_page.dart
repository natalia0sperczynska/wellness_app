import 'package:wellness_app/commons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Center(
           child: ElevatedButton(
                onPressed: ()  async { await FirebaseAuth.instance.signOut();},
            child: const Text("Logout")
           ), // <-- Add comma here
        ), // <-- Add parenthesis here
    ); // <-- Add parenthesis here
  }
}