import 'dart:ui';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:somos_app/all_utills.dart';

void showTermDialogWidget(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
          child: const TermsConditionDialogDataWidget());
    },
  );
}

final isTermsProvider = StateProvider<bool>((ref) => false);

class TermsConditionDialogDataWidget extends ConsumerStatefulWidget {
  const TermsConditionDialogDataWidget({super.key});

  @override
  ConsumerState<TermsConditionDialogDataWidget> createState() =>
      _TermWebViewState();
}

class _TermWebViewState extends ConsumerState<TermsConditionDialogDataWidget> {
  bool _isLoading = true;
  bool _loadError = false; // Added to handle when there is a loading error

  @override
  Widget build(BuildContext context) {
    final isTerms = ref.watch(isTermsProvider);

    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SomosContainer(
          color: const Color(0xffF3F3F3).withOpacity(0.5),
          borderRadius: AppWidgets.borderRadius,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Review our latest Terms of Use',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w900, letterSpacing: 0.5)),
              const VerticalSpacing(),
              Text('Terms of Use',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: AppColors.textColor, fontSize: 30.sp)),
              const VerticalSpacing(),
              SizedBox(
                height: 0.45.sh,
                child: Stack(
                  children: [
                    InAppWebView(
                      initialUrlRequest: URLRequest(
                          url: WebUri(
                              'https://somos-web.netlify.app/terms-and-conditions')),
                      onLoadStop: (controller, url) {
                        setState(() {
                          _isLoading = false;
                          _loadError = false; // Reset error on successful load
                        });
                      },
                      onWebViewCreated: (InAppWebViewController controller) {
                        print('WebView created!');
                      },
                      onLoadStart:
                          (InAppWebViewController controller, Uri? url) {
                        print('Loading started for $url');
                      },
                      initialSettings: InAppWebViewSettings(
                        transparentBackground: true,
                        javaScriptEnabled: true,
                      ),
                      onReceivedError: (controller, url, code) {
                        setState(() {
                          _isLoading = false;
                          _loadError = true; // Display an error message
                        });
                      },
                      onReceivedHttpError: (controller, request, response) {
                        setState(() {
                          _isLoading = false;
                          _loadError = true; // Handle HTTP errors
                        });
                      },
                    ),
                    if (_isLoading)
                      SomosContainer(child: Utils.buildLoadingHandlerWidget()),
                    if (_loadError)
                      SomosContainer(
                        alignment: Alignment.center,
                        child: Text(
                          'Failed to load terms and conditions. Please try again later.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                  ],
                ),
              ),
              const VerticalSpacing(of: 10),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                visualDensity: const VisualDensity(horizontal: -4),
                contentPadding: EdgeInsets.zero,
                fillColor: WidgetStateProperty.all(
                  isTerms ? context.theme.primaryColor : AppColors.textColor,
                ),
                value: isTerms,
                title: Text(
                  'I agree to the Terms of Use, which apply to my use of Somos and all of its features',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                onChanged: (bool? value) {
                  _isLoading == false
                      ? ref.read(isTermsProvider.notifier).state =
                          value ?? false
                      : false;
                },
              ),
              const VerticalSpacing(),
              SomosElevatedButton(
                  title: 'Agree',
                  onPressed:
                      !isTerms ? null : (ctx) => _pressedAgree(context, ref),
                  backgroundColor: !isTerms ? AppColors.textColor : null)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pressedAgree(BuildContext context, WidgetRef ref) async {
    storage.setTermConditionRead(true);
    context.pop();
  }
}
