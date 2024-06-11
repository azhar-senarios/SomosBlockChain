// import 'package:somos_app/all_utills.dart';
// import 'package:somos_app/screens/home/dashboard_screen.dart';
//
// class RecentRatesWidget extends ConsumerWidget {
//   const RecentRatesWidget({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final state = ref.watch(recentRatesProvider);
//
//     return state.when(
//       data: (coin) => coin.isEmpty
//           ? const Center(child: Text('No Coin Found'))
//           : RecentRatesWidgetBuilder(
//               coinRateList: coin,
//             ),
//       error: Utils.buildErrorHandlerWidget,
//       loading: () {
//         return SizedBox(
//             height: 0.5.sh,
//             child: const Center(child: CircularProgressIndicator.adaptive()));
//       },
//     );
//   }
// }
//
// class RecentRatesWidgetBuilder extends ConsumerWidget {
//   final List<CoinRate> coinRateList;
//   const RecentRatesWidgetBuilder({
//     super.key,
//     required this.coinRateList,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     if (coinRateList.isEmpty) {
//       return Center(
//         child: Text(
//           'Some Error Occurred',
//           style: context.textTheme.headlineLarge,
//           textAlign: TextAlign.center,
//         ),
//       );
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Gap(32.h),
//         Text(
//           'Recent Rates',
//           style: context.textTheme.headlineLarge?.copyWith(fontSize: 24.sp),
//         ),
//         Gap(16.h),
//         SomosListViewBuilder(
//           shrinkWrap: true,
//           items: coinRateList,
//           itemBuilder: (rate) => CurrencyRateWidget(rate: rate),
//         ),
//       ],
//     );
//   }
// }
// Future<List<CoinRate>> fetchDataInIsolate() async {
//   final token = storage.authenticationToken;
//
//   final receivePort = ReceivePort();
//   final data = {
//     'port': receivePort.sendPort,
//     'token': token,
//   };
//
//   await Isolate.spawn(_coinListIsolate, data);
//   final completer = Completer<List<CoinRate>>();
//   receivePort.listen((data) async {
//     if (data is List<CoinRate>) {
//       completer.complete(data);
//       receivePort.close();
//     }
//   });
//   return completer.future;
// }
//
// void _coinListIsolate(Map<String, dynamic> data) async {
//   final sendPort = data['port'];
//   try {
//     ApiRequest.token = data['token'];
//     ApiRequest.isTokenStorage = false;
//     final HomeRepository homeRepositoryData = HomeRepository();
//     final fetchCoinImagesResponse = await homeRepositoryData.fetchCoinImages();
//     final fetchRecentRatesResponse =
//     await homeRepositoryData.fetchRecentRates(); // Pass token
//     final coinDetails =
//     fetchCoinImagesResponse.body as Map<String, CoinDetails>;
//
//     final coins = fetchRecentRatesResponse.body as List<CoinRate>;
//
//     for (final coin in coins) coin.details = coinDetails[coin.symbol];
//
//     sendPort.send(coins);
//   } catch (e) {
//     print(e);
//     sendPort.send([]);
//   }
// }
//
// final recentRatesProvider =
// FutureProvider.autoDispose<List<CoinRate>>((ref) async {
//   return await fetchDataInIsolate();
// });
