import 'dart:ui';

import '../../all_utills.dart';
import '../../models/requests/reveal_password_phrase_request.dart';
import '../../models/requests/reveal_secret_key_request.dart';

class RevealRecoveryPhraseScreen extends StatefulWidget {
  static const String routeName = '/RevealRecoveryPhraseScreen';

  const RevealRecoveryPhraseScreen({super.key, this.shouldRevealKey = false});

  final bool shouldRevealKey;

  @override
  State<RevealRecoveryPhraseScreen> createState() =>
      _RevealRecoveryPhraseScreenState();
}

class _RevealRecoveryPhraseScreenState
    extends State<RevealRecoveryPhraseScreen> {
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (kDebugMode) {
      _passwordController.text = 'Pakistan@1';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: '',
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(32.h),
              Text(
                widget.shouldRevealKey
                    ? 'Reveal Secret Key'
                    : 'Reveal Recovery Phrase',
                style: context.textTheme.headlineLarge,
              ),
              Gap(12.h),
              Text(
                widget.shouldRevealKey
                    ? 'Never disclose this key. Anyone with your privacy key can fully control your account, including transferring away any of your funds.'
                    : 'The Secret Recovery Phrase provides full access to your wallet and funds and accounts.',
                style:
                    context.textTheme.bodyLarge?.copyWith(letterSpacing: 0.5),
              ),
              Gap(16.h),
              SomosCaptionTextField(
                obscureText: true,
                hintText: 'Enter Password',
                title: 'Enter wallet password',
                controller: _passwordController,
                validator: Validators.validatePassword,
              ),
              Gap(32.h),
              SomosElevatedButton(
                title: AppTexts.continueText,
                onPressed: _onContinuePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onContinuePressed(BuildContext context) async {
    context.unFocus();

    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text;

    ApiRequest request = RevealPasswordPhraseRequest(password: password);

    if (widget.shouldRevealKey) {
      request = RevealSecretKeyRequest(password: password);
    }

    ApiResponse response;

    try {
      if (widget.shouldRevealKey) {
        response = await homeRepository.revealSecretKey(request);
      } else {
        response = await homeRepository.revealPasswordPhrase(request);
      }

      if (!response.status) {
        Utils.displayToast(response.message);

        return;
      }

      _showDialogue(response.body!);
    } on ApiError catch (e) {
      Utils.displayToast(e.message);
    }
  }

  void _showDialogue(String phraseORKey) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
          child: AlertDialog(
            title: Text(
              widget.shouldRevealKey
                  ? 'Your Secret Key'
                  : 'Your Recovery Phrase',
            ),
            content: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: AppWidgets.borderRadius,
                border: Border.all(color: context.theme.hintColor),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    phraseORKey,
                    style: context.textTheme.bodyLarge,
                  ),
                  AppWidgets.halfVerticalGap,
                  OutlinedButton.icon(
                    onPressed: () => _onCopyPressed(phraseORKey),
                    icon: SvgPicture.asset(Assets.icons.copy),
                    label: Text(
                      AppTexts.copy,
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onCopyPressed(String passwordPhrase) async {
    final router = context.router;

    await Clipboard.setData(ClipboardData(text: passwordPhrase));

    router.pop();

    Utils.displayToast('Copied to Clipboard...');
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
