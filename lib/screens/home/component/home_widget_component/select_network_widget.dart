import 'package:somos_app/all_utills.dart';

import '../../../../models/response/fetch_all_network_response.dart';

class HomeNetworkWidget extends StatelessWidget {
  const HomeNetworkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SomosContainer(
      borderRadius: BorderRadius.circular(37),
      padding: const EdgeInsets.all(6).r,
      color: AppColors.homeDropDownColor,
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final AsyncValue<List<NetworkModel>?> etheriumList =
              ref.watch(networkTypeProvider);
          final selectedNetwork = ref.watch(networkTypeSelectionProvider);

          return etheriumList.when(
            data: (value) {
              _handleNetworkSelection(value, ref);
              return value == null
                  ? Text('No Network Found', style: context.textTheme.bodyLarge)
                  : GestureDetector(
                      onTap: () => _selectedNetworkPressed(context, value),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SomosContainer(
                            width: 20.w,
                            height: 20.h,
                            shape: BoxShape.circle,
                            gradient: AppColors.buttonGradient,
                            alignment: Alignment.center,
                            child: CacheImage(
                              imageUrl: selectedNetwork?.logoUrl ??
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Ethereum_logo_2014.svg/1257px-Ethereum_logo_2014.svg.png',
                              width: 15.w,
                              height: 15.h,
                            ),
                          ),
                          Gap(4.w),
                          Text(
                            selectedNetwork?.name ?? '',
                            style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Gap(4.w),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: AppColors.textColor,
                            size: 16.h,
                          )
                        ],
                      ),
                    );
            },
            error: Utils.buildErrorHandlerWidget,
            loading: Utils.buildLoadingHandlerWidget,
          );
        },
      ),
    );
  }

  void _handleNetworkSelection(networkData, WidgetRef ref) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (networkData != null &&
          networkData.isNotEmpty &&
          ref.read(networkTypeSelectionProvider) == null) {
        final selectedNetwork = networkData.first;

        if (ref.read(networkTypeSelectionProvider) != selectedNetwork) {
          ref.read(networkTypeSelectionProvider.notifier).state =
              selectedNetwork;
        }
      }
    });
  }

  _selectedNetworkPressed(BuildContext context, List<NetworkModel> value) {
    showModelBottomSheet(context, child: CoinDetailBuilder(networkList: value));
  }
}

class CoinDetailBuilder extends ConsumerWidget {
  final List<NetworkModel> networkList;
  const CoinDetailBuilder({super.key, required this.networkList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SomosListViewBuilder(
      shrinkWrap: true,
      spacing: 0,
      items: networkList,
      itemBuilder: (networkData) {
        return networkData is NetworkModel
            ? ListTile(
                onTap: () {
                  ref.read(networkTypeSelectionProvider.notifier).state =
                      networkData;
                  context.pop();
                },
                contentPadding: EdgeInsets.zero,
                leading: CacheImage(
                  imageUrl: networkData.logoUrl,
                  width: 30.w,
                  height: 30.h,
                  boxFit: BoxFit.contain,
                ),
                title: Text(
                  networkData.name,
                  style: context.textTheme.headlineLarge?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor,
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}

final networkTypeProvider =
    FutureProvider.autoDispose<List<NetworkModel>?>((ref) async {
  return (await homeRepository.fetchAllNetwork()).body;
});

final networkTypeSelectionProvider =
    StateProvider.autoDispose<NetworkModel?>((ref) => null);

class BottomSheetTile extends StatelessWidget {
  final BuildContextCallback? onPressed;
  final String? title;
  final bool isImage;
  final String? url;
  final IconData? icon;
  const BottomSheetTile(
      {super.key,
      this.onPressed,
      this.title,
      required this.url,
      this.isImage = false,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed == null ? null : () => onPressed!(context),
      contentPadding: EdgeInsets.zero,
      leading: isImage
          ? SomosContainer(
              width: 40.w,
              shape: BoxShape.circle,
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              height: 40.h,
              gradient: AppColors.buttonGradient,
              child: url == null
                  ? const Icon(Icons.add, color: Colors.white)
                  : SvgPicture.asset(
                      url ?? '',
                      width: 20.w,
                      height: 20.h,
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),
            )
          : SomosContainer(
              width: 40.w,
              height: 40.h,
              shape: BoxShape.circle,
              alignment: Alignment.center,
              gradient: AppColors.buttonGradient,
              child: Icon(icon ?? Icons.add, color: Colors.white),
            ),
      title: Text(
        title ?? 'No Data',
        style: context.textTheme.headlineLarge?.copyWith(fontSize: 18.sp),
      ),
    );
  }
}
