import 'app.dart';
import 'commons.dart';

//glowna funkcja ranujaca apke
void main() {
  runApp(
      ChangeNotifierProvider(create:(context) => ScoreProvider(), child:const WellnessApp()));
}
