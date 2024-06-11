import 'package:somos_app/all_utills.dart';
import 'package:somos_app/models/response/fetch_all_accounts_response.dart';

final allAccountsProvider =
    FutureProvider.autoDispose<List<Account>?>((ref) async {
  return (await homeRepository.fetchAllAccount()).body;
});
final currentAccountSelectionProvider =
    StateProvider.autoDispose<Account?>((ref) => null);

class AccountWidget extends ConsumerStatefulWidget {
  const AccountWidget({super.key});

  @override
  ConsumerState<AccountWidget> createState() => _AccountDisplayWidgetState();
}

class _AccountDisplayWidgetState extends ConsumerState<AccountWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final accounts = ref.watch(allAccountsProvider);
    final selectionAccount = ref.watch(currentAccountSelectionProvider);
    return SomosContainer(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      borderRadius: BorderRadius.circular(16),
      border: const GradientBoxBorder(gradient: AppColors.buttonGradient),
      child: Column(
        children: [
          accounts.when(
            data: (value) {
              final accountsData = value;
              if (value == null)
                return const Text('SomeThing Happen Account Null');
              _handleAccountSelection(accountsData, ref);

              return AddressTileWidget(
                onTapPressed: (context) => _onAccountPressed(context, value),
                accountTile: selectionAccount?.name ?? 'No Data',
                trailingIcon: Icons.keyboard_arrow_down_sharp,
              );
            },
            error: Utils.buildErrorHandlerWidget,
            loading: Utils.buildLoadingHandlerWidget,
          ),
          const Divider(),
          AddressTileWidget(
            titleWidget: AddressCopyWidget(address: selectionAccount?.address),
          ),
        ],
      ),
    );
  }

  void _onAccountPressed(BuildContext context, List<Account> account) {
    showModelBottomSheet(
        title: 'Select an account',
        context,
        child: AccountDetailBottomSheet(account: account));
  }

  void _handleAccountSelection(List<Account>? accountsData, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (accountsData != null && accountsData.isNotEmpty) {
        ref.read(currentAccountSelectionProvider.notifier).state =
            accountsData.first;
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class AddressCopyWidget extends StatelessWidget {
  final String? address;
  const AddressCopyWidget({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Address:',
          style: context.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        Gap(8.w),
        SomosContainer(
          onPressed: (context) => _onCopyPressed(context, address),
          borderRadius: AppWidgets.borderRadius,
          padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
          color: const Color.fromRGBO(101, 82, 254, 0.60).withOpacity(0.3),
          child: FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  truncateWithEllipsis(address, 20),
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.w),
                const Icon(Icons.copy),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void _onCopyPressed(BuildContext context, String? address) async {
  if (address == null) return;
  await Clipboard.setData(ClipboardData(text: address));

  Utils.displayToast('Address Copied to Clipboard');
}

class AddressTileWidget extends StatelessWidget {
  final IconData? trailingIcon;
  final BuildContextCallback? onTapPressed;
  final String? accountTile;
  final Widget? titleWidget;
  const AddressTileWidget(
      {super.key,
      this.titleWidget,
      this.trailingIcon,
      this.accountTile,
      this.onTapPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTapPressed == null ? null : () => onTapPressed!(context),
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.zero,
      title: titleWidget ??
          Text(
            accountTile ?? 'Account 1',
            style: context.textTheme.bodyLarge,
          ),
      // trailing: Icon(
      //   trailingIcon ?? Icons.more_vert,
      //   color: AppColors.textColor,
      //   size: 20.h,
      // ),
    );
  }
}

class AccountDetailBottomSheet extends ConsumerWidget {
  final List<Account> account;
  const AccountDetailBottomSheet({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SomosListViewBuilder(
      shrinkWrap: true,
      spacing: 0,
      items: account,
      itemBuilder: (account) {
        return account is Account
            ? ListTile(
                onTap: () {
                  ref.read(currentAccountSelectionProvider.notifier).state =
                      account;
                  context.pop();
                },
                contentPadding: EdgeInsets.zero,
                leading: CacheImage(
                  imageUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Ethereum_logo_2014.svg/1257px-Ethereum_logo_2014.svg.png',
                  width: 30.w,
                  height: 30.h,
                  boxFit: BoxFit.contain,
                ),
                title: Text(
                  account.name,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.backgroundColor,
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}

String truncateWithEllipsis(String? text, int maxLength) {
  if (text == null) {
    return '0x1F8B...d8f6';
  }

  if (text.length <= maxLength) {
    return text;
  }
  return '${text.substring(0, maxLength)}...';
}
