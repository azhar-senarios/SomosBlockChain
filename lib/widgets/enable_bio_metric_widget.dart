import '../all_utills.dart';

class BioMetricState {
  static final localAuth = LocalAuthentication();

  final bool isDeviceSupported;
  final bool isBiometricEnabled;

  BioMetricState({
    required this.isDeviceSupported,
    required this.isBiometricEnabled,
  });

  BioMetricState copyWith({
    bool? isDeviceSupported,
    bool? isBiometricEnabled,
  }) {
    return BioMetricState(
      isDeviceSupported: isDeviceSupported ?? this.isDeviceSupported,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}

class BioMetricStateNotifier extends AsyncNotifier<BioMetricState> {
  @override
  FutureOr<BioMetricState> build() async {
    final supported = await _isBioMetricSupported();

    const enabled = true;

    return BioMetricState(
      isDeviceSupported: supported,
      isBiometricEnabled: enabled,
    );
  }

  void toggleBioMetricAuthentication(bool status,
      {bool isStoreLocalStorage = false}) async {
    state = AsyncValue.data(state.value!.copyWith(isBiometricEnabled: status));

    if (isStoreLocalStorage) await storage.setBiometric(status);
  }

  Future<bool> _isBioMetricSupported() async {
    return await LocalAuthentication().isDeviceSupported();
  }


  void reset() async {
    final isDeviceSupported = await _isBioMetricSupported();

    state = AsyncValue.data(state.value!.copyWith(
        isBiometricEnabled: true, isDeviceSupported: isDeviceSupported));
  }
}

final bioMetricStateProvider =
    AsyncNotifierProvider<BioMetricStateNotifier, BioMetricState>(
  () => BioMetricStateNotifier(),
);

class EnableBioMetricAuthenticationWidget extends ConsumerWidget {
  const EnableBioMetricAuthenticationWidget(
      {super.key,
      this.shouldAuthenticate = false,
      this.getValueFromLocalStorage = false,
      this.isStoreLocalStorage = false});

  final bool shouldAuthenticate;
  final bool getValueFromLocalStorage;
  final bool isStoreLocalStorage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bioMetricStateProvider);

    final enableBioMetric = getValueFromLocalStorage
        ? storage.isBiometric
        : state.value?.isBiometricEnabled ?? true;

    final isBioMetricSupported = state.value?.isDeviceSupported ?? false;

    if (!isBioMetricSupported) return const SizedBox.shrink();

    return Row(
      children: [
        Text(
          AppTexts.enableBioMetricLogin,
          style: context.textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        Switch.adaptive(
          value: enableBioMetric,
          onChanged: (val) => _onChanged(ref, val),
          inactiveTrackColor: context.theme.highlightColor,
          inactiveThumbColor: context.theme.hintColor,
          activeColor: Platform.isIOS ? context.theme.primaryColor : null,
        ),
      ],
    );
  }

  void _onChanged(WidgetRef ref, bool value) async {
    if (shouldAuthenticate) {
      if (storage.isBiometric) {
        final hasAuthenticated = await Utils.verifyBioMetricAuthentication();

        if (!hasAuthenticated) return;
      }
    }

    ref.read(bioMetricStateProvider.notifier).toggleBioMetricAuthentication(
        value,
        isStoreLocalStorage: isStoreLocalStorage);
  }
}
