import 'package:somos_app/all_utills.dart';
import 'package:somos_app/screens/home/component/home_screen.dart';
import 'package:somos_app/screens/home/component/home_widget_component/select_network_widget.dart';
import 'package:somos_app/screens/wallet/component/web_view_flutter.dart';
import 'package:somos_app/screens/wallet/sell_screen.dart';

class BuyScreen extends ConsumerStatefulWidget {
  static const String routeName = '/BuyScreen';

  const BuyScreen({super.key, this.shouldSell = false});

  final bool shouldSell;

  @override
  ConsumerState<BuyScreen> createState() => _BuyCryptoScreenState();
}

class _BuyCryptoScreenState extends ConsumerState<BuyScreen> {
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final amountSelection = ref.watch(amountCurrencySelectionProvider);
    final currentSelectionDetail = ref.watch(selectedAccountBalanceDetail);
    final currentSelectNetwork = ref.watch(networkTypeSelectionProvider);

    return BaseScaffold(
      appBarTitle: 'Buy',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(32.h),
            Text(
              'You want to buy',
              style: context.textTheme.bodyLarge,
            ),
            Gap(8.h),
            SomosContainer(
              width: 1.sw,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              borderRadius: AppWidgets.borderRadius,
              border: Border.all(color: context.theme.hintColor),
              child: Text(currentSelectNetwork?.name ?? 'Ethereum',
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Gap(8.h),
            Text(
              'Current Balance: ${currentSelectionDetail != null && currentSelectionDetail.balance.isNotEmpty ? '${double.parse(currentSelectionDetail.balance).toStringAsFixed(4)}  ' : '\$0.00'}',
              style: context.textTheme.bodyMedium?.copyWith(),
            ),
            Gap(16.h),
            SomosCaptionTextField(
                prefix: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 15.w),
                  child: Text(amountSelection.symbol,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 22.sp)),
                ),
                title: 'Amount',
                hintText: 'Enter amount in ${amountSelection.symbol}',
                controller: _amountController,
                textInputType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                suffixIcon: DropDownShowWidget(
                  onPressed: _pressedAmount,
                  displayText: amountSelection.shortForm,
                )),
            Gap(32.h),
            SomosElevatedButton(
              title: 'Buy',
              onPressed: (context) => buyPressed(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> buyPressed(BuildContext context, WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_amountController.text.isEmpty) {
      return Utils.displayToast('Amount Field is Mandatory');
    }

    ref.read(amountProvider.notifier).state = _amountController.text.trim();
    context.push(MoonPayWebView.routeName, extra: true);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _pressedAmount(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showModelBottomSheet(
        height: 0.7.sh,
        title: 'Select Region Currency',
        context,
        child: AmountRegionCurrencyWidget(
            amountCurrencyList: AmountCurrencyModel.getCurrencyList));
  }
}
