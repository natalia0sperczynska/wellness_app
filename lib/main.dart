import 'app.dart';
import 'commons.dart';

//glowna funkcja ranujaca apke
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DailyScoreAdapter());
  await Hive.openBox<DailyScore>('daily_scores');
  runApp(
      ChangeNotifierProvider(create:(context) => ScoreProvider()..loadData(), child:const WellnessApp()));
}
