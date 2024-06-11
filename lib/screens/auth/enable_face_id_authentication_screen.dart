import '../../all_screen.dart';
import '../../all_utills.dart';

class EnableFaceIDAuthenticationScreen extends ConsumerWidget {
  static const String routeName = '/EnableFaceIDAuthenticationScreen';

  const EnableFaceIDAuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
        showLeading: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.faceId,
              height: 96.h,
            ),
            Gap(39.h),
            Text(AppTexts.loginWithFaceID,
                style:
                    context.textTheme.headlineLarge?.copyWith(fontSize: 24.sp)),
            Gap(16.h),
            Text(
              AppTexts.loginWithFaceIDDescription,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(32.h),
            SomosElevatedButton(
              title: AppTexts.enableNow,
              onPressed: (context) => _onEnableNowPressed(context, ref),
            ),
            MayLaterWidget(
                onPressed: (context) => _onMayBeLaterPressed(context, ref))
          ],
        ));
  }

  Future<void> _onMayBeLaterPressed(BuildContext context, WidgetRef ref) async {
    context.unFocus();
    ref
        .read(bioMetricStateProvider.notifier)
        .toggleBioMetricAuthentication(false, isStoreLocalStorage: false);
    final isPurchase =
        (await ref.read(tierStateProvider.future)).purchased == true;
    if (!storage.planScreenRead && !isPurchase) {
      context.go(PricingPlansScreen.routeName);
      return;
    }
    context.go(DashBoardScreen.routeName);
  }

  Future<void> _onEnableNowPressed(BuildContext context, WidgetRef ref) async {
    context.unFocus();
    final isPurchase =
        (await ref.read(tierStateProvider.future)).purchased == true;
    final router = context.router;

    final localAuth = LocalAuthentication();
    final bioMetricStateNotifier = ref.read(bioMetricStateProvider.notifier);
    try {
      final hasAuthenticated = await localAuth.authenticate(
          localizedReason: 'Login with FaceID',
          options: const AuthenticationOptions(
              stickyAuth: true, useErrorDialogs: false));
      if (!hasAuthenticated) {
        Utils.displayToast('Could not verify your Face ID');
        return;
      }
      bioMetricStateNotifier.toggleBioMetricAuthentication(
        true,
        isStoreLocalStorage: true,
      );
    } catch (e) {
      bioMetricStateNotifier.toggleBioMetricAuthentication(
        false,
        isStoreLocalStorage: false,
      );
      print(e.toString());
    }
    if (!storage.planScreenRead && !isPurchase) {
      router.go(PricingPlansScreen.routeName);
      return;
    }
    router.go(DashBoardScreen.routeName);
  }
}
