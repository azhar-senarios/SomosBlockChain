import '../../all_screen.dart';
import '../../all_utills.dart';

class WalletCreatedScreen extends ConsumerWidget {
  final bool isImport;
  static const String routeName = '/WalletCreatedScreen';

  const WalletCreatedScreen({super.key, this.isImport = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(tierStateProvider);

    return BaseScaffold(
      showLeading: false,
      child: Column(
        children: [
          Gap(40.h),
          Image.asset(Assets.images.walletCreated.path, scale: 2.2),
          Gap(40.h),
          Text(
            AppTexts.congratulation,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.headlineLarge,
          ),
          Gap(12.h),
          Text(
            isImport
                ? AppTexts.walletImportedSuccessfullyText
                : AppTexts.walletCreatedSuccessfullyText,
            maxLines: 5,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.headlineSmall,
          ),
          const Spacer(),
          SomosElevatedButton(
            title: AppTexts.done,
            bottomMargin: true,
            onPressed: (_) => _onDonePressed(context, ref),
          )
        ],
      ),
    );
  }

  // TODO convert this code to state for further code re-use
  Future<void> _onDonePressed(BuildContext context, WidgetRef ref) async {
    context.unFocus();
    final isPurchase =
        (await ref.read(tierStateProvider.future)).purchased == true;
    ref.invalidate(bottomNavigationIndexProvider);
    String routeName = DashBoardScreen.routeName;

    final router = context.router;

    if (ref.read(bioMetricStateProvider).value?.isDeviceSupported == false) {
      if (!storage.planScreenRead && !isPurchase)
        return router.go(PricingPlansScreen.routeName);
      router.go(routeName);
      return;
    }
    final biometricEnabled =
        ref.read(bioMetricStateProvider).value?.isBiometricEnabled;
    if (biometricEnabled == true) {
      final localAuth = LocalAuthentication();

      final deviceSupportsBiometricAuth =
          ref.read(bioMetricStateProvider).value?.isDeviceSupported ?? false;

      final supportedAuths = await localAuth.getAvailableBiometrics();

      if (!deviceSupportsBiometricAuth || supportedAuths.isEmpty) {
        if (biometricEnabled == true) {
          ref
              .read(bioMetricStateProvider.notifier)
              .toggleBioMetricAuthentication(true, isStoreLocalStorage: true);
        }
        if (!storage.planScreenRead && !isPurchase) {
          return router.go(PricingPlansScreen.routeName);
        } else {
          router.go(DashBoardScreen.routeName);
          return;
        }
      }

      if (supportedAuths.contains(BiometricType.weak) ||
          supportedAuths.contains(BiometricType.strong)) {
        routeName = EnableFingerPrintAuthenticationScreen.routeName;
      } else if (supportedAuths.contains(BiometricType.face)) {
        routeName = EnableFaceIDAuthenticationScreen.routeName;
      }
    }
    if (routeName == DashBoardScreen.routeName && biometricEnabled == true) {
      ref
          .read(bioMetricStateProvider.notifier)
          .toggleBioMetricAuthentication(true, isStoreLocalStorage: true);
    }
    router.go(routeName);
  }
}
