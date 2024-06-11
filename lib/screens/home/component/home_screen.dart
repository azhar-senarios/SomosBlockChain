import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:somos_app/models/response/fetch_recent_rates_response.dart';
import 'package:somos_app/screens/home/component/home_widget_component/fetch_recent_rate_provider.dart';
import 'package:somos_app/screens/wallet/component/web_view_flutter.dart';

import '../../../all_screen.dart';
import '../../../all_utills.dart';
import '../../../models/requests/fetch_selected_networkDetail_request.dart';
import '../../../models/response/fetch_crypto_detail_response.dart';
import '../../../models/response/fetch_selected_networkDetail_response.dart';
import '../../../services/remote_config.dart';
import '../coin_details_screen.dart';
import 'home_widget_component/account_widget.dart';
import 'home_widget_component/plan_dialog_widget.dart';
import 'home_widget_component/select_network_widget.dart';

final amountCurrencySelectionProvider =
    StateProvider.autoDispose<AmountCurrencyModel>(
        (ref) => AmountCurrencyModel.getCurrencyList.first);
final amountProvider = StateProvider<String>((ref) => '');

final coinDetailProvider = FutureProvider.autoDispose<AccountDetail?>(
  (ref) async {
    final networkModel = ref.watch(networkTypeSelectionProvider);
    final account = ref.watch(currentAccountSelectionProvider);

    if (networkModel != null && account != null) {
      try {
        ApiResponse? rates;
        final response = await homeRepository.fetchSelectedNetworkDetail(
          FetchSelectedNetworkDetailRequest(
            currentNetwork: networkModel.name ?? '',
            currentAccountAddress: account.address ?? '',
          ),
        );
        final body = response.body;

        if (body != null && body is AccountDetail) {
          final data = await homeRepository.fetchCurrencyPrice(
              FetchCoinDetailRequest(symbol: body.currency));
          rates = data;
        }
        if (body != null &&
            body is AccountDetail &&
            rates != null &&
            rates.body != null &&
            rates.status == true &&
            rates.body is Map) {
          final cryptoData = CryptoDetailModel.fromJson(rates.body);
          body.cryptoData = cryptoData;
        }
        ref.read(selectedNetworkDetailProvider.notifier).state =
            body as AccountDetail?;

        return body;
      } on ApiError catch (e) {
        Utils.displayToast(e.toString());
        return null;
      }
    } else {
      return null;
    }
  },
);

final selectedAccountBalanceDetail =
    StateProvider<AccountDetail?>((ref) => null);
