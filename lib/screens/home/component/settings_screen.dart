import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:somos_app/services/remote_config.dart';

import '../../../all_screen.dart';
import '../../../all_utills.dart';
import '../../../utils/constants/terms_condition.dart';

class SettingsScreenWidget extends ConsumerWidget {
  const SettingsScreenWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const divider = Divider();

    return BaseScaffold(
      showLeading: false,
      appBarTitle: AppTexts.setting,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Gap(16.h),
            SettingsTileWidget(
              title: AppTexts.changePassword,
              subTitle: AppTexts.changePasswordText,
              imagePath: Assets.icons.changePass,
              onTap: () => _onChangePasswordPressed(context),
            ),
            divider,
            SettingsTileWidget(
              title: AppTexts.revealRecoveryPhrase,
              subTitle: AppTexts.revealRecoveryPhraseText,
              imagePath: Assets.icons.revealRecoveryPhrase,
              onTap: () => _onRevealRecoveryPhrasePressed(context),
            ),
            divider,
            SettingsTileWidget(
              title: AppTexts.revealSecretKey,
              subTitle: AppTexts.revealSecretKeyText,
              imagePath: Assets.icons.secretKey,
              onTap: () => _onRevealSecretKeyPressed(context),
            ),
            kDebugMode || RemoteConfigManager.instance.isDev
                ? divider
                : const SizedBox(),
            kDebugMode || RemoteConfigManager.instance.isDev
                ? SettingsTileWidget(
                    title: AppTexts.deleteWallet,
                    imagePath: Assets.icons.delete,
                    onTap: () => _onDeleteWalletPressed(context),
                  )
                : const SizedBox(),
            kDebugMode ? divider : const SizedBox(),
            kDebugMode || RemoteConfigManager.instance.isDev
                ? SettingsTileWidget(
                    title: 'Log out',
                    imagePath: Assets.icons.delete,
                    onTap: () => _onLogoutPressed(context, ref),
                  )
                : const SizedBox(),
            divider,
            const EnableBioMetricAuthenticationWidget(
              shouldAuthenticate: true,
              getValueFromLocalStorage: true,
              isStoreLocalStorage: true,
            ),
            AppWidgets.verticalGap,
          ],
        ),
      ),
    );
  }

  void _onChangePasswordPressed(BuildContext context) =>
      _performActionAroundBioMetricAuthentication(
        () => context.router.push(ChangePasswordScreen.routeName),
        context,
        ChangePasswordScreen.routeName,
      );

  void _onRevealRecoveryPhrasePressed(BuildContext context) =>
      _performActionAroundBioMetricAuthentication(
        () => context.router.push(RevealRecoveryPhraseScreen.routeName),
        context,
        RevealRecoveryPhraseScreen.routeName,
      );

  void _onRevealSecretKeyPressed(BuildContext context) =>
      _performActionAroundBioMetricAuthentication(
        () => context.router.push(
          RevealRecoveryPhraseScreen.routeName,
          extra: true,
        ),
        context,
        RevealRecoveryPhraseScreen.routeName,
      );

  void _performActionAroundBioMetricAuthentication(
    VoidCallback callBack,
    BuildContext context,
    String routeToNavigate,
  ) async {
    if (storage.isBiometric) {
      final hasAuthenticated =
          await Utils.verifyBioMetricAuthOrFallBack(context, routeToNavigate);
      if (!hasAuthenticated) return;
    }

    callBack();
  }

  void _onDeleteWalletPressed(BuildContext context) async {
    try {
      final token = await homeRepository.fetchBrainTreeToken();
      if (!token.status) return Utils.displayToast(token.message);
      print(token.body['clientToken']);

      final request = BraintreeDropInRequest(
        clientToken: token.body['clientToken'],
        collectDeviceData: true,
        googlePaymentRequest: BraintreeGooglePaymentRequest(
          totalPrice: '4.20',
          currencyCode: 'USD',
          billingAddressRequired: false,
        ),
        paypalRequest: BraintreePayPalRequest(
          amount: '4.20',
          displayName: 'Example company',
        ),
      );

      BraintreeDropInResult? result = await BraintreeDropIn.start(request);

      if (result != null) {
        print('Nonce: ${result.paymentMethodNonce.nonce}');
      } else {
        print('Selection was canceled.');
      }
    } catch (e) {
      Utils.displayToast(e.toString());
    }

    // const errorColor = Colors.red;
    //
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return BackdropFilter(
    //       filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
    //       child: AlertDialog(
    //         scrollable: true,
    //         icon: Align(
    //           alignment: Alignment.centerRight,
    //           child: SvgButton(
    //             imagePath: Assets.icons.cross,
    //             onTap: () => _onCancelDeleteAccountPressed(context),
    //           ),
    //         ),
    //         title: Column(
    //           children: [
    //             Icon(Icons.warning_rounded, size: 72.h, color: errorColor),
    //             Gap(16.h),
    //             Text(
    //               AppTexts.areYouSureEraseWallet,
    //               style: context.textTheme.headlineLarge?.copyWith(
    //                 color: errorColor,
    //                 fontSize: 24.sp,
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //           ],
    //         ),
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Text(
    //               'Your current wallet, accounts and assets will be removed from this app permanently. This action cannot be undone',
    //               textAlign: TextAlign.center,
    //               style: context.textTheme.bodyLarge,
    //             ),
    //           ],
    //         ),
    //         actions: [
    //           SomosElevatedButton(
    //             title: AppTexts.understand,
    //             onPressed: _onConfirmDeleteAccountPressed,
    //             backgroundColor: errorColor,
    //           ),
    //           const VerticalSpacing(of: 16),
    //           SomosElevatedButton(
    //             title: AppTexts.cancel,
    //             onPressed: _onCancelDeleteAccountPressed,
    //             backgroundColor: Colors.transparent,
    //             borderColor: context.theme.hintColor,
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }

  void _onLogoutPressed(BuildContext context, WidgetRef ref) {
    ref.read(bioMetricStateProvider.notifier).reset();
    ref.read(isTermsProvider.notifier).state = false;
    _logout();
    context.go(LandingPageScreen.routeName);
  }

  void _logout() async {
    await storage.clearAll();
  }

  Future<void> _onConfirmDeleteAccountPressed(BuildContext context) async =>
      dummyPendingOnPressed();

  Future<void> _onCancelDeleteAccountPressed(BuildContext context) async =>
      context.pop();
}

class SettingsTileWidget extends StatelessWidget {
  const SettingsTileWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.subTitle,
  });

  final String title;
  final String? subTitle;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(imagePath),
      title: Text(title, style: context.textTheme.bodyLarge),
      subtitle: subTitle == null
          ? null
          : Text(
              subTitle ?? 'Dummy',
              style: context.textTheme.bodyMedium,
            ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: context.theme.hintColor,
        size: 20.h,
      ),
    );
  }
}
