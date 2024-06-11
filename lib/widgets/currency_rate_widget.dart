import 'package:somos_app/all_utills.dart';
import 'package:somos_app/models/response/fetch_recent_rates_response.dart';
import 'package:somos_app/models/response/fetch_selected_networkDetail_response.dart';
import 'package:somos_app/screens/home/component/home_screen.dart';
import 'package:somos_app/screens/home/component/home_widget_component/account_widget.dart';

import '../models/response/fetch_crypto_detail_response.dart';
import '../screens/home/coin_details_screen.dart';

class CurrencyRateWidget extends ConsumerWidget {
  const CurrencyRateWidget({super.key, required this.rate});

  final CoinRate rate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon =
        rate.changePercent >= 0 ? Icons.arrow_upward : Icons.arrow_downward;

    final color = rate.changePercent >= 0
        ? context.colorScheme.onTertiary
        : context.colorScheme.error;

    return ListTile(
      visualDensity: const VisualDensity(vertical: -2),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.r),
      onTap: () => _onCurrentRatePressed(context, ref, rate),
      leading: CacheImage(
        isCircle: true,
        imageUrl: rate.imageUrl,
        width: 48.w,
        height: 48.h,
      ),
      title: Text(
        rate.name,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        rate.symbol,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.theme.hintColor,
        ),
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                // '\$${rate.price.toStringAsPrecision(7)}',
                '\$${rate.price.toString()}',
                style: context.textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              ),
              Row(
                children: [
                  Text(
                    '${rate.changePercent.toStringAsFixed(3)}%',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: color,
                    ),
                  ),
                  Gap(2.w),
                  Icon(icon, color: color),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // TODO implement it

  void _onCurrentRatePressed(
      BuildContext context, WidgetRef ref, CoinRate rate) async {
    final account = ref.read(currentAccountSelectionProvider);
    if (account != null) {
      ref.read(selectedAccountBalanceDetail.notifier).state = AccountDetail(
          network: rate.details?.name ?? rate.name,
          address: account.address,
          balance: '0.0',
          currency: rate.details?.symbol ?? rate.symbol,
          logoUrl: rate.imageUrl,
          cryptoData: CryptoDetailModel(
              currency: rate.details?.symbol ?? rate.symbol,
              rate: '${rate.price}',
              high: '${rate.high}',
              low: '${rate.low}',
              vol: rate.volume == 0.0 ? 'N/a' : '${rate.volume}',
              cap: rate.capacity == 0.0 || rate.capacity.toString() == '0.0'
                  ? 'N/a'
                  : '${rate.capacity}',
              sup: rate.supply == 0.0 ? 'N/a' : '${rate.supply}',
              change: rate.change,
              changePct: rate.changePercent));

      context.push(CoinDetailsScreen.routeName);
    }
  }
}
