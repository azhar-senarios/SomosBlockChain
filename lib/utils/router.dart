import 'package:go_router/go_router.dart';
import 'package:somos_app/screens/wallet/component/web_view_flutter.dart';

import '../all_screen.dart';
import '../main.dart';
import '../screens/home/coin_details_screen.dart';
import '../screens/home/scan_qr_code_screen/qr_code_scanner_screen.dart';
import '../screens/home/splash_screen.dart';
import '../screens/wallet/buy_screen.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: <RouteBase>[
      GoRoute(
        path: SplashScreen.routeName,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: BuyScreen.routeName,
        builder: (_, __) => const BuyScreen(),
      ),
      GoRoute(
        path: SellScreen.routeName,
        builder: (_, __) => const SellScreen(),
      ),
      GoRoute(
        path: LandingPageScreen.routeName,
        builder: (_, __) => const LandingPageScreen(),
      ),
      GoRoute(
        path: FallbackPasswordScreen.routeName,
        builder: (_, state) {
          return FallbackPasswordScreen(
            routeToNavigate: state.extra.toString(),
          );
        },
      ),
      GoRoute(
        path: EnableFaceIDAuthenticationScreen.routeName,
        builder: (_, __) => const EnableFaceIDAuthenticationScreen(),
      ),
      GoRoute(
        path: EnableFingerPrintAuthenticationScreen.routeName,
        builder: (_, __) => const EnableFingerPrintAuthenticationScreen(),
      ),
      GoRoute(
        path: SelectRecoveryPhraseScreen.routeName,
        builder: (_, state) => SelectRecoveryPhraseScreen(
          words: state.extra as List<String>,
        ),
      ),
      GoRoute(
        path: CreateWalletScreen.routeName,
        builder: (_, state) =>
            CreateWalletScreen(recoveryPhrase: state.extra.toString()),
      ),
      GoRoute(
        path: ImportWalletScreen.routeName,
        builder: (_, __) => const ImportWalletScreen(),
      ),
      GoRoute(
        path: WalletCreatedScreen.routeName,
        builder: (_, state) =>
            WalletCreatedScreen(isImport: state.extra as bool? ?? false),
      ),
      GoRoute(
        path: CreatePasswordScreen.routeName,
        builder: (_, __) => const CreatePasswordScreen(),
      ),

      GoRoute(
        path: SendCryptoScreen.routeName,
        builder: (_, state) {
          return SendCryptoScreen(scanData: state.extra as String?);
        },
      ),
      // TODO figure out a better way for this one
      GoRoute(
        path: ReceiveCryptoScreen.routeName,
        builder: (_, __) => const ReceiveCryptoScreen(),
      ),
      GoRoute(
        path: RevealRecoveryPhraseScreen.routeName,
        builder: (_, __) {
          return RevealRecoveryPhraseScreen(
            shouldRevealKey: (__.extra as bool?) ?? false,
          );
        },
      ), // TODO figure out a better way for this one
      GoRoute(
        path: ChangePasswordScreen.routeName,
        builder: (_, __) => const ChangePasswordScreen(),
      ), // TODO figure out a better way for this one
      GoRoute(
        path: CoinDetailsScreen.routeName,
        builder: (_, state) => const CoinDetailsScreen(),
      ), // TODO figure out a better way for this one
      // GoRoute(
      //   path: AllAccountsScreen.routeName,
      //   builder: (_, __) => const AllAccountsScreen(),
      // ),
      GoRoute(
        path: QrCodeScannerScreen.routeName,
        builder: (_, state) =>
            QrCodeScannerScreen(isCryptoCome: state.extra as bool? ?? false),
      ),
      GoRoute(
        path: DashBoardScreen.routeName,
        builder: (_, __) => const DashBoardScreen(),
      ),
      GoRoute(
        path: DashBoardScreen.routeName,
        builder: (_, __) => const DashBoardScreen(),
      ),
      GoRoute(
        path: PricingPlansScreen.routeName,
        builder: (_, __) => const PricingPlansScreen(),
      ),

      // GoRoute(
      //   path: FetchingQuoteScreen.routeName,
      //   builder: (_, __) => const FetchingQuoteScreen(),
      // ),
      // GoRoute(
      //   path: RampQuoteScreen.routeName,
      //   builder: (_, __) => const RampQuoteScreen(),
      // ),
      GoRoute(
          path: MoonPayWebView.routeName,
          builder: (_, state) =>
              MoonPayWebView(isBuy: state.extra as bool? ?? false)),
    ],
    errorBuilder: (_, __) => const RouteNotFoundScreen(),
  );
}
