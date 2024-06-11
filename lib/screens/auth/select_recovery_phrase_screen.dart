import 'package:somos_app/services/remote_config.dart';

import '../../all_utills.dart';
import '../../utils/services/notification_manager.dart';

final random = Random.secure();

class SelectRecoveryPhraseScreen extends StatefulWidget {
  static const String routeName = '/SelectRecoveryPhraseScreen';

  const SelectRecoveryPhraseScreen({super.key, required this.words});

  final List<String> words;

  @override
  State<SelectRecoveryPhraseScreen> createState() =>
      _SelectRecoveryPhraseScreenState();
}

class _SelectRecoveryPhraseScreenState
    extends State<SelectRecoveryPhraseScreen> {
  late final List<FocusScopeNode> _focusNodes;
  late final List<String> _selectedWords;
  late final List<bool> _selectedButtons;
  late final List<String> _shuffledWords;

  @override
  void initState() {
    _focusNodes = List.generate(widget.words.length, (_) => FocusScopeNode());
    _selectedWords = List.generate(widget.words.length, (_) => '');
    _selectedButtons = List.generate(widget.words.length, (_) => false);

    _shuffledWords = widget.words.toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
      setState(() {});
    });

    // TODO remove it before deploying to production
    // final random = Random();
    if (kDebugMode || RemoteConfigManager.instance.isDev) return;
    _shuffledWords.shuffle(random);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Gap(8.h),
          Text(
            AppTexts.selectEachWord,
            style: context.textTheme.headlineSmall,
          ),
          Gap(16.h),
          SomosContainer(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
            border: Border.all(color: context.theme.hintColor),
            borderRadius: AppWidgets.borderRadius,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: _VerticalPhraseListBuilder(
                    allWords: _shuffledWords,
                    selectedButtons: _selectedButtons,
                    selectedWords: _selectedWords,
                    focusNodes: _focusNodes,
                    setState: setState,
                  ),
                ),
                Gap(60.w),
                Expanded(
                  child: _VerticalPhraseListBuilder(
                    startingIndex: widget.words.length ~/ 2,
                    allWords: _shuffledWords,
                    selectedButtons: _selectedButtons,
                    selectedWords: _selectedWords,
                    focusNodes: _focusNodes,
                    setState: setState,
                  ),
                ),
              ],
            ),
          ),
          Gap(20.h),
          GridView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: _shuffledWords.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.w,
              crossAxisSpacing: 20.h,
              childAspectRatio: 1.sw > 600 ? 1.5 : 3 / 0.88,
            ),
            itemBuilder: (_, index) => PhraseButtonWidget(
              index: index,
              word: _shuffledWords.elementAt(index),
              focusScopes: _focusNodes,
              selectedWords: _selectedWords,
              selectedButtons: _selectedButtons,
              setState: setState,
            ),
          ),
          const Gap(20),
          SomosElevatedButton(
            title: AppTexts.createWallet,
            bottomMargin: true,
            onPressed: _onContinuePressed,
          ),
        ],
      ),
    );
  }

  Future<void> _onContinuePressed(BuildContext context) async {
    final router = context.router;

    context.unFocus();

    if (_selectedWords.length != 12 || _selectedWords.contains('')) {
      Utils.displayToast('Please fill all the blocks first');

      return;
    }

    try {
      final request = VerifyPasswordPhraseRequest(words: _selectedWords);

      final response = await authRepository.verifyPasswordPhrase(request);

      if (!response.status) {
        Utils.displayToast(response.message);
        return;
      }
      final notificationToken =
          await NotificationManager.instance.getDeviceToken();
      if (notificationToken != null) {
        updateFCMToken(notificationToken);
      }

      await storage.setWallet(true);

      router.go(WalletCreatedScreen.routeName);
    } on ApiError catch (e) {
      Utils.displayToast(e.message);
    }
  }
}

class _VerticalPhraseListBuilder extends StatelessWidget {
  const _VerticalPhraseListBuilder({
    this.startingIndex = 0,
    required this.allWords,
    required this.selectedButtons,
    required this.selectedWords,
    required this.focusNodes,
    required this.setState,
  });

