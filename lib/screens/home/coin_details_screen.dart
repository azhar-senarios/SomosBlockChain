import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:somos_app/screens/wallet/component/web_view_flutter.dart';

import '../../all_screen.dart';
import '../../all_utills.dart';
import '../../models/requests/fetch_coin_rate_by_timeframe_request.dart';

final currentDurationIndexProvider = StateProvider<int>((ref) => 0);

class ChartData {
  final DateTime x;
  final double y;

  ChartData({required this.x, required this.y});

  @override
  String toString() => 'ChartData(x: $x, y: $y)';
}

final graphDetailWidget =
    FutureProvider.autoDispose<CoinRateInRange?>((ref) async {
  try {
    final accountDetail = ref.read(selectedAccountBalanceDetail);
    if (accountDetail == null) return null;
    final startDate = DateTime.now();
    final currentIndex = ref.watch(currentDurationIndexProvider);

    final endDate = computeEndDate(startDate, currentIndex);
    return (await homeRepository.fetchCoinPricesInRange(
            FetchCoinRateByTimeFrameRequest(
                symbol: accountDetail.currency,
                endDate: endDate,
                startDate: startDate)))
        .body;
  } on ApiError catch (e) {
    Utils.displayToast(e.toString());
    return null;
  }
});

class CoinDetailsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/CoinDetailsScreen';

  const CoinDetailsScreen({super.key});

  @override
  ConsumerState<CoinDetailsScreen> createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends ConsumerState<CoinDetailsScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    Future.delayed(Duration.zero, () => _onButtonBarTogglePressed(null));

    super.initState();
  }

  Future<void> _onBuyCryptoPressed(BuildContext context) async =>
      context.push(MoonPayWebView.routeName, extra: true);

  void _onButtonBarTogglePressed(int? index) async {
    ref.read(currentDurationIndexProvider.notifier).state = index ?? 0;
    ref.invalidate(graphDetailWidget);
  }

  @override
  Widget build(BuildContext context) {
    final durationIndex = ref.watch(currentDurationIndexProvider);
    final accountDetail = ref.watch(selectedAccountBalanceDetail);
    return BaseScaffold(
      scaffoldPadding: EdgeInsets.zero,
      appBarTitle: accountDetail?.network ?? 'ETH',
      bottomSheet: SomosContainer(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: SomosElevatedButton(
          title: 'Buy',
          onPressed: _onBuyCryptoPressed,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(32.h),
                CoinNameAndPriceChangeWidget(
                  symbol: accountDetail?.currency ?? 'ETH',
                  price: double.parse(
                      accountDetail?.cryptoData?.rate ?? 0.0.toString()),
                  changePercent: accountDetail?.cryptoData?.changePct ?? 0.0,
                  imageUrl: accountDetail?.logoUrl ??
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Ethereum_logo_2014.svg/1257px-Ethereum_logo_2014.svg.png',
                ),
                Gap(24.h),
                SomosContainer(
                  height: 36.h,
                  color: const Color.fromRGBO(243, 243, 243, 0.10),
                  borderRadius: BorderRadius.circular(
                    AppWidgets.borderRadiusValue * 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: durations
                        .mapIndexed((index, e) => CustomToggleSwitch(
                              label: e.toString(),
                              index: index,
                              currentIndex: durationIndex,
                              onChanged: _onButtonBarTogglePressed,
                            ))
                        .toList(),
                  ),
                ),
                Gap(20.h),
                const ChartWidget(),
              ],
            ),
          ),
          SomosContainer(
            width: 1.sw,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(AppWidgets.borderRadiusValue),
              topLeft: Radius.circular(AppWidgets.borderRadiusValue),
            ),
            color: const Color.fromRGBO(243, 243, 243, 0.10),
            padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Market Statistics',
                  style: context.textTheme.headlineLarge?.copyWith(
                    color: context.theme.primaryColor,
                    fontSize: 20.sp,
                  ),
                ),
                Gap(16.h),
                StatisticsWidget(
                    title: 'Circulating Supply',
                    subtitle:
                        accountDetail?.cryptoData?.cap.toString() ?? 'N/a'),
                Gap(16.h),
                StatisticsWidget(
                    title: 'Volume 24h',
                    subtitle: accountDetail?.cryptoData?.vol ?? 'N/a'),
                Gap(16.h),
                StatisticsWidget(
                    title: 'Available Supply',
                    subtitle: accountDetail?.cryptoData?.sup ?? 'N/a'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          subtitle,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.theme.primaryColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class CoinNameAndPriceChangeWidget extends StatelessWidget {
  final String symbol;
  final double changePercent;
  final double price;
  final String imageUrl;
  const CoinNameAndPriceChangeWidget(
      {super.key,
      required this.symbol,
      this.changePercent = 0,
      this.price = 0.0,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final color = changePercent >= 0
        ? context.colorScheme.onTertiary
        : context.colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    symbol,
                    style: context.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  Gap(2.h),
                  Text(
                    '\$ ${price.toStringAsFixed(6)}',
                    style: context.textTheme.headlineLarge
                        ?.copyWith(fontSize: 28.sp),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 56.w,
              height: 56.h,
              child: CacheImage(imageUrl: imageUrl, isCircle: true),
            ),
          ],
        ),
        Gap(8.h),
        Row(
          children: [
            SvgPicture.asset(
              changePercent >= 0
                  ? Assets.icons.growthUp
                  : Assets.icons.growthDown,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              ' ${changePercent.toStringAsFixed(3)}%',
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Gap(4.w),
            Text(
              'Today',
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomToggleSwitch extends StatelessWidget {
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onChanged;

  const CustomToggleSwitch({
    super.key,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(index),
        child: SomosContainer(
          borderRadius: BorderRadius.circular(
            AppWidgets.borderRadiusValue * 2,
          ),
          gradient: index == currentIndex ? AppColors.buttonGradient : null,
          child: Center(child: Text(label)),
        ),
      ),
    );
  }
}

class ChartWidget extends ConsumerWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symbolDetail = ref.watch(graphDetailWidget);

    return SizedBox(
        height: 0.3.sh,
        width: 1.sw,
        child: symbolDetail.when(
            data: (value) {
              return value == null
                  ? Center(
                      child: Text('No Graph',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge),
                    )
                  : LineChartWidget(rates: value.rates);
            },
            error: (value, stackTrace) {
              return Utils.buildErrorHandlerWidget(value, stackTrace);
            },
            loading: () => Utils.buildLoadingHandlerWidget()));
  }
}

class LineChartWidget extends ConsumerWidget {
  final List<RateModel> rates;

  const LineChartWidget({super.key, required this.rates});

  String _formatDate(DateTime date, int selectedIndex) {
    switch (selectedIndex) {
      case 0: // 7 Days
        return DateFormat('MMM d').format(date);
      case 1: // 1 Month
        return DateFormat('MMM d').format(date);
      case 2: // 3 Months
        return DateFormat('MMM').format(date);
      case 3: // 1 Year
        return DateFormat('MMM').format(date);
      default:
        return DateFormat('MM/dd').format(date);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(currentDurationIndexProvider);
    double interval;
    bool isCrowded = rates.length < 30;
    switch (selectedIndex) {
      case 0:
        interval = isCrowded ? 2 : 1; // Show label every other day if crowded
        break;
      case 1:
        interval = 10;
        break;
      case 2:
        interval = 30;
        break;
      case 3:
        interval = 100;
        break;
      default:
        interval = 1;
        break;
    }

    return LineChart(LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50.w,
            getTitlesWidget: (double value, TitleMeta meta) {
              final index = value.toInt();
              if (index % interval == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _formatDate(
                        DateTime.parse(rates[index].date), selectedIndex),
                    style:
                        context.textTheme.bodyLarge?.copyWith(fontSize: 10.sp),
                  ),
                );
              }
              return const Text('');
            },
            interval: interval, // Set interval for equal spacing
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              return value % 100 == 0
                  ? Text('\$${value.toStringAsFixed(2)}',
                      style: context.textTheme.bodyLarge
                          ?.copyWith(fontSize: 10.sp))
                  : const Text('');
            },
            reservedSize: 60.w,
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: (rates.length - 1).toDouble(),
      minY: rates.isEmpty
          ? 0
          : rates.map((e) => e.rates).reduce(min).toDouble() - 100,
      maxY: rates.isEmpty
          ? 0
          : rates.map((e) => e.rates).reduce(max).toDouble() +
              100 +
              20, // Adding extra space on top
      lineBarsData: [
        LineChartBarData(
          spots: rates
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.rates))
              .toList(),
          isCurved: true,
          color: Colors.blue,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: true),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                'rate:\$${barSpot.y.toStringAsFixed(3)} \nDate: ${_formatDate(DateTime.parse(rates[barSpot.x.toInt()].date), selectedIndex)} \nHigh: ${double.parse(rates[barSpot.spotIndex].high).toStringAsFixed(3)} \nLow: ${double.parse(rates[barSpot.spotIndex].low)} ',
                context.textTheme.bodyLarge
                        ?.copyWith(color: Colors.white, fontSize: 10.sp) ??
                    const TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
    ));
  }
}
