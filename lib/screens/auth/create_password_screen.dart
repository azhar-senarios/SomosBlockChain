import 'package:somos_app/services/remote_config.dart';
import 'package:somos_app/utils/constants/terms_condition.dart';

import '../../all_screen.dart';
import '../../all_utills.dart';

class CreatePasswordScreen extends ConsumerStatefulWidget {
  static const String routeName = '/CreatePasswordScreen';

  const CreatePasswordScreen({super.key});

  @override
  ConsumerState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _hasAcceptedTermsAndConditions = true;

  bool isBiometricEnable = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (kDebugMode || RemoteConfigManager.instance.isDev) {
      _passwordController.text = 'Pakistan@1';
      _confirmNewPasswordController.text = 'Pakistan@1';
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(51.h),
              Text(
                AppTexts.createPassword,
                style: context.textTheme.headlineLarge,
              ),
              Gap(12.h),
              Text(
                AppTexts.passwordWillUnlock,
                style: context.textTheme.headlineSmall,
              ),
              Gap(25.h),
              SomosCaptionTextField(
                obscureText: true,
                title: AppTexts.newPassword,
                hintText: AppTexts.password,
                controller: _passwordController,
                validator: Validators.validateNewPassword,
              ),
              Gap(16.h),
              SomosCaptionTextField(
                obscureText: true,
                title: AppTexts.confirmNewPassword,
                hintText: AppTexts.confirmNewPassword,
                controller: _confirmNewPasswordController,
                validator: (value) => Validators.validateConfirmPassword(
                  _passwordController.text,
                  value,
                ),
                textInputAction: TextInputAction.done,
              ),
              Gap(20.h),
              const EnableBioMetricAuthenticationWidget(),
              CheckboxListTile(
                fillColor: MaterialStatePropertyAll(
                  _hasAcceptedTermsAndConditions
                      ? context.theme.primaryColor
                      : AppColors.textColor,
                ),
                value: _hasAcceptedTermsAndConditions,
                onChanged: (value) => setState(
                  () => _hasAcceptedTermsAndConditions = value ?? true,
                ),
                // TODO learn and research about this problem
                title: Semantics(
                  excludeSemantics: true,
                  child: RichText(
                    text: TextSpan(
                      text: AppTexts.cannotRecoverPassword,
                      style: context.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Learn More',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = dummyPendingOnPressed,
                        ),
                      ],
                    ),
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              Gap(32.h),
              SomosElevatedButton(
                bottomMargin: true,
                title: AppTexts.continueText,
                onPressed: _onContinuePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onContinuePassword(BuildContext context) async {
    context.unFocus();

    final router = context.router;

    if (!_formKey.currentState!.validate()) return;

    if (!_hasAcceptedTermsAndConditions) {
      Utils.displayToast('Please accept terms and conditions as well.');

      return;
    }

    try {
      final password = _passwordController.text;

      final request = CreatePasswordRequest(password: password);

      final response = await authRepository.createPassword(request);

      Utils.displayToast(response.message);

      if (!response.status) return;

      final data = response.body as CreatePasswordModel;

      ApiRequest.token = data.authToken;

      await storage.setUserAuthToken(data.authToken);

      router.push(
        CreateWalletScreen.routeName,
        extra: data.recoveryPhrase,
      );
    } on ApiError catch (e) {
      Utils.displayToast(e.message);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
