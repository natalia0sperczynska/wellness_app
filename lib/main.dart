import 'app.dart';
import 'commons.dart';

//glowna funkcja ranujaca apke
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ChangeNotifierProvider(create:(context) => ScoreProvider()..loadData(), child:const WellnessApp()));
}
