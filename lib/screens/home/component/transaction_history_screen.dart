import 'package:intl/intl.dart';
import 'package:somos_app/screens/home/component/home_widget_component/account_widget.dart';

import '../../../all_utills.dart';
import '../../../models/requests/request_transcation_request.dart';
import '../../../models/response/transcation_response.dart';

final transcationHistoryProvider =
    FutureProvider.autoDispose<List<Transaction>?>((ref) async {
  final account = ref.watch(currentAccountSelectionProvider);
  if (account == null) return null;
  final data = (await homeRepository.fetchTranscationHistory(
          RequestTranscationHistory(accountAddress: account.address)))
      .body;
  print(data);
  return data;
});

class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transcationHistory = ref.watch(transcationHistoryProvider);

    return BaseScaffold(
        showLeading: false,
        appBarTitle: AppTexts.transactionHistory,
        child: transcationHistory.when(
            data: (value) {
              return value == null || value.isEmpty
                  ? const NoHistoryTransctionWidget()
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.refresh(transcationHistoryProvider.future),
                      child: SomosListViewBuilder(
                        padding: EdgeInsets.only(top: 32.h),
                        withExpanded: false,
                        items: value,
                        itemBuilder: (entry) => _itemBuilder(context, entry),
                      ),
                    );
            },
            error: Utils.buildErrorHandlerWidget,
            loading: Utils.buildLoadingHandlerWidget));
  }

  _itemBuilder(
    BuildContext context,
    Transaction entry,
  ) {
    return TransactionHistoryWidget(transaction: entry);
  }
}

class TransactionHistoryWidget extends StatelessWidget {
  const TransactionHistoryWidget({
    super.key,
    required this.transaction,
    this.showDivider = false,
  });

  final Transaction transaction;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          visualDensity: const VisualDensity(vertical: -2),
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: transaction.txnType.toLowerCase() == 'SEND'.toLowerCase()
              ? SvgPicture.asset(Assets.icons.transactionSent)
              : SvgPicture.asset(Assets.icons.transactionRecieved),
          title: Text(
              '${transaction.txnType} ${transaction.chainType.toString().capitalize()}',
              style: context.textTheme.bodyLarge),
          subtitle: Text(transaction.createdAt.toString().formattedDateWithDash,
              style: context.textTheme.bodyMedium),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                transaction.amount,
                style: context.textTheme.bodyMedium,
              ),
              Text(
                transaction.chainType.capitalize(),
                style: context.textTheme.bodyLarge
                    ?.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

extension DateStringExtension on String {
  String get formattedDateWithDash {
    try {
      DateTime date = DateTime.parse(this).toLocal();
      String formatted = DateFormat('MMMM d yyyy, h:mm a').format(date);
      return formatted.replaceFirst(',', ' -');
    } catch (e) {
      return 'Invalid date';
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime applyDate(DateTime date) =>
      DateTime(date.year, date.month, date.day, hour, minute);
  DateTime applyTime(TimeOfDay time) =>
      DateTime(year, month, day, time.hour, time.minute);
  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);
  DateTime get dateOnly => DateTime(year, month, day);
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

class NoHistoryTransctionWidget extends StatelessWidget {
  const NoHistoryTransctionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/icons/no_transcation.svg'),
        const VerticalSpacing(of: 40),
        Text(
          'No Transactions Yet',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontSize: 25.sp),
        ),
        const VerticalSpacing(of: 12),
        Text(
          'Start transacting with your wallet. All your transactions made will be displayed here.',
          textAlign: TextAlign.center,
          style:
              Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16.sp),
        ),
      ],
    );
  }
}