final selectedNetworkDetailProvider =
    StateProvider<AccountDetail?>((ref) => null);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popState = ref.watch(popShowStateProvider);

    ref.listen(tierStateProvider, (_, state) async {
      final response = state.value;
      if ((!(state.isLoading &&
              state.hasError &&
              response?.purchased == false) &&
          (response?.tiers != null &&
              response?.tiers!.length == 3 &&
              response?.purchased == false) &&
          popState)) _showPlansDialogue(context);
    });

    return BaseScaffold(
      leadingWidthAppBar: 55.w,
      appBarTitleWidget: Image.asset(
        Assets.images.somosHomeLogo.path,
        scale: 1.9,
      ),
      appBarAction: const [HomeNetworkWidget()],
      leadingAppBar: SvgButton(
        imagePath: Assets.icons.scan,
        padding: EdgeInsets.only(left: 20.w),
        onTap: () => _scanPressed(context),
        fit: BoxFit.contain,
      ),
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(coinDetailProvider.future),
        child: ListView(
          shrinkWrap: true,
          primary: true,
          children: [
            Gap(32.h),
            const AccountWidget(),
            Gap(24.h),
            const WalletBalanceAndStatsWidget(),
            Gap(24.h),
            Row(
              children: [
                RemoteConfigManager.instance.showBuyer
                    ? Expanded(
                        child: HomeScreenButtonWidget(
                          title: 'Buy / Sell',
                          onTap: _onBuySellPressed,
                        ),
                      )
                    : const SizedBox(),
                RemoteConfigManager.instance.showBuyer
                    ? const HorizontalSpacing()
                    : const SizedBox(),
                Expanded(
                  child: HomeScreenButtonWidget(
                    title: 'Send / Receive',
                    onTap: _onSendReceivedPressed,
                  ),
                ),
              ],
            ),
            const VerticalSpacing(of: 20),
            const NetworkSelectionCoin(),
            const _RecentRatesWidget(),
          ],
        ),
      ),
    );
  }

  bool _shouldShowDialogue() {
    if (!kDebugMode) return true;

    final count = storage.dialogueCount;

    if (count >= 8) return false;

    storage.write(PrefsStorage.dialogueCountKey, (count + 1).toString());

    return true;
  }

  void _showPlansDialogue(BuildContext context) {
    if (!_shouldShowDialogue()) return;

    showDialog(
      context: context,
      builder: (_) => const ChoosePlanDialogWidget(),
    );
  }

  void _onSendPressed(BuildContext context) {
    context.pop();
    context.push(SendCryptoScreen.routeName);
  }

  void _onReceivePressed(BuildContext context) {
    context.pop();

    context.push(ReceiveCryptoScreen.routeName);
  }

  void _onSendReceivedPressed(BuildContext context) {
    // context.push(MoonPayWebView.routeName, extra: true);
    showModelBottomSheet(
        title: '',
        gap: 2,
        context,
        child: SendReceivedBottomSheet(
          firstTitle: 'Send',
          isImageFirst: true,
          firstUrl: Assets.icons.transactionSent,
          secondTitle: 'Receive',
          onPressedFirst: _onSendPressed,
          isImageSecond: true,
          secondUrl: Assets.icons.transactionRecieved,
          onPressedSecond: _onReceivePressed,
        ));

    // context.push(BuyScreen.routeName);
  }

  void _onBuySellPressed(BuildContext context) {
    showModelBottomSheet(
        title: '',
        context,
        gap: 2,
        child: SendReceivedBottomSheet(
          isSecondIcon: Icons.remove,
          onPressedFirst: (_) {
            context.pop();
            context.push(MoonPayWebView.routeName, extra: true);
          },
          onPressedSecond: (_) {
            context.pop();

            context.push(MoonPayWebView.routeName);
          },
        ));

    // context.push(SellScreen.routeName, extra: true);
  }

  void _scanPressed(BuildContext context) =>
      context.push(QrCodeScannerScreen.routeName);
}

class HomeScreenButtonWidget extends StatelessWidget {
  const HomeScreenButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final BuildContextCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SomosContainer(
      onPressed: onTap,
      alignment: Alignment.center,
      border: const GradientBoxBorder(
        gradient: AppColors.buttonGradient,
      ),
      borderRadius: BorderRadius.circular(
        AppWidgets.borderRadiusValue * 3,
      ),
      padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 10.h),
      child: Text(
        title,
        style: context.textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class HomeLeadingWidget extends StatelessWidget {
  const HomeLeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SomosContainer(
      width: 48.w,
      alignment: Alignment.center,
      height: 48.h,
      shape: BoxShape.circle,
      border: Border.all(color: context.theme.hintColor),
      child: SizedBox(
        height: 40.h,
        width: 40.w,
        child: SvgPicture.asset(
          Assets.icons.logo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class NetworkDetailShowingWidget extends StatelessWidget {
  final AccountDetail? accountDetail;
  const NetworkDetailShowingWidget({super.key, this.accountDetail});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.r),
      // onTap: () => _onCurrentRatePressed(context),
      leading: CacheImage(
        imageUrl: accountDetail?.logoUrl ??
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Ethereum_logo_2014.svg/1257px-Ethereum_logo_2014.svg.png',
        width: 48.w,
        height: 48.h,
      ),
      title: Text(
        accountDetail?.network ?? 'N/a',
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        accountDetail?.currency ?? 'N/a',
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.theme.hintColor,
        ),
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                accountDetail?.balance.toString() ?? '',
                style: context.textTheme.bodyLarge,
              ),
              Gap(5.h),
            ],
          )
        ],
      ),
    );
  }
}

class NetworkSelectionCoin extends ConsumerStatefulWidget {
  const NetworkSelectionCoin({super.key});

  @override
  ConsumerState<NetworkSelectionCoin> createState() =>
      _NetworkSelectionCoinWidgetState();
}

