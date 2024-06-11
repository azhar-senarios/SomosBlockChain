import 'package:somos_app/screens/home/component/home_widget_component/select_network_widget.dart';

import '../../all_screen.dart';
import '../../all_utills.dart';
import '../../models/requests/send_crypto_request.dart';
import '../../models/response/send_crypto_response.dart';
import '../home/component/home_widget_component/account_widget.dart';

class SendCryptoScreen extends ConsumerStatefulWidget {
  final String? scanData;
  static const String routeName = '/SendCryptoScreen';

  const SendCryptoScreen({super.key, this.scanData});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendCryptoScreenState();
}

class _SendCryptoScreenState extends ConsumerState<SendCryptoScreen> {
  final _toWalletAddressController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.scanData != null) {
      _toWalletAddressController.text = widget.scanData ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentAccountBalance = ref.watch(selectedAccountBalanceDetail);
    return Form(
      key: _formKey,
      child: BaseScaffold(
        appBarTitle: 'Send',
        child: ListView(
          children: [
            Gap(32.h),
            const WalletBalanceAndStatsWidget(),
            Gap(15.h),
            SomosCaptionTextField(
              hintText: 'e.g 0x1Dd3bb755e7Ce67d21F0297cDc',
              title: 'To (Wallet Address)',
              controller: _toWalletAddressController,
              validator: Validators.validateNonEmptyString,
              suffix: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: SvgButton(
                  onTap: () {
                    context.unFocus();
                    context.push(QrCodeScannerScreen.routeName, extra: true);
                  },
                  fit: BoxFit.contain,
                  imagePath: Assets.icons.walletAddress,
                ),
              ),
            ),
            Gap(15.h),
            SomosCaptionTextField(
              hintText: 'Enter amount',
              title: 'Amount',
              controller: _amountController,
              validator: (_) => Validators.validateBalanceAmount(
                  _amountController.text, currentAccountBalance?.balance),
              textInputType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
            ),
            Gap(32.h),
            SomosElevatedButton(
              title: 'Send',
              onPressed: (context) => _onSendPressed(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSendPressed(BuildContext context, WidgetRef ref) async {
    context.unFocus();

    if (!_formKey.currentState!.validate()) return;
    final selectedNetworkDetail = ref.read(selectedAccountBalanceDetail);
    final selectedAccountData = ref.read(currentAccountSelectionProvider);
    if (selectedNetworkDetail == null)
      return Utils.displayToast('Failed To Fetch get Balance');

    if (selectedAccountData?.address == null)
      return Utils.displayToast('Failed To Fetch get Account Wallet Address');

    if (selectedAccountData?.address ==
        _toWalletAddressController.text.trim()) {
      return Utils.displayToast(
          'Receiver Account must be different current Account');
    }
    try {
      final response = await homeRepository.sendCrypto(
        SendCryptoRequest(
          sendCryptoModel: SendCryptoModel(
            networkName: selectedNetworkDetail.network,
            currency: selectedNetworkDetail.currency,
            amount: _amountController.text.trim(),
            senderAddress: selectedAccountData?.address ?? 'N/a',
            receiverAddress: _toWalletAddressController.text.trim(),
          ),
        ),
      );
      Utils.displayToast(response.message);

      if (!response.status) return;
      _amountController.clear();
      _toWalletAddressController.clear();
      ref.invalidate(networkTypeProvider);
      ref.invalidate(coinDetailProvider);
      ref.invalidate(allAccountsProvider);
      ref.invalidate(transcationHistoryProvider);
      context.pop();
    } on ApiError catch (e) {
      Utils.displayToast(e.message);
    }
  }

  @override
  void dispose() {
    _toWalletAddressController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
