// import '../../all_utills.dart';
// import '../../models/requests/delete_account_request.dart';
// import '../../models/response/fetch_all_accounts_response.dart';
//
// class AllAccountsScreen extends ConsumerWidget {
//   static const String routeName = '/WalletsScreen';
//
//   const AllAccountsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return BaseScaffold(
//       appBarTitle: 'Wallets',
//       child: accounts.when(
//         skipLoadingOnRefresh: false,
//         data: (_) => _buildAccountsListView(context, _),
//         error: Utils.buildErrorHandlerWidget,
//         loading: Utils.buildLoadingHandlerWidget,
//       ),
//     );
//   }
//
//   Widget _buildAccountsListView(BuildContext context, ApiResponse response) {
//     return Column(
//       children: [
//         Gap(32.h),
//         SomosListViewBuilder(
//           items: response.body,
//           itemBuilder: _itemBuilder,
//           separationWidget: Divider(
//             thickness: 0.5,
//             color: context.theme.highlightColor,
//           ),
//         ),
//         Gap(16.h),
//         SomosElevatedButton(
//           title: 'Import New Wallet',
//           onPressed: (context) async => dummyPendingOnPressed(),
//         ),
//         Gap(16.h),
//       ],
//     );
//   }
//
//   _itemBuilder(account) => _AccountWidget(account: account);
// }
//
// class _AccountWidget extends StatelessWidget {
//   const _AccountWidget({required this.account});
//
//   final Account account;
//
//   @override
//   Widget build(BuildContext context) {
//     const imageUrl =
//         'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Ethereum_logo_2014.svg/1257px-Ethereum_logo_2014.svg.png';
//
//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
//       leading: CacheImage(width: 32.w, height: 40.h, imageUrl: imageUrl),
//       title: Text(
//         account.name,
//         style: context.textTheme.bodyLarge,
//       ),
//       subtitle: Text(
//         account.address,
//         style: context.textTheme.bodyMedium?.copyWith(
//           color: context.theme.highlightColor,
//         ),
//         overflow: TextOverflow.ellipsis,
//       ),
//       trailing: PopupMenuButton(
//         icon: SvgPicture.asset(Assets.icons.moreVert),
//         itemBuilder: (_) => [
//           PopupMenuItem(
//             onTap: _onEditPressed,
//             child: const Text('Edit'),
//           ),
//           PopupMenuItem(
//             onTap: _onDeletePressed,
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _onEditPressed() => dummyPendingOnPressed();
//
//   void _onDeletePressed() async {
//     final request = DeleteAccountRequest(accountAddress: account.address);
//
//     String? message;
//
//     try {
//       final response = await homeRepository.removeAccount(request);
//
//       message = response.message;
//     } on ApiError catch (e) {
//       message = e.message;
//     }
//
//     Utils.displayToast(message);
//   }
// }
