import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cryptoListProvider =
    StateNotifierProvider<CryptoListNotifier, List<Crypto>>((ref) {
  return CryptoListNotifier(dummyCryptos);
});

final searchQueryProvider = StateProvider<String>((ref) => '');

class CryptoSearchCurrencyWidget extends ConsumerWidget {
  const CryptoSearchCurrencyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          _SearchField(ref: ref),
          Expanded(child: _CryptoList(ref: ref)),
        ],
      ),
    );
  }
}

class _SearchField extends ConsumerWidget {
  const _SearchField({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search Crypto',
          hintText: 'Enter crypto name or title',
          prefixIcon: Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () =>
                      ref.read(cryptoListProvider.notifier).clear(),
                )
              : null,
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => ref
            .read(cryptoListProvider.notifier)
            .updateSearchQuery(value.toLowerCase()),
      ),
    );
  }
}

class _CryptoList extends ConsumerWidget {
  const _CryptoList({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptos = ref.watch(cryptoListProvider);
    return ListView.builder(
      itemCount: cryptos.length,
      itemBuilder: (context, index) {
        final crypto = cryptos[index];
        return ListTile(
          title: Text(crypto.title),
          subtitle: Text('${crypto.name} - ${crypto.type}'),
          onTap: () {
            print('Selected: ${crypto.title}');
          },
        );
      },
    );
  }
}

class CryptoListNotifier extends StateNotifier<List<Crypto>> {
  CryptoListNotifier(List<Crypto> state) : super(state);

  void updateSearchQuery(String query) {
    state = dummyCryptos
        .where((crypto) =>
            crypto.name.toLowerCase().contains(query) ||
            crypto.title.toLowerCase().contains(query))
        .toList();
  }

  void clear() {
    state = dummyCryptos;
  }
}

class Crypto {
  final String title;
  final String name;
  final String type;

  Crypto({required this.title, required this.name, required this.type});
}

List<Crypto> dummyCryptos = [
  Crypto(title: 'Crypto 1', name: 'Bitcoin', type: 'BTC'),
  Crypto(title: 'Crypto 2', name: 'Ethereum', type: 'ETH'),
  Crypto(title: 'Crypto 3', name: 'Ripple', type: 'XRP'),
  Crypto(title: 'Crypto 4', name: 'Litecoin', type: 'LTC'),
  Crypto(title: 'Crypto 5', name: 'Cardano', type: 'ADA'),
  Crypto(title: 'Crypto 6', name: 'Polkadot', type: 'DOT'),
  Crypto(title: 'Crypto 7', name: 'Stellar', type: 'XLM'),
  Crypto(title: 'Crypto 8', name: 'Chainlink', type: 'LINK'),
  Crypto(title: 'Crypto 9', name: 'Bitcoin Cash', type: 'BCH'),
  Crypto(title: 'Crypto 10', name: 'VeChain', type: 'VET'),
];
