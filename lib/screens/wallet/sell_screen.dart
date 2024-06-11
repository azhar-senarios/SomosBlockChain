import 'package:somos_app/all_utills.dart';
import 'package:somos_app/screens/home/component/home_screen.dart';
import 'package:somos_app/screens/home/component/home_widget_component/select_network_widget.dart';
import 'package:somos_app/screens/wallet/component/web_view_flutter.dart';

class SellScreen extends ConsumerStatefulWidget {
  static const String routeName = '/SellScreen';

  const SellScreen({super.key});

  @override
  ConsumerState<SellScreen> createState() => _BuyCryptoScreenState();
}

class _BuyCryptoScreenState extends ConsumerState<SellScreen> {
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentSelectionDetail = ref.watch(selectedAccountBalanceDetail);
    final currentSelectNetwork = ref.watch(networkTypeSelectionProvider);

    return BaseScaffold(
      appBarTitle: 'Sell',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(32.h),
            Text(
              'You want to Sell',
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
              title: 'Amount',
              hintText: 'Enter amount',
              controller: _amountController,
              textInputType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
            ),
            Gap(32.h),
            SomosElevatedButton(
              title: 'Sell',
              onPressed: (context) => _sellPressed(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sellPressed(BuildContext context, WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_amountController.text.isEmpty) {
      return Utils.displayToast('Amount Field is Mandatory');
    }
    final amount = ref.read(selectedAccountBalanceDetail)?.balance ?? 0.0;

    if (double.parse(amount.toString()) <
        double.parse(_amountController.text)) {
      return Utils.displayToast('You do not have enough balance');
    }
    ref.read(amountProvider.notifier).state = _amountController.text;
    context.push(MoonPayWebView.routeName);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _pressedAmount(BuildContext context) {
    context.unFocus();
    showModelBottomSheet(
        height: 0.7.sh,
        title: 'Select Region Currency',
        context,
        child: AmountRegionCurrencyWidget(
            amountCurrencyList: AmountCurrencyModel.getCurrencyList));
  }
}

class AmountRegionCurrencyWidget extends ConsumerStatefulWidget {
  final List<AmountCurrencyModel> amountCurrencyList;
  const AmountRegionCurrencyWidget(
      {super.key, this.amountCurrencyList = const []});

  @override
  ConsumerState<AmountRegionCurrencyWidget> createState() =>
      _AmountRegionCurrencyWidgetState();
}

class _AmountRegionCurrencyWidgetState
    extends ConsumerState<AmountRegionCurrencyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(10.h),
        const SomosSearchField(),
        Gap(16.h),
        SizedBox(
          height: 0.5.sh,
          child: SomosListViewBuilder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 40.h),
              withExpanded: false,
              separationWidget: const Divider(thickness: 1.5),
              items: widget.amountCurrencyList,
              itemBuilder: (amountCurrencyData) {
                final amountData = amountCurrencyData as AmountCurrencyModel;
                return GestureDetector(
                  onTap: () {
                    context.pop();
                    ref.read(amountCurrencySelectionProvider.notifier).state =
                        amountData;
                  },
                  child: ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(amountData.name,
                        style: Theme.of(context).textTheme.headlineMedium),
                    leading: Text(amountData.symbol,
                        style: Theme.of(context).textTheme.headlineMedium),
                    subtitle: Text(amountData.shortForm,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                );
              }),
        )
      ],
    );
  }
}

class DropDownShowWidget extends StatelessWidget {
  final String? displayText;
  final BuildContextCallback? onPressed;
  const DropDownShowWidget({super.key, this.displayText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed == null ? null : () => onPressed!(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              displayText ?? 'Eth'.toUpperCase(),
              style: context.textTheme.bodyLarge,
            ),
            const HorizontalSpacing(of: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}

// Model to hold currency information
class AmountCurrencyModel {
  final String name;
  final String symbol;
  final String shortForm;

  AmountCurrencyModel(
      {required this.name, required this.symbol, required this.shortForm});
  static List<AmountCurrencyModel> getCurrencyList = [
    AmountCurrencyModel(
        name: 'United States Dollar', symbol: '\$', shortForm: 'USD'),
    AmountCurrencyModel(name: 'Euro', symbol: '€', shortForm: 'EUR'),
    AmountCurrencyModel(
        name: 'British Pound Sterling', symbol: '£', shortForm: 'GBP'),
    AmountCurrencyModel(name: 'Japanese Yen', symbol: '¥', shortForm: 'JPY'),
    AmountCurrencyModel(
        name: 'Australian Dollar', symbol: 'A\$', shortForm: 'AUD'),
    AmountCurrencyModel(name: 'Swiss Franc', symbol: 'CHF', shortForm: 'CHF'),
    AmountCurrencyModel(
        name: 'Canadian Dollar', symbol: 'CA\$', shortForm: 'CAD'),
    AmountCurrencyModel(name: 'Chinese Yuan', symbol: '¥', shortForm: 'CNY'),
    AmountCurrencyModel(name: 'Swedish Krona', symbol: 'kr', shortForm: 'SEK'),
    AmountCurrencyModel(
        name: 'New Zealand Dollar', symbol: 'NZ\$', shortForm: 'NZD'),
    AmountCurrencyModel(
        name: 'South Korean Won', symbol: '₩', shortForm: 'KRW'),
    AmountCurrencyModel(
        name: 'Singapore Dollar', symbol: 'S\$', shortForm: 'SGD'),
    AmountCurrencyModel(
        name: 'Hong Kong Dollar', symbol: 'HK\$', shortForm: 'HKD'),
    AmountCurrencyModel(
        name: 'Norwegian Krone', symbol: 'kr', shortForm: 'NOK'),
    AmountCurrencyModel(name: 'Mexican Peso', symbol: 'MX\$', shortForm: 'MXN'),
    AmountCurrencyModel(name: 'Indian Rupee', symbol: '₹', shortForm: 'INR'),
    AmountCurrencyModel(name: 'Russian Ruble', symbol: '₽', shortForm: 'RUB'),
    AmountCurrencyModel(
        name: 'Brazilian Real', symbol: 'R\$', shortForm: 'BRL'),
    AmountCurrencyModel(
        name: 'South African Rand', symbol: 'R', shortForm: 'ZAR'),
    AmountCurrencyModel(name: 'Turkish Lira', symbol: '₺', shortForm: 'TRY'),
    AmountCurrencyModel(name: 'Danish Krone', symbol: 'kr', shortForm: 'DKK'),
    AmountCurrencyModel(name: 'Polish Zloty', symbol: 'zł', shortForm: 'PLN'),
    AmountCurrencyModel(name: 'Thai Baht', symbol: '฿', shortForm: 'THB'),
    AmountCurrencyModel(name: 'Philippine Peso', symbol: '₱', shortForm: 'PHP'),
  ];
}

class SomosSearchField extends StatelessWidget {
  final void Function(String?)? onChanged;
  final String? hintTitle;
  const SomosSearchField({super.key, this.onChanged, this.hintTitle});

  @override
  Widget build(BuildContext context) {
    return SomosCaptionTextField(
      prefix: Icon(
        Icons.search,
        size: 20.h,
        color: Colors.white,
      ),
      hintText: hintTitle ?? 'Search Coin',
      onChanged: onChanged,
    );
  }
}
