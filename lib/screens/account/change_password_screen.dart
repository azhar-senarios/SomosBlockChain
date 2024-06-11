import '../../all_screen.dart';
import '../../all_utills.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/ChangePasswordScreen';

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (kDebugMode) {
      _currentPasswordController.text = 'Pakistan@1';
      _newPasswordController.text = 'Pakistan@1';
      _confirmNewPasswordController.text = 'Pakistan@1';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: 'Change password',
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(32.h),
              SomosCaptionTextField(
                obscureText: true,
                title: 'Current Password',
                hintText: '152@@##PAss',
                controller: _currentPasswordController,
                validator: Validators.validatePassword,
              ),
              Gap(16.h),
              SomosCaptionTextField(
                obscureText: true,
                title: 'New Password',
                hintText: '•••••••••••',
                controller: _newPasswordController,
                validator: Validators.validateNewPassword,
              ),
              Gap(16.h),
              SomosCaptionTextField(
                obscureText: true,
                title: 'Confirm Password',
                hintText: '•••••••••••',
                controller: _confirmNewPasswordController,
                textInputAction: TextInputAction.done,
                validator: (value) => Validators.validateConfirmPassword(
                  _newPasswordController.text,
                  value,
                ),
              ),
              Gap(32.h),
              SomosElevatedButton(
                title: 'Change Password',
                onPressed: _onChangePasswordPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onChangePasswordPressed(BuildContext context) async {
    context.unFocus();

    if (!_formKey.currentState!.validate()) return;

    final router = context.router;

    // no need to trim these as user may or may not enter space at the end
    final newPassword = _newPasswordController.text;
    final currentPassword = _currentPasswordController.text;

    final request = ResetPasswordRequest(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    try {
      final response = await authRepository.resetPassword(request);

      Utils.displayToast(response.message);

      if (response.status) router.pop();
    } catch (e) {
      Utils.displayToast((e as ApiError).message);
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
