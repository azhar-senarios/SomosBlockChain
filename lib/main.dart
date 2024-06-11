import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:somos_app/firebase_options.dart';
import 'package:somos_app/services/remote_config.dart';

import 'all_utills.dart';
// import 'firebase_options.dart';
import 'utils/services/notification_manager.dart';

// LIST OF TODOs
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  RemoteConfigManager.instance.initialize();
  await NotificationManager.instance.requestNotificationsPermission();
  NotificationManager.instance.firebaseInit();
  NotificationManager.instance.configureNotifications();
  NotificationManager.instance.setupInteractMessage();
  // NotificationManager.instance.getDeviceToken();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackground);
  await ScreenUtil.ensureScreenSize();
  await PaymentController.initialize();
  await DependencyInjectionEnvironment.setup();

  if (!kDebugMode) ErrorWidget.builder = (_) => GeneralErrorScreen(error: _);

  runApp(const ProviderScope(child: SomosApp()));
}

class SomosApp extends StatelessWidget {
  const SomosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      builder: (_, __) => MaterialApp.router(
        title: 'Somos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(context),
        routerConfig: router,
      ),
    );
  }
}

class GeneralErrorScreen extends StatelessWidget {
  const GeneralErrorScreen({super.key, required this.error});

  final FlutterErrorDetails error;

  @override
  Widget build(BuildContext context) {
    // TODO Handle Crashlytics Here as well
    return BaseScaffold(
      showBackButton: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Some Error Occurred',
            style: context.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          Gap(8.h),
          Text(
            'Developers have been notified about the error and we\'re currently working on it',
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class RouteNotFoundScreen extends StatelessWidget {
  const RouteNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackButton: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Some Error Occurred',
            style: context.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          Gap(8.h),
          Text(
            'Developers have been notified about the error and we\'re currently working on it',
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackground(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final title = message.notification?.title.toString();
  print('background Firebase Messaging title $title');
}
