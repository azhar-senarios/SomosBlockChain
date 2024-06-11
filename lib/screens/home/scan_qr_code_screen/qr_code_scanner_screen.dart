import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../all_screen.dart';
import '../../../all_utills.dart';

final qrResultProvider = StateProvider.autoDispose<Barcode?>((ref) => null);
final qrController = StateProvider<QRViewController?>((ref) => null);

class QrCodeScannerScreen extends ConsumerWidget {
  final bool isCryptoCome;
  static const String routeName = '/QrCodeScannerScreen';

  const QrCodeScannerScreen({super.key, this.isCryptoCome = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanningCode = ref.watch(qrResultProvider);

    ref.listen(qrResultProvider, (previous, next) {
      if (next?.code != null) {
        bool isCome = true;
        if (isCryptoCome && isCome) {
          context.popUntilPath(DashBoardScreen.routeName);
          context.push(SendCryptoScreen.routeName, extra: next?.code);
          isCome = false;
        } else {
          context.pushReplacement(SendCryptoScreen.routeName,
              extra: next?.code);
          isCome = false;
        }
      }
    });
    return BaseScaffold(
      appBarTitle: 'Scan QR Code',
      child: Column(
        children: [
          Gap(65.h),
          SizedBox(
              height: 0.4.sh,
              width: 0.85.sw,
              child: const QrCodeScannerWidget()),
          scanningCode != null ? Gap(30.h) : const SizedBox(),
          scanningCode != null
              ? SomosElevatedButton(
                  size: Size(0.5.sw, 40.h),
                  title: 'ReScan',
                  onPressed: (ctx) => reScanPressed(context, ref))
              : const SizedBox(),
          Gap(30.h),
          Text(
              scanningCode == null
                  ? 'Scanning code...'
                  : scanningCode.code ?? 'No Data',
              style: context.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Future<void> reScanPressed(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(qrController.notifier).state;
    if (controller != null) {
      await controller.resumeCamera();
    }
    ref.read(qrResultProvider.notifier).state = null;
  }
}

class QrCodeScannerWidget extends StatefulWidget {
  const QrCodeScannerWidget({super.key});

  @override
  State<QrCodeScannerWidget> createState() => _QrCodeScannerWidgetState();
}

class _QrCodeScannerWidgetState extends State<QrCodeScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return QRView(
          key: qrKey,
          onQRViewCreated: (controller) => _onQRViewCreated(controller, ref),
          overlay: QrScannerOverlayShape(
            borderColor: Colors.white,
            borderWidth: 10,
            borderLength: 40,
            cutOutWidth: 1.sw,
            cutOutHeight: 0.4.sh,
          ),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller, WidgetRef ref) {
    ref.read(qrController.notifier).state = controller;
    controller.scannedDataStream.listen((scanData) async {
      ref.read(qrResultProvider.notifier).state = scanData;
      await controller.pauseCamera();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