  final int startingIndex;
  final List<bool> selectedButtons;
  final List<String> allWords;
  final List<String> selectedWords;
  final List<FocusScopeNode> focusNodes;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      itemCount: selectedWords.length ~/ 2.0,
      separatorBuilder: (_, __) => Gap(14.h),
      itemBuilder: (_, index) {
        index = index + startingIndex;

        return GestureDetector(
          onTap: () => _onSelectedWordPressed(context, index),
          child: FocusScope(
            autofocus: true,
            node: focusNodes.elementAt(index),
            child: Row(
              children: [
                Text(
                  '${index + 1}.  ',
                  style: context.textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: DottedBorder(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(
                      AppWidgets.borderRadiusValue,
                    ),
                    color: focusNodes.elementAt(index).hasFocus
                        ? context.theme.primaryColor
                        : context.theme.hintColor,
                    child: Center(
                      child: Text(
                        selectedWords.elementAt(index),
                        style: context.textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSelectedWordPressed(BuildContext context, int index) {
    final wordToDispose = selectedWords[index];
    final indexOfSelectedButton = allWords.indexOf(wordToDispose);

    for (final node in focusNodes) node.unfocus();

    focusNodes.elementAt(index).requestFocus();
    selectedWords[index] = '';

    if (indexOfSelectedButton != -1) {
      selectedButtons[indexOfSelectedButton] = false;
    }

    setState(() {});
  }
}

class PhraseButtonWidget extends StatefulWidget {
  const PhraseButtonWidget({
    super.key,
    required this.index,
    required this.word,
    required this.selectedWords,
    required this.focusScopes,
    required this.setState,
    required this.selectedButtons,
  });

  final int index;
  final String word;
  final List<bool> selectedButtons;
  final List<FocusScopeNode> focusScopes;
  final List<String> selectedWords;
  final void Function(void Function()) setState;

  @override
  State<PhraseButtonWidget> createState() => _PhraseButtonWidgetState();
}

class _PhraseButtonWidgetState extends State<PhraseButtonWidget> {
  late bool _isSelected;

  @override
  void initState() {
    _isSelected = widget.selectedButtons.elementAt(widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SomosContainer(
        onPressed: (_) => _onPressed(),
        color: widget.selectedButtons[widget.index]
            ? context.theme.primaryColor
            : context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppWidgets.borderRadiusValue * 3),
        border: widget.selectedButtons[widget.index]
            ? null
            : const GradientBoxBorder(gradient: AppColors.buttonGradient),
        child: Center(
          child: Text(
            widget.word,
            style: context.textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  void _onPressed() {
    setState(() => _isSelected = !_isSelected);

    final emptySlotIndex = widget.selectedWords.indexOf('');

    if (_isSelected && emptySlotIndex != -1) {
      // If the button is being selected and there is an empty slot
      widget.selectedButtons[widget.index] = true;
      _updateSelectedWords(emptySlotIndex);
    } else if (!_isSelected) {
      // If the button is being unselected
      final selectedIndex = widget.selectedWords.indexOf(widget.word);
      if (selectedIndex != -1) {
        widget.focusScopes[selectedIndex].requestFocus();
        widget.selectedWords[selectedIndex] = '';
      }
      widget.selectedButtons[widget.index] = false;
    }

    widget.setState(() {
      if (_allSelectedWordsEmpty() && emptySlotIndex == -1) {
        // If all selected words are empty and there's no empty slot, focus on the first item
        widget.focusScopes[0].requestFocus();
      }
    });
  }

  void _updateSelectedWords(int emptySlotIndex) {
    // Find the first empty slot in selectedWords
    final nextEmptySlotIndex = widget.selectedWords.indexOf('', emptySlotIndex);
    if (nextEmptySlotIndex != -1) {
      // If an empty slot is found after the current empty slot, select it
      widget.focusScopes[nextEmptySlotIndex].requestFocus();
      widget.selectedWords[nextEmptySlotIndex] = widget.word;
    } else {
      // If there are no empty slots after the current empty slot, loop back to the start
      var index = 0;
      while (index < emptySlotIndex) {
        // Find the first empty slot before the current empty slot and select it
        if (widget.selectedWords[index].isEmpty) {
          widget.focusScopes[index].requestFocus();
          widget.selectedWords[index] = widget.word;
          break;
        }
        index++;
      }
    }
  }

  bool _allSelectedWordsEmpty() {
    return widget.selectedWords.every((word) => word.isEmpty);
  }
}
