import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../all_utills.dart';
import '../../models/response/fetch_all_accounts_response.dart';
import '../home/component/home_widget_component/account_widget.dart';

class ReceiveCryptoScreen extends ConsumerWidget {
  final String? walletAddress;
  static const String routeName = '/ReceiveCryptoScreen';

  const ReceiveCryptoScreen({super.key, this.walletAddress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountIdProvider = ref.watch(currentAccountSelectionProvider);
    return BaseScaffold(
        appBarTitle: 'Receive',
        child: Column(
          children: [
            Gap(32.h),
            SomosContainer(
              padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 32.h),
              borderRadius: AppWidgets.borderRadius * 1.5,
              border: const GradientBoxBorder(
                width: 2.0,
                gradient: LinearGradient(
                  colors: [
                    Color(0xff6552FE),
                    Color(0xff01FFF4),
                    Color(0xff3354F4),
                    Color(0xffE02424),
                    Color(0xffFF7D05)
                  ],
                ),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: AppWidgets.borderRadius,
                    // TODO change the data variable to something dynamic
                    child: accountIdProvider == null
                        ? Text('Failed to Fetch Account Id',
                            style: context.textTheme.bodyLarge)
                        : QrImageView(
                            data: accountIdProvider.address,
                            size: 254.h,
                            backgroundColor: context.theme.hintColor,
                            errorStateBuilder: (cxt, err) {
                              return Center(
                                child: Text(
                                  'Uh oh! Something went wrong...',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.bodyLarge,
                                ),
                              );
                            },
                          ),
                  ),
                  Gap(15.h),
                  accountIdProvider == null
                      ? Text('N/a',
                          style: Theme.of(context).textTheme.bodyLarge)
                      : Text(
                          accountIdProvider.address,
                          maxLines: 2,
                          style: context.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                ],
              ),
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                    child: SomosOutlineIconButton(
                        onPressed: (context) =>
                            sharePressed(context, accountIdProvider))),
                Gap(20.w),
                Expanded(
                  child: SomosOutlineIconButton(
                      onPressed: (context) =>
                          _copyPressed(context, accountIdProvider),
                      title: 'Copy',
                      assetIcon: Assets.icons.copy),
                ),
              ],
            ),
          ],
        ));
  }

  Future<void> sharePressed(BuildContext context, Account? data) async {
    try {
      if (data?.address == null) return;
      final qrImage = await QrPainter(
        data: data?.address ?? '',
        version: QrVersions.auto,
      ).toImageData(500.h);

      if (qrImage == null) {
        Utils.displayToast('Failed to generate QR code image');
        return;
      }

      final temporaryDirectory = await getTemporaryDirectory();
      final file = File('${temporaryDirectory.path}/qrcode.png');
      await file.writeAsBytes(qrImage.buffer.asUint8List());
      final xFile = XFile(file.path);
      await Share.shareXFiles(
        [xFile],
      );
    } on Exception catch (error) {
      Utils.displayToast(error.toString());
    }
  }

  Future<void> shareQRCode(context, data) async {
    final storageStatus = await Permission.storage.status;
    if (Platform.isAndroid &&
        (storageStatus.isDenied || storageStatus.isRestricted)) {
      final permissionResult = await Permission.storage.request();
      if (permissionResult.isGranted) {
        await sharePressed(context, data);
      } else {
        print('Storage permission is required to share QR code.');
      }
    } else {
      await sharePressed(context, data);
    }
  }

  void _copyPressed(BuildContext context, Account? data) async {
    if (data?.address == null) return;
    await Clipboard.setData(ClipboardData(text: data?.address ?? ''));

    Utils.displayToast('Address Copied to Clipboard');
  }
}

class SomosOutlineIconButton extends StatelessWidget {
  final BuildContextCallback onPressed;
  final String? title;
  final String? assetIcon;
  const SomosOutlineIconButton(
      {super.key, required this.onPressed, this.title, this.assetIcon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xff1E1E1E),
        side: const BorderSide(color: Color(0xff1E1E1E)),
        shape: RoundedRectangleBorder(borderRadius: AppWidgets.borderRadius),
      ),
      onPressed: () => onPressed(context),
      icon: SvgPicture.asset(assetIcon ?? Assets.icons.share),
      label: Text(
        title ?? 'Share',
        style: context.textTheme.bodyLarge,
      ),
    );
  }
}
