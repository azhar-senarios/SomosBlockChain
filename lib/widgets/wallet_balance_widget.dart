import 'package:somos_app/screens/home/component/home_screen.dart';

import '../all_utills.dart';

class WalletBalanceAndStatsWidget extends StatelessWidget {
  const WalletBalanceAndStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SomosContainer(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 16.r),
      gradient: AppColors.buttonGradient,
      height: 0.12.sh,
      borderRadius: AppWidgets.borderRadius,
      child: Consumer(
        builder: (context, ref, child) {
          final balance = ref.watch(selectedNetworkDetailProvider);

          return BalanceTextPan(
              balance: balance != null && balance.balance.isNotEmpty
                  ? '${double.parse(balance.balance).toStringAsFixed(4)}  '
                  : '0.0000  ',
              currency: balance?.currency ?? 'ETH');
        },
      ),
    );
  }
}

class BalanceTextPan extends StatelessWidget {
  final String balance;
  final String currency;
  const BalanceTextPan(
      {super.key, required this.balance, required this.currency});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: balance,
        style: context.textTheme.headlineLarge
            ?.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700),
        children: [
          TextSpan(
            text: ' $currency',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
