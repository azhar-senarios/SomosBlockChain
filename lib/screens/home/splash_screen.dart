import '../../all_screen.dart';
import '../../all_utills.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String routeName = '/';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static bool hasInitialised = false;

  @override
  void initState() {
    // don't remove it from here, it should get pre-loaded before the screens require it
    ref.read(bioMetricStateProvider);
    // Future.delayed(Duration.zero, () => ref.watch(bioMetricStateProvider));

    Future.delayed(const Duration(seconds: 2), _authenticate);

    super.initState();
  }

  Future<void> _authenticate() async {
    if (hasInitialised) return;

    hasInitialised = true;

    final router = context.router;

    final localAuth = LocalAuthentication();

    final isBiometricsAvailable = await localAuth.isDeviceSupported();

    String route = LandingPageScreen.routeName;
    bool didAuthenticate = true;

    if (storage.authenticationToken == null || storage.walletCreated == false) {
      route = LandingPageScreen.routeName;
    } else if (storage.isBiometric == false || !isBiometricsAvailable) {
      route = DashBoardScreen.routeName;
    } else if (storage.isBiometric) {
      didAuthenticate = false;

      try {
        didAuthenticate = await Utils.verifyBioMetricAuthOrFallBack(
          context,
          DashBoardScreen.routeName,
          shouldReplace: true,
        );
      } catch (e, stackTrace) {
        log(
          e.toString(),
          name: 'Local Bio-Metric Authentication',
          time: DateTime.now(),
          stackTrace: stackTrace,
        );
        context.go(FallbackPasswordScreen.routeName);
        return;
      }

      route = didAuthenticate && storage.walletCreated
          ? DashBoardScreen.routeName
          : FallbackPasswordScreen.routeName;
    }

    if (didAuthenticate) router.go(route, extra: route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImageWidget(
        child: Center(
            child: Image.asset(Assets.images.somosHomeLogo.path, width: 176.w)),
      ),
    );
  }
}
