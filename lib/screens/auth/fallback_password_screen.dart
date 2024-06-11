import '../../all_utills.dart';

class FallbackPasswordScreen extends StatefulWidget {
  static const String routeName = '/PasswordScreen';

  const FallbackPasswordScreen({super.key, required this.routeToNavigate});

  final String routeToNavigate;

  @override
  State<FallbackPasswordScreen> createState() => _FallbackPasswordScreenState();
}

class _FallbackPasswordScreenState extends State<FallbackPasswordScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (kDebugMode) _passwordController.text = 'Pakistan@1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showLeading: context.router.canPop(),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Gap(32.h),
              Text(
                'Welcome Back!',
                style: context.textTheme.headlineLarge,
              ),
              Gap(16.h),
              SomosCaptionTextField(
                obscureText: true,
                autoValidateMode: AutovalidateMode.disabled,
                hintText: 'Enter Password',
                title: 'Password',
                controller: _passwordController,
                validator: Validators.validatePassword,
              ),
              Gap(24.h),
              SomosElevatedButton(
                title: 'Unlock',
                onPressed: _onUnlockPressed,
              ),
              Gap(16.h),
              // TODO have it uncommented, it will be raised again as bug
              // Text(
              //   'Wallet won’t unlock? You can ERASE your current wallet and setup a new one.',
              //   style: context.textTheme.bodyLarge?.copyWith(
              //     color: context.theme.hintColor,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onUnlockPressed(BuildContext context) async {
    context.unFocus();

    if (!_formKey.currentState!.validate()) return;

    try {
      ApiRequest.token = storage.authenticationToken;

      final request = VerifyPasswordRequest(
        password: _passwordController.text.trim(),
      );

      final router = context.router;

      final response = await authRepository.verifyPassword(request);

      if (!response.status) {
        Utils.displayToast(response.message);

        return;
      }

      router.pushReplacement(widget.routeToNavigate);
    } on ApiError catch (e) {
      Utils.displayToast(e.message);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