class _NetworkSelectionCoinWidgetState
    extends ConsumerState<NetworkSelectionCoin>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final coinData = ref.watch(coinDetailProvider);

    super.build(context);
    return coinData.when(
      data: (value) {
        return value == null
            ? Text('No Coin Found',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge)
            : ListTile(
                key: const PageStorageKey('CoinSelected'),
                onTap: () {
                  ref.read(selectedAccountBalanceDetail.notifier).state =
                      ref.read(selectedNetworkDetailProvider.notifier).state;
                  context.push(CoinDetailsScreen.routeName);
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 4.r),
                leading: CacheImage(
                  imageUrl: value.logoUrl,
                  width: 48.w,
                  height: 48.h,
                ),
                title: Text(
                  value.network,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  value.currency,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.hintColor,
                  ),
                ),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value.cryptoData?.rate == null
                              ? '0.0'
                              : "\$${double.tryParse(value.cryptoData?.rate ?? '0.0')!.toStringAsFixed(3)}",
                          style: context.textTheme.bodyLarge,
                        ),
                        Gap(5.h),
                        value.cryptoData?.changePct == null
                            ? const SizedBox()
                            : Row(
                                children: [
                                  Text(
                                    value.cryptoData?.changePct
                                            .toStringAsFixed(3) ??
                                        '\$ 0.0',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                            color: value.cryptoData!
                                                        .changePct >=
                                                    0
                                                ? context.colorScheme.onTertiary
                                                : context.colorScheme.error),
                                  ),
                                  Gap(2.w),
                                  value.cryptoData?.changePct == null
                                      ? const SizedBox()
                                      : Icon(
                                          value.cryptoData!.changePct >= 0
                                              ? Icons.arrow_upward
                                              : Icons.arrow_downward,
                                          color: value.cryptoData!.changePct >=
                                                  0
                                              ? context.colorScheme.onTertiary
                                              : context.colorScheme.error),
                                ],
                              ),
                      ],
                    )
                  ],
                ),
              );
      },
      error: Utils.buildErrorHandlerWidget,
      loading: () {
        return SizedBox(
            height: 0.1.sh,
            child: const Center(child: CircularProgressIndicator.adaptive()));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SendReceivedBottomSheet extends StatelessWidget {
  final bool isImageFirst;
  final String? isFirstUrl;
  final IconData? isFirstIcon;
  final bool isImageSecond;
  final String? isSecondUrl;
  final IconData? isSecondIcon;
  final String firstTitle;
  final String secondTitle;
  final BuildContextCallback? onPressedFirst;
  final String? firstUrl;
  final String? secondUrl;
  final BuildContextCallback? onPressedSecond;
  const SendReceivedBottomSheet(
      {super.key,
      this.firstTitle = 'Buy',
      this.secondTitle = 'Sell',
      this.onPressedFirst,
      this.onPressedSecond,
      this.firstUrl,
      this.secondUrl,
      this.isImageFirst = false,
      this.isFirstUrl,
      this.isFirstIcon,
      this.isImageSecond = false,
      this.isSecondUrl,
      this.isSecondIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetTile(
          onPressed: onPressedFirst,
          isImage: isImageFirst,
          url: firstUrl,
          icon: isFirstIcon,
          title: firstTitle,
        ),
        const Divider(),
        BottomSheetTile(
          isImage: isImageSecond,
          icon: isSecondIcon,
          onPressed: onPressedSecond,
          url: secondUrl,
          title: secondTitle,
        ),
        const VerticalSpacing(of: 10),
      ],
    );
  }
}

class _RecentRatesWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentRatesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(32.h),
        Text(
          'Recent Rates',
          style: context.textTheme.headlineLarge?.copyWith(fontSize: 22.sp),
        ),
        Gap(16.h),
        state.when(
          data: (coin) => coin.isEmpty
              ? Center(
                  child: Text('No Recent Coin Found',
                      style: context.textTheme.bodyLarge))
              : RecentRateBuilder(
                  coinRateList: coin,
                ),
          error: Utils.buildErrorHandlerWidget,
          loading: () {
            return SizedBox(
                height: 0.1.sh,
                child:
                    const Center(child: CircularProgressIndicator.adaptive()));
          },
        ),
      ],
    );
  }

  const _RecentRatesWidget({super.key});
}

class RecentRateBuilder extends ConsumerWidget {
  final List<CoinRate> coinRateList;
  const RecentRateBuilder({
    super.key,
    required this.coinRateList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (coinRateList.isEmpty) {
      return Center(
        child: Text(
          'Some Error Occurred',
          style: context.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ScrollablePositionedList.builder(
      itemCount: coinRateList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return CurrencyRateWidget(rate: coinRateList[index]);
      },
    );
  }
}
