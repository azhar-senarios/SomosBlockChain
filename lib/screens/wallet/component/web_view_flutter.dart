import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:somos_app/all_utills.dart';
import 'package:somos_app/screens/home/component/home_screen.dart';
import 'package:somos_app/screens/home/component/home_widget_component/account_widget.dart';
import 'package:somos_app/screens/home/component/home_widget_component/select_network_widget.dart';

import '../../../services/remote_config.dart';

class MoonPayWebView extends ConsumerStatefulWidget {
  final bool isBuy;
  static const String routeName = '/MoonPayWebView';

  const MoonPayWebView({super.key, this.isBuy = true});

  @override
  ConsumerState createState() => _MoonPayWebViewState();
}

class _MoonPayWebViewState extends ConsumerState<MoonPayWebView> {
  bool isLoading = true;
  late InAppWebViewController webViewController;
  String buyMoonPay({
    String baseCurrencyCode = 'usd',
    required String token,
    bool isLive = false,
    String url = 'https://buy-sandbox.moonpay.com',
    String walletAddress = '0x2a0db32b212f81ea1db276d757941773ad3ecb38',
    String defaultCurrencyCode = 'ETH',
  }) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoonPay Integration</title>
    <script defer src="https://static.moonpay.com/web-sdk/v1/moonpay-web-sdk.min.js"></script>
    <style>
        body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden; /* Prevent scrolling */
        }
        #widget-container {
            width: 100%;
            height: 100%;
            background-color: transparent;
            display: flex;
            justify-content: center;
            align-items: center;
            border: none; /* Remove border */
        }
        #loading {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .spinner {
            border: 3px solid transparent; /* Transparent border */
            border-top: 3px solid #7d00ff; /* MoonPay purple */
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div id="widget-container"></div>
    <div id="loading"><div class="spinner"></div></div>
    <script>
        window.onload = async function() {
            try {
                console.log('Window loaded, initializing MoonPay SDK.');
                const moonPay = window.MoonPayWebSdk.init;
                if (!moonPay) {
                    throw new Error("MoonPay SDK not loaded properly or init function is not available");
                }
                console.log('MoonPay SDK initialized successfully.');

                const token = '$token';
                const baseCurrencyCode = '$baseCurrencyCode';
                const defaultCurrencyCode = '$defaultCurrencyCode';
                const walletAddress = '$walletAddress';
                const isLive = $isLive === 'true';

                const moonPayWidget = moonPay({
                    flow: "buy",
                    environment: isLive ? "":"sandbox",
                    params: {
                        apiKey: isLive ? '',
                        baseCurrencyCode: baseCurrencyCode,
                        defaultCurrencyCode: defaultCurrencyCode,
                        walletAddress: walletAddress
                    },
                    variant: "embedded",
                    containerNodeSelector: "#widget-container",
                    useWarnBeforeRefresh: false,
                    handlers: {
                        async onTransactionCompleted(props) {
                            window.flutter_inappwebview.callHandler('success', 'Successfully Transcation');
                            console.log("Transaction Completed", props);
                        },
                        onCloseOverlay: function() {
                            window.flutter_inappwebview.callHandler('closeOverlay');
                        }
                    },
                });

                if (!moonPayWidget) {
                    throw new Error("Failed to create the MoonPay widget");
                }

                console.log('MoonPay widget created successfully.');

                document.getElementById('loading').style.display = 'flex'; // Show spinner

                const apiUrl = 'https://api.somosblockchain.com/sign-url';
                const requestBody = {
                    url: moonPayWidget.generateUrlForSigning(),
                };
                console.log('Api Request Body', requestBody);

                const response = await fetch(apiUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'x-auth-token': token,
                    },
                    body: JSON.stringify(requestBody),
                });

                if (!response.ok) {
                    throw new Error('Failed to load data');
                }

                const responseData = await response.json();
                console.log('API call successful:', responseData.data.signature);

                moonPayWidget.updateSignature(responseData.data.signature);
                moonPayWidget.show();

                document.getElementById('loading').style.display = 'none'; // Hide spinner on success
            } catch (e) {
                console.error('Error:', e.message);
                window.flutter_inappwebview.callHandler('displayError', e.message);
                document.getElementById('loading').style.display = 'none'; // Hide spinner on error
            }
        };
    </script>
