import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../all_utills.dart';
import '../models/requests/update_fcm_token_request.dart';
import '../screens/auth/fallback_password_screen.dart';

class Utils {
  const Utils._();

  static void displayToast(String? message) {
    if (message == null) return;

    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black54,
    );
  }

  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static void openEmail(String email, {String? subject, String? body}) async {
    final url = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{
        'subject': subject.toString(),
        'body': body.toString(),
      }),
    );

    Utils.openUrl(url);
  }

  static void openPhone(int phone) async {
    final url = Uri(scheme: 'tel', path: '+$phone');

    Utils.openUrl(url);
  }

  static void openUrl(Uri url) async {
    // there's a reason I haven't checked for url before opening it up
    // a url provided to the app should already have the built in support
    // which canLaunchUrl does not cater to, better avoid using that method

    launchUrl(url);
  }

  // generate random date within last 30 days
  static DateTime generateRandomDate() {
    final random = Random();

    int range = 30;
    int randomDays = random.nextInt(range + 1);

    DateTime today = DateTime.now();

    return today.subtract(Duration(days: randomDays));
  }

  static Future<bool> verifyBioMetricAuthOrFallBack(
    BuildContext context,
    String routeToNavigate, {
    bool shouldReplace = false,
  }) async {
    final router = context.router;

    final hasAuthenticated = await Utils.verifyBioMetricAuthentication();

    // TODO Add Toast Functionality here if the QA raises bug
    if (hasAuthenticated) return true;

    if (shouldReplace) {
      router.go(
        FallbackPasswordScreen.routeName,
        extra: routeToNavigate,
      );
    } else {
      router.push(
        FallbackPasswordScreen.routeName,
        extra: routeToNavigate,
      );
    }

    return false;
  }

  // check if the user has enabled bio metrics first
  // if not, return true
  // check for device support as well, if not return true
  // check if it's an android device. if it's an android
  // device, check for fingerprint only as most of the phones
  // support it only, and return the result, this will work for ios
  // devices having fingerprint work as well, at the end
  // check for face id, if it's enabled and supports as well
  // authenticate and return the state
  static Future<bool> verifyBioMetricAuthentication() async {
    // TODO make this one listen to it's provider as well after provider optimizations
    try {
      final localAuth = LocalAuthentication();

      final isBiometricsAvailable = await localAuth.isDeviceSupported();

      if (!isBiometricsAvailable) return false;

      bool hasAuthenticated = await localAuth.authenticate(
        localizedReason: 'Please authenticate to login to Somos',
      );

      return hasAuthenticated;
    } catch (e) {
      return false;
    }
  }

  static Widget buildErrorHandlerWidget(Object error, StackTrace stackTrace) {
    error = error as ApiError;

    return ErrorHandlerScreenWidget(
      error: error,
      stackTrace: stackTrace,
    );
  }

  static Widget buildLoadingHandlerWidget() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

class ErrorHandlerScreenWidget extends StatelessWidget {
  const ErrorHandlerScreenWidget({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  final ApiError error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    // TODO Decide if this widget should send error through crashlytics or the repository layer

    return Center(
      child: Text(
        error.message,
        style: context.textTheme.bodyLarge?.copyWith(
          color: context.colorScheme.error,
        ),
      ),
    );
  }
}

class SomosAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLeading;
  final bool? automaticallyImplyLeading;
  final double? leadingWidth;
  final Widget? titleWidget;
  final double? appBarHeight;
  final Widget? leadingWidget;
  final String? title;
  final List<Widget> action;

  const SomosAppBar({
    super.key,
    this.showLeading = true,
    this.leadingWidth,
    this.automaticallyImplyLeading,
    this.title,
    this.titleWidget,
    this.action = const [],
    this.leadingWidget,
    this.appBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      leading: leadingWidget ??
          (showLeading
              ? IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.backButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _pressedBack(context),
                  icon: SvgPicture.asset(Assets.icons.arrowBack),
                )
              : null),
      leadingWidth: leadingWidth ?? 70.w,
      centerTitle: true,
      actions: action,
      title: Padding(
        padding: EdgeInsets.only(top: 3.h),
        child: titleWidget ??
            (title == null
                ? SvgPicture.asset(Assets.icons.logo)
                : Text(
                    title ?? 'Dummy',
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp,
                    ),
                  )),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? 56.h);

  void _pressedBack(BuildContext context) {
    context.unFocus();
    context.pop();
  }
}

Future<void> updateFCMToken(String token) async {
  try {
    await homeRepository.updateFCMToken(UpdateFCMTokenRequest(token: token));
  } catch (e) {
    Utils.displayToast(e.toString());
  }
}
