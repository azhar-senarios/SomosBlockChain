import 'package:collection/collection.dart';

import '../../all_screen.dart';
import '../../all_utills.dart';

class BottomNavIndexNotifier extends StateNotifier<int> {
  BottomNavIndexNotifier(super.val);

  void updateCurrentIndex(int index) => state = index;
}

final bottomNavigationIndexProvider =
    StateNotifierProvider<BottomNavIndexNotifier, int>((ref) {
  return BottomNavIndexNotifier(0);
});

class DashBoardScreen extends ConsumerStatefulWidget {
  static const String routeName = '/DashBoardScreen';

  const DashBoardScreen({super.key});

  @override
  ConsumerState<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    PricingPlansScreen(isNotShowAction: true),
    TransactionHistoryScreen(),
    SettingsScreenWidget(),
  ];

  final List _screensData = [
    Assets.icons.qr,
    Assets.icons.card,
    Assets.icons.history,
    Assets.icons.settings
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavigationIndexProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        unselectedItemColor: context.theme.hintColor,
        selectedItemColor: context.theme.primaryColor,
        items: _screens
            .mapIndexed(
              (index, e) => BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _screensData.elementAt(index),

                  // TODO learn about the alternative to color property and fix the deprecation
                  color: currentIndex == index
                      ? context.theme.primaryColor
                      : context.theme.hintColor,
                ),
                label: '',
              ),
            )
            .toList(),
        onTap: _onBottomAppBarPressed,
      ),
    );
  }

  void _onBottomAppBarPressed(int index) {
    if (ref.read(bottomNavigationIndexProvider) == index) return;

    ref.read(bottomNavigationIndexProvider.notifier).updateCurrentIndex(index);
  }
}