</body>
</html>
''';
  }

  String sellMoonPay({
    String baseCurrencyCode = 'eth',
    bool isLive = false,
    String quoteCurrencyCode = 'usd',
    String networkName = 'Sepolia',
    required String token,
    // String baseCurrencyAmount = '0.01',
    String walletAddress = '0x13eEbB659bE68c5758D25DE9795f12EB1699C58B',
  }) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MoonPay Integration</title>
  <script defer src="https://static.moonpay.com/web-sdk/v1/moonpay-web-sdk.min.js"></script>
  <style>
     body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden; /* Prevent scrolling */
        }
        #widget-container {
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            border: none; /* Remove border */
        }
    #loading {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    .spinner {
      border-radius: 50%;
      border-top: 3px solid #7d00ff; /* MoonPay purple */
      width: 30px;
      height: 30px;
      animation: spin 1s linear infinite;
    }
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
  </style>
</head>
<body>
    <div id="widget-container"></div>
  <div id="loading"><div class="spinner"></div></div>
  <script>
    window.onload = function() {
      const token = '$token';
        const isLive = $isLive === 'true';


      try {
        const moonPayInit = window.MoonPayWebSdk?.init;
        if (moonPayInit) {
          const widget = moonPayInit({
            flow: "sell",
            environment: isLive ? "production":"sandbox",
            params: {
              apiKey: isLive ? "",
              baseCurrencyCode: '$baseCurrencyCode',
              quoteCurrencyCode: '$quoteCurrencyCode',
              refundWalletAddress: '$walletAddress',
            },
             variant: "embedded",
             containerNodeSelector: "#widget-container",
            handlers: {
              async onInitiateDeposit(props) {
                document.getElementById('loading').style.display = 'flex'; // Show spinner

                try {
                  const apiData = {
                    cryptoCurrency: '$baseCurrencyCode',
                    cryptoCurrencyAmount: props.cryptoCurrencyAmount,
                    depositWalletAddress: props.depositWalletAddress,
                    sellerAddress: '$walletAddress',
                    networkName: '$networkName',
                  };

                  const headers = {
                    'Content-Type': 'application/json',
                    'x-auth-token': token,
                  };

                  const response = await fetch('http://api.somosblockchain.com/on-initiate-deposit', {
                    method: 'POST',
                    headers: headers,
                    body: JSON.stringify(apiData),
                  });

                  const responseData = await response.json();
                  if (!response.ok) {
                    throw new Error(responseData.message || "Unknown error");
                  }

                  window.flutter_inappwebview.callHandler('success', 'Successfully Transaction');
                  document.getElementById('loading').style.display = 'none'; // Hide spinner on success

                  return { depositId: responseData.data.txHash };

                } catch (error) {
                  window.flutter_inappwebview.callHandler('displayError', error.message);
                  document.getElementById('loading').style.display = 'none'; // Hide spinner on error
                }
              },
              onCloseOverlay: function() {
                document.getElementById('loading').style.display = 'none'; // Ensure spinner is hidden when overlay is closed
                window.flutter_inappwebview.callHandler('closeOverlay');
              },
            },
          });

          if (!widget) {
            throw new Error('Failed to create the MoonPay widget');
          }
          widget.show();
        } else {
          throw new Error('MoonPay SDK not loaded properly or init function is not available');
        }
      } catch (e) {
        window.flutter_inappwebview.callHandler('displayError', e.message);
      }
    };
  </script>
</body>
</html>
  ''';
  }

  @override
  Widget build(BuildContext context) {
    final currentSelectionCurrency = ref.watch(amountCurrencySelectionProvider);
    final networkAccountSelection = ref.watch(networkTypeSelectionProvider);
    final currentWalletAddress = ref.watch(selectedNetworkDetailProvider);

    return BaseScaffold(
        showAppBar: false,
        scaffoldPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InAppWebView(
              initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true, transparentBackground: true),
              initialData: InAppWebViewInitialData(
                data: widget.isBuy
                    ? buyMoonPay(
                        baseCurrencyCode:
                            currentSelectionCurrency.shortForm.toLowerCase(),
                        token: storage.authenticationToken ?? '',
                        isLive: RemoteConfigManager.instance.isLive,
                        walletAddress: currentWalletAddress?.address ??
                            '0x2a0db32b212f81ea1db276d757941773ad3ecb38',
                        defaultCurrencyCode:
                            networkAccountSelection?.currency ?? 'eth')
                    : sellMoonPay(
                        token: storage.authenticationToken ?? '',
                        isLive: RemoteConfigManager.instance.isLive,
                        quoteCurrencyCode:
                            currentSelectionCurrency.shortForm.toLowerCase(),
                        walletAddress: currentWalletAddress?.address ??
                            '0x13eEbB659bE68c5758D25DE9795f12EB1699C58B',
                        networkName: currentWalletAddress?.network ?? 'Sepolia',
                        baseCurrencyCode:
                            networkAccountSelection?.currency ?? 'eth'),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
                controller.addJavaScriptHandler(
                    handlerName: 'closeOverlay',
                    callback: (args) {
                      Navigator.pop(context);
                    });
                controller.addJavaScriptHandler(
                    handlerName: 'displayError',
                    callback: (args) {
                      Utils.displayToast(args.toString());
                    });
                controller.addJavaScriptHandler(
                    handlerName: 'success',
                    callback: (args) {
                      ref.invalidate(allAccountsProvider);
                      ref.invalidate(coinDetailProvider);
                      ref.invalidate(networkTypeProvider);
                    });
              },
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  isLoading = false;
                });
              },
              onReceivedError: (controller, request, error) {
                // context.pop();
                print('Error loading ${request.url}: ${error.description}');
              },
              onConsoleMessage: (controller, consoleMessage) {
                print('Console message: ${consoleMessage.message}');
              },
              onReceivedHttpError: (controller, request, response) {
                // context.pop();
                print(
                    'HTTP error for ${request.url}: ${response.statusCode} ${response.reasonPhrase}');
              },
            ),
            isLoading
                ? Utils.buildLoadingHandlerWidget()
                : const SizedBox.shrink()
          ],
        ));
  }
}
// baseCurrencyAmount: '$baseCurrencyAmount',
// baseCurrencyAmount: userTypeAmount,

// baseCurrencyAmount: baseCurrencyAmount,
