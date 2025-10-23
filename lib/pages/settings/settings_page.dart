import 'package:wellness_app/commons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UserDataWidget(),
        const Spacer(),
      Padding(
        padding: const EdgeInsets.all(16.0),

           child: ElevatedButton(
                onPressed: ()  async { await FirebaseAuth.instance.signOut();},
            child: const Text("Logout")
           ),
        ),
        const SizedBox(height: 16),
      ],
    ),
    );
  }
}