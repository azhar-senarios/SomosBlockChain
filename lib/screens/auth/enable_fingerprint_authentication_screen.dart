import '../../all_screen.dart';
import '../../all_utills.dart';

class EnableFingerPrintAuthenticationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/EnableFingerPrintAuthenticationScreen';

  const EnableFingerPrintAuthenticationScreen({super.key});

  @override
  ConsumerState<EnableFingerPrintAuthenticationScreen> createState() =>
      _EnableFingerPrintAuthenticationScreenState();
}

class _EnableFingerPrintAuthenticationScreenState
    extends ConsumerState<EnableFingerPrintAuthenticationScreen> {
  final localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        showLeading: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.fingerPrint,
              height: 96.h,
            ),
            Gap(39.h),
            Text(
              AppTexts.loginWithFingerPrint,
              style: context.textTheme.headlineLarge?.copyWith(fontSize: 24.sp),
            ),
            Gap(16.h),
            Text(
              AppTexts.loginWithFingerprintDescription,
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Gap(32.h),
            SomosElevatedButton(
              title: AppTexts.enableNow,
              onPressed: _onEnableNowPressed,
            ),
            MayLaterWidget(
              onPressed: _onMayBeLaterPressed,
            ),
          ],
        ));
  }

  Future<void> _onMayBeLaterPressed(BuildContext context) async {
    final isPurchase =
        (await ref.read(tierStateProvider.future)).purchased == true;
    ref
        .read(bioMetricStateProvider.notifier)
        .toggleBioMetricAuthentication(false, isStoreLocalStorage: true);
    if (!storage.planScreenRead && !isPurchase) {
      context.push(PricingPlansScreen.routeName);
      return;
    }
    context.go(DashBoardScreen.routeName);
  }

  Future<void> _onEnableNowPressed(BuildContext context) async {
    // TODO check for all the supported methods when the code is pushed to state
    final bioMetricStateNotifier = ref.read(bioMetricStateProvider.notifier);
    final isPurchase =
        (await ref.read(tierStateProvider.future)).purchased == true;
    try {
      context.unFocus();

      final router = context.router;

      final localAuth = LocalAuthentication();

      final hasAuthenticated = await localAuth.authenticate(
        localizedReason: 'Please scan your fingerprint to unlock',
      );

      // TODO ask backend guy if app needs to tell backend if the user has successfully authenticated using fingerpint
      if (!hasAuthenticated) {
        Utils.displayToast('Could not verify your fingerprint');

        return;
      }

      bioMetricStateNotifier.toggleBioMetricAuthentication(true,
          isStoreLocalStorage: true);
      if (!storage.planScreenRead && !isPurchase) {
        router.go(PricingPlansScreen.routeName);
      } else {
        router.go(DashBoardScreen.routeName);
      }
    } catch (e) {
      bioMetricStateNotifier.toggleBioMetricAuthentication(false,
          isStoreLocalStorage: false);

      Utils.displayToast(e.toString());
    }
  }
}

class ShaderText extends StatelessWidget {
  final Gradient gradient;
  final Widget? child;

  const ShaderText({
    super.key,
    required this.gradient,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => gradient.createShader(bounds),
      child: child,
    );
  }
}

class MayLaterWidget extends StatelessWidget {
  final FutureBuildContextCallback onPressed;
  const MayLaterWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(context),
      child: ShaderText(
        gradient: AppColors.buttonGradient,
        child: Text(AppTexts.maybeLater,
            style: context.textTheme.bodyLarge
                ?.copyWith(color: AppColors.primaryColor)),
      ),
    );
  }
}
