import 'package:wellness_app/commons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardPage(key: ValueKey('dashboard_page')),
    StepsPage(key:ValueKey('steps_page')),
    MoodPage(key:ValueKey('mood_page')),
    HabitsPage(key:ValueKey('habits_page')),
    HydrationPage(key:ValueKey('hydration_page')),
    SettingsPage(key:ValueKey('settings_page'))
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    Widget content = IndexedStack(
      index: selectedIndex,
      children: pages,
    );
    return Scaffold(
      body: Row(
        children: [if(isWide)
          if (isWide)
            SafeArea(
              child: NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) => setState(() => selectedIndex = index),
                labelType: NavigationRailLabelType.all,
                useIndicator: true,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: Text('Dashboard'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.accessibility_new_outlined),
                    selectedIcon: Icon(Icons.accessibility_new),
                    label: Text('Steps'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_outline),
                    selectedIcon: Icon(Icons.favorite),
                    label: Text('Wellness'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.adb_outlined),
                    selectedIcon: Icon(Icons.adb_sharp),
                    label: Text('Habits'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.water_drop_outlined),
                    selectedIcon: Icon(Icons.water_drop),
                    label: Text('Hydration')
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('Settings'))

                ],
              ),
            ),
          Expanded(
            child: Semantics(
              label: 'Main content',
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: content,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isWide ? null : BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (i) => setState(() => selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wellness'),
          BottomNavigationBarItem(icon: Icon(Icons.accessibility_new), label: 'Steps'),
          BottomNavigationBarItem(icon: Icon(Icons.adb), label: 'Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Hydration'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}