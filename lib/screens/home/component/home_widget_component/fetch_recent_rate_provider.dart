import 'dart:isolate';

import 'package:somos_app/models/response/fetch_coin_images_response.dart';
import 'package:somos_app/models/response/fetch_recent_rates_response.dart';

import '../../../../all_utills.dart';

Future<List<CoinRate>> fetchDataInIsolate() async {
  final token = storage.authenticationToken;

  final receivePort = ReceivePort();
  final data = {
    'port': receivePort.sendPort,
    'token': token,
  };

  await Isolate.spawn(_coinListIsolate, data);
  final completer = Completer<List<CoinRate>>();
  receivePort.listen((data) async {
    if (data is List<CoinRate>) {
      completer.complete(data);
      receivePort.close();
    }
  });
  return completer.future;
}

void _coinListIsolate(Map<String, dynamic> data) async {
  final sendPort = data['port'];
  List<CoinRate> updatedCoinList = [];
  try {
    ApiRequest.isTokenStorage = false;
    ApiRequest.token = data['token'];
    final HomeRepository homeRepositoryData = HomeRepository();
    final fetchCoinImagesResponse = await homeRepositoryData.fetchCoinImages();
    final fetchRecentRatesResponse =
        await homeRepositoryData.fetchRecentRates(); // Pass token
    if (fetchRecentRatesResponse.body != null &&
        fetchRecentRatesResponse.body != {}) {
      final coinDetails =
          fetchCoinImagesResponse.body as Map<String, CoinDetails>;

      final coins = fetchRecentRatesResponse.body as List<CoinRate>;

      for (final coin in coins) {
        coin.details = coinDetails[coin.symbol];
      }
      updatedCoinList = [...coins];
    }

    if (updatedCoinList.isNotEmpty) {
      final filteredCoins = updatedCoinList
          .where((coin) => desiredCoins.contains(coin.symbol))
          .toList();
      sendPort.send(filteredCoins);
    } else {
      sendPort.send([]);
    }
  } catch (e) {
    sendPort.send([]);
  }
}

final recentRatesProvider =
    FutureProvider.autoDispose<List<CoinRate>>((ref) async {
  return await fetchDataInIsolate();
});
const Set<String> desiredCoins = {
  'ETH',
  'USDT',
  'BNB',
  'SOL',
  'USDC',
  'XRP',
  'TON',
  'DOGE',
  'ADA',
  'SHIB',
  'AVAX',
  'TRX',
  'DOT',
  'BCH',
  'LINK',
  'NEAR',
  'MATIC',
  'LTC',
  'ICP',
  'LEO',
  'DAI',
  'FET',
  'UNI',
  'RNDR',
  'PEPE',
  'HBAR',
  'ETC',
  'APT',
  'CRO',
  'ATOM',
  'MNT',
  'IMX',
  'FIL',
  'XLM',
  'WIF',
  'OKB',
  'STX',
  'KAS',
  'GRT',
  'ARB',
  'OP'
};
