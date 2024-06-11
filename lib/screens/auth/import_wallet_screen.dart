import 'package:somos_app/services/remote_config.dart';
import 'package:somos_app/utils/constants/terms_condition.dart';

import '../../all_utills.dart';
import '../../utils/services/notification_manager.dart';

class ImportWalletScreen extends ConsumerStatefulWidget {
  static const String routeName = '/ImportWalletScreen';

  const ImportWalletScreen({super.key});

  @override
  ConsumerState<ImportWalletScreen> createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends ConsumerState<ImportWalletScreen> {
  final _recoverPhaseController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool isBiometric = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (kDebugMode || RemoteConfigManager.instance.isDev) {
      _newPasswordController.text = 'Pakistan@1';
      _confirmNewPasswordController.text = 'Pakistan@1';
      _recoverPhaseController.text =
          'parrot equal raw message sound abuse stomach hair romance culture favorite image';
    }
    if (!storage.isTermRead)
      Future.delayed(Duration.zero, () {
        showTermDialogWidget(context);
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(51.h),
              Text(
                AppTexts.importRecoveryPhrase,
                style: context.textTheme.headlineLarge,
              ),
              Gap(12.h),
              Text(
                AppTexts.enterRecoveryPhraseText,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.theme.hintColor,
                  fontSize: 18.sp,
                ),
              ),
              Gap(24.h),
              SomosCaptionTextField(
                maxLines: 3,
                title: AppTexts.importRecoveryPhrase,
                hintText: AppTexts.yourRecoveryPhrase,
                controller: _recoverPhaseController,
                validator: Validators.validatePhrase,
              ),
              Gap(16.h),
              SomosCaptionTextField(
                obscureText: true,
                title: AppTexts.newPassword,
                hintText: AppTexts.newPassword,
                controller: _newPasswordController,
                validator: Validators.validatePassword,
              ),
              Gap(16.h),
              SomosCaptionTextField(
                title: AppTexts.confirmNewPassword,
                hintText: AppTexts.confirmNewPassword,
                controller: _confirmNewPasswordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) => Validators.validateConfirmPassword(
                    _newPasswordController.text, value),
              ),
              Gap(20.h),
              const EnableBioMetricAuthenticationWidget(),
              Gap(32.h),
              SomosElevatedButton(
                title: AppTexts.importWallet,
                bottomMargin: true,
                onPressed: _onImportWalletPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onImportWalletPressed(BuildContext context) async {
    context.unFocus();

    final router = context.router;

    if (!_formKey.currentState!.validate()) return;

    final recoveryPhrase = _recoverPhaseController.text.trim();
    final newPassword = _newPasswordController.text;

    try {
      final request = ImportWalletRequest(
        password: newPassword,
        phrase: recoveryPhrase,
      );

      final response = await authRepository.importWallet(request);

      Utils.displayToast(response.message);

      if (!response.status) return;

      await storage.setWallet(true);

      if (response.body == null)
        return Utils.displayToast('Failed to import Wallet');
      await storage.setUserAuthToken(response.body);
      await LocalAuthentication().stopAuthentication();
      final notificationToken =
          await NotificationManager.instance.getDeviceToken();
      if (notificationToken != null) {
        await updateFCMToken(notificationToken);
      }
      router.go(WalletCreatedScreen.routeName, extra: true);
    } on ApiError catch (e) {
      Utils.displayToast(e.message);
    }
  }

  @override
  void dispose() {
    _recoverPhaseController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
