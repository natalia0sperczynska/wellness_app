
import 'package:wellness_app/commons.dart';
import 'package:wellness_app/styles/themes.dart';

class BarChartSteps extends StatefulWidget {
  final List<DailyScore> history;
  const BarChartSteps({super.key, required this.history});
  @override
  State<StatefulWidget> createState() => BarChartStepsState();
}

class BarChartStepsState extends State<BarChartSteps> {

  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
  final Color barColor = AppColors.primaryColor;
  final Color touchedBarColor = AppColors.accentColor;
  final Color barBackgroundColor = AppColors.secondaryColor;

  final double maxStepGoal = 10000.0;

  @override
  Widget build(BuildContext context) {
    final ScoreProvider _scoreProvider = context.read<ScoreProvider>();
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Step Chart',
                  style: TextStyle(
                    color: lightTheme.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Last 7 days',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 38,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(),
                      duration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color? barColor,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 100 : y,
          color: isTouched ? touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: touchedBarColor.withOpacity(0.2))
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxStepGoal,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(){
    final last7Days = widget.history.length <= 7
        ? widget.history
        : widget.history.sublist(widget.history.length - 7);

    return List.generate(7, (i) {
      if (i < last7Days.length) {
        final dayData = last7Days[i];
        return makeGroupData(
          i,
          dayData.steps.toDouble(),
          isTouched: i == touchedIndex,
        );
      } else {
        return makeGroupData(
          i,
          0,
          isTouched: i == touchedIndex,
        );
      }
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay = " ";
            final last7Days = widget.history.length <= 7
                ? widget.history
                : widget.history.sublist(widget.history.length - 7);
            if (groupIndex >= 0 && groupIndex < last7Days.length) {
              final dayData = last7Days[rodIndex];

              final dayName = {
                1: 'Monday',
                2: 'Tuesday',
                3: 'Wednesday',
                4: 'Thursday',
                5: 'Friday',
                6: 'Saturday',
                7: 'Sunday',
              };
               weekDay = dayName[dayData.date.weekday] ?? '';
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY.round() - (groupIndex == touchedIndex ? 100 : 0)).toString(), // Pokaż prawdziwą wartość
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    final index = value.toInt();
    String text = '';
    final last7Days = widget.history.length <= 7
        ? widget.history
        : widget.history.sublist(widget.history.length - 7);

    if (index >= 0 && index < last7Days.length) {
      final dayData = last7Days[index];

      final dayName = {
        1: 'M',
        2: 'T',
        3: 'W',
        4: 'T',
        5: 'F',
        6: 'S',
        7: 'S',
      };

      text = dayName[dayData.date.weekday] ?? '';
    }

    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Text(text, style: style),
    );
  }
  String getDayAbbreviation(int index) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    if (index >= 0 && index < days.length) {
      return days[index];
    }
    return '';
  }
}