import '../../all_screen.dart';
import '../../all_utills.dart';

class CreateWalletScreen extends StatefulWidget {
  static const String routeName = '/CreateWalletScreen';

  const CreateWalletScreen({super.key, required this.recoveryPhrase});

  final String recoveryPhrase;

  @override
  State<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  late final List<String> _words;

  @override
  void initState() {
    // TODO device a way to make sure it has 12 words in it
    _words = widget.recoveryPhrase.split(' ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(30.h),
          Text(AppTexts.yourRecoveryPhrase,
              style: context.textTheme.headlineLarge),
          Gap(12.h),
          Text(
            AppTexts.writeDownOrCopyTheseWords,
            style: context.textTheme.bodyMedium,
          ),
          Gap(24.h),
          SomosContainer(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 22.h,
            ),
            border: Border.all(color: context.theme.hintColor),
            borderRadius: AppWidgets.borderRadius,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _VerticalPhraseListBuilder(
                  allWords: _words,
                ),
                Gap(60.w),
                _VerticalPhraseListBuilder(
                  allWords: _words,
                  startingIndex: _words.length ~/ 2,
                ),
              ],
            ),
          ),
          Gap(24.h),
          Align(
            alignment: Alignment.center,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: context.theme.hintColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppWidgets.borderRadiusValue * 3,
                    ),
                  )),
              onPressed: _onCopyPressed,
              icon: Icon(Icons.copy, color: context.theme.hintColor),
              label: Text(
                AppTexts.copy,
                style: context.textTheme.bodyLarge,
              ),
            ),
          ),
          Gap(30.h),
          SomosElevatedButton(
            title: AppTexts.continueText,
            bottomMargin: true,
            onPressed: _onContinuePressed,
          ),
        ],
      ),
    );
  }

  void _onCopyPressed() async {
    await Clipboard.setData(ClipboardData(text: _words.join(' ').toString()));

    Utils.displayToast('Text Copied to clipboard');
  }

  Future<void> _onContinuePressed(BuildContext context) async => context.push(
        SelectRecoveryPhraseScreen.routeName,
        extra: _words,
      );
}

class _VerticalPhraseListBuilder extends StatelessWidget {
  const _VerticalPhraseListBuilder({
    this.startingIndex = 0,
    required this.allWords,
  });

  final int startingIndex;
  final List<String> allWords;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.zero,
        itemCount: allWords.length ~/ 2.0,
        separatorBuilder: (_, __) => Gap(12.h),
        itemBuilder: (_, index) {
          index = index + startingIndex;

          return SomosContainer(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              vertical: 4.h,
            ),
            borderRadius: BorderRadius.circular(25),
            border: const GradientBoxBorder(
              gradient: AppColors.buttonGradient,
            ),
            child: Text(
              '${index + 1}. ${allWords.elementAt(index)}',
              style: context.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }
}
