import 'package:car_care/controllers/wallet_controller.dart';
import 'package:car_care/views/base/custom_button.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:car_care/views/base/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  static const String _kDefaultCardIndex = 'wallet_default_card_index';
  static const String _kAutoTopUpEnabled = 'wallet_auto_topup_enabled';
  static const String _kAutoTopUpThreshold = 'wallet_auto_topup_threshold';
  static const String _kTransactionAlerts = 'wallet_transaction_alerts';
  static const String _kSavingsAutoDebit = 'wallet_savings_auto_debit';
  static const String _kExportFormat = 'wallet_export_format';

  final WalletController _walletCtrl = Get.put(WalletController());

  int _defaultCardIndex = 0;
  bool _autoTopUpEnabled = false;
  int _autoTopUpThreshold = 50;
  bool _transactionAlertsEnabled = true;
  bool _savingsAutoDebitEnabled = true;
  String _exportFormat = 'PDF';
  final List<Map<String, String>> _cards = [
    {'brand': 'Visa', 'last4': '4242', 'expires': '12/2026', 'color': '3A7BFF'},
    {
      'brand': 'Mastercard',
      'last4': '8888',
      'expires': '06/2027',
      'color': 'F35A47',
    },
  ];

  final List<Map<String, String>> _transactions = const [
    {
      'title': 'Oil Change Service',
      'meta': "Jay's Smart Garage · Dec 20",
      'amount': '-49.99',
      'points': '+125',
      'type': 'debit',
    },
    {
      'title': 'Car Savings Deposit',
      'meta': 'Auto-save · Dec 16',
      'amount': '+20.00',
      'points': '+35',
      'type': 'credit',
    },
    {
      'title': 'Brake Inspection',
      'meta': 'AutoCare Plus · Dec 10',
      'amount': '-35.00',
      'points': '+88',
      'type': 'debit',
    },
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      _walletCtrl.getBalance();
      _walletCtrl.getMyEarnPoint();
      _loadWalletSettings();
    });
    super.initState();

  }

  bool get _isDark => Get.isDarkMode;
  Color get _panelColor =>
      _isDark ? const Color(0xB01A2433) : Colors.white.withValues(alpha: 0.95);
  Color get _tileColor =>
      _isDark ? const Color(0x77232D3D) : const Color(0xFFF5F7FC);
  Color get _titleIconColor => _isDark ? Colors.white : const Color(0xFF1E2A3C);
  Color get _secondaryTextColor =>
      _isDark ? const Color(0xFFB7C3DB) : const Color(0xFF667085);
  Color get _debitAmountColor =>
      _isDark ? Colors.white : const Color(0xFF1B2433);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF090E17) : Get.theme.scaffoldBackgroundColor,
      bottomNavigationBar: const BottomMenu(4),
      body: Stack(
        children: [
          Positioned(
            top: -110,
            right: -80,
            child: _bgGlow(const Color(0x22F08E2F), 250),
          ),
          Positioned(
            top: 220,
            left: -90,
            child: _bgGlow(const Color(0x226A1838), 230),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(context),
                  const SizedBox(height: 12),
                  _balanceHero(),
                  const SizedBox(height: 12),
                  _quickActions(),
                  const SizedBox(height: 12),
                  _paymentMethodsSection(),
                  const SizedBox(height: 12),
                  _savingsVaultSection(),
                  const SizedBox(height: 12),
                  _transactionsSection(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        // _circleTopButton(
        //   icon: Icons.arrow_back_ios_new_rounded,
        //   onTap: NavigationHelper.backOrHome,
        // ),
        Text('Wallet', style: AppStyles.h2(fontFamily: 'InterBold')),
        _circleTopButton(
          icon: Icons.settings_outlined,
          onTap: _openWalletSettingsSheet,
        ),
      ],
    );
  }

  Widget _circleTopButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool isDark = Get.isDarkMode;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isDark
                  ? const Color(0xFF1A2332).withValues(alpha: 0.90)
                  : Colors.white.withValues(alpha: 0.88),
          border: Border.all(
            color: AppColors.borderColor.withValues(alpha: 0.5),
          ),
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : const Color(0xFF1B2333),
          size: 20,
        ),
      ),
    );
  }

  Widget _balanceHero() {
    return Obx(() {
      if (_walletCtrl.balanceLoading.value) {
        return Container(
          width: double.infinity,
          height: 164,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(colors: AppColors.brandGradient),
          ),
          child: const Center(child: CustomPageLoading()),
        );
      }

      final balance = _walletCtrl.walletModel.value?.balance ?? 0;
      final points = _walletCtrl.myPoints.value;
      final currency =
          (_walletCtrl.walletModel.value?.currency.isNotEmpty ?? false)
              ? _walletCtrl.walletModel.value!.currency
              : 'CAD';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: AppColors.brandGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPrimary.withValues(alpha: 0.26),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AVAILABLE BALANCE',
              style: AppStyles.h6(
                color: Colors.white.withValues(alpha: 0.9),
                fontFamily: 'InterSemiBold',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${NumberFormat.simpleCurrency(name: currency).currencySymbol}${balance.toStringAsFixed(2)}',
              style: AppStyles.customSize(
                size: 42,
                color: Colors.white,
                fontFamily: 'InterBold',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '+$points Torqon points',
              style: AppStyles.h5(color: Colors.white.withValues(alpha: 0.92)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _heroChip('Secure'),
                const SizedBox(width: 8),
                _heroChip('Instant Top-up'),
                const SizedBox(width: 8),
                _heroChip('Auto-save'),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _heroChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        style: AppStyles.customSize(
          size: 10,
          color: Colors.white,
          fontFamily: 'InterSemiBold',
        ),
      ),
    );
  }

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _actionCard(
            icon: Icons.add_card_rounded,
            title: 'Add Card',
            subtitle: 'Link payment',
            onTap: () {
              Get.snackbar(
                'Add Card',
                'Card linking flow will be enabled in the next update.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _actionCard(
            icon: Icons.savings_outlined,
            title: 'Car Savings',
            subtitle: 'Manage vault',
            onTap: () => Get.toNamed(AppRoutes.carSavingScreen),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _actionCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Add Funds',
            subtitle: 'Recharge',
            onTap: () => _showRechargeDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        color: _panelColor,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: AppColors.brandGradient),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.h6(fontFamily: 'InterSemiBold'),
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              style: AppStyles.customSize(size: 10, color: _secondaryTextColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodsSection() {
    return GlassContainer(
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(14),
      color: _panelColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card_rounded, color: _titleIconColor),
              const SizedBox(width: 8),
              Text(
                'Payment Methods',
                style: AppStyles.h3(fontFamily: 'InterSemiBold'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._cards.asMap().entries.map((entry) {
            final i = entry.key;
            final card = entry.value;
            return _cardRow(
              index: i,
              brand: card['brand']!,
              last4: card['last4']!,
              expires: card['expires']!,
              colorHex: card['color']!,
            );
          }),
          const SizedBox(height: 12),
          Text(
            'Digital Wallets',
            style: AppStyles.h4(fontFamily: 'InterSemiBold'),
          ),
          const SizedBox(height: 10),
          _digitalWalletRow(
            title: 'Apple Pay',
            status: 'Available',
            logoBg: Colors.black,
            logoIcon: Icons.phone_iphone_rounded,
            actionText: 'Set Up',
          ),
          const SizedBox(height: 8),
          _digitalWalletRow(
            title: 'Google Pay',
            status: 'Available',
            logoBg: const Color(0xFF233A8F),
            logoIcon: Icons.account_balance_wallet_rounded,
            actionText: 'Set Up',
          ),
        ],
      ),
    );
  }

  Widget _cardRow({
    required int index,
    required String brand,
    required String last4,
    required String expires,
    required String colorHex,
  }) {
    final bool isDefault = index == _defaultCardIndex;
    final Color accent = Color(int.parse('0xFF$colorHex'));

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: _tileColor,
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: accent.withValues(alpha: 0.14),
            ),
            child: Icon(Icons.credit_card_rounded, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '$brand •••• $last4',
                        style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: AppColors.brandPrimary,
                        ),
                        child: Text(
                          'Default',
                          style: AppStyles.customSize(
                            size: 10,
                            color: Colors.white,
                            fontFamily: 'InterSemiBold',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Expires $expires',
                  style: AppStyles.h6(color: Get.textTheme.bodyMedium!.color),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            color: _isDark ? const Color(0xFF202938) : Colors.white,
            onSelected: (value) {
              if (value == 'default') {
                setState(() => _defaultCardIndex = index);
                _persistWalletSettings();
                Get.snackbar(
                  'Updated',
                  'Default card changed.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else if (value == 'remove') {
                if (_cards.length == 1) {
                  Get.snackbar(
                    'Blocked',
                    'At least one card is required.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                setState(() {
                  _cards.removeAt(index);
                  if (_defaultCardIndex >= _cards.length) {
                    _defaultCardIndex = _cards.length - 1;
                  }
                });
                _persistWalletSettings();
                Get.snackbar(
                  'Removed',
                  'Card removed from wallet.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            itemBuilder:
                (_) => [
                  const PopupMenuItem(
                    value: 'default',
                    child: Text('Set as default'),
                  ),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Text('Remove card'),
                  ),
                ],
            child: Icon(
              Icons.more_vert_rounded,
              color: _isDark ? Colors.white70 : const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  Widget _digitalWalletRow({
    required String title,
    required String status,
    required Color logoBg,
    required IconData logoIcon,
    required String actionText,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: _tileColor,
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: logoBg,
            ),
            child: Icon(logoIcon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.h4(fontFamily: 'InterSemiBold')),
                Text(
                  status,
                  style: AppStyles.h6(color: const Color(0xFF37D07D)),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Get.snackbar(
                title,
                '$title setup will be available soon.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppColors.brandPrimary.withValues(alpha: 0.8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              actionText,
              style: AppStyles.h6(
                color: AppColors.brandHighlight,
                fontFamily: 'InterSemiBold',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _savingsVaultSection() {
    return GlassContainer(
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(14),
      color: _panelColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.savings_outlined, color: _titleIconColor),
              const SizedBox(width: 8),
              Text(
                'Car Savings Vault',
                style: AppStyles.h3(fontFamily: 'InterSemiBold'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: _tileColor,
              border: Border.all(
                color: AppColors.borderColor.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2023 Honda Civic',
                        style: AppStyles.h3(fontFamily: 'InterSemiBold'),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$20/week · Next: Dec 30',
                        style: AppStyles.h5(color: _secondaryTextColor),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$156.00',
                  style: AppStyles.h2(
                    color: const Color(0xFF12B76A),
                    fontFamily: 'InterBold',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.toNamed(AppRoutes.carSavingScreen),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.brandPrimary.withValues(alpha: 0.9),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: Text(
                'Manage Savings Plans',
                style: AppStyles.h4(
                  color: AppColors.brandPrimary,
                  fontFamily: 'InterSemiBold',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionsSection() {
    return GlassContainer(
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(14),
      color: _panelColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions',
            style: AppStyles.h3(fontFamily: 'InterSemiBold'),
          ),
          const SizedBox(height: 6),
          ..._transactions.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final bool isCredit = item['type'] == 'credit';
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        index == _transactions.length - 1
                            ? Colors.transparent
                            : AppColors.borderColor.withValues(alpha: 0.35),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['meta']!,
                          style: AppStyles.h6(color: _secondaryTextColor),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isCredit ? '+' : '-'}\$${item['amount']!.replaceAll('-', '').replaceAll('+', '')}',
                        style: AppStyles.h4(
                          color:
                              isCredit
                                  ? const Color(0xFF12B76A)
                                  : _debitAmountColor,
                          fontFamily: 'InterSemiBold',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item['points']} pts',
                        style: AppStyles.h6(
                          color: const Color(0xFF12B76A),
                          fontFamily: 'InterSemiBold',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _loadWalletSettings() async {
    final savedCardIndex = await PrefsHelper.getInt(_kDefaultCardIndex);
    final savedTopUpEnabled = await PrefsHelper.getBool(_kAutoTopUpEnabled);
    final savedThreshold = await PrefsHelper.getInt(_kAutoTopUpThreshold);
    final savedTxnAlerts = await PrefsHelper.getBool(_kTransactionAlerts);
    final savedAutoDebit = await PrefsHelper.getBool(_kSavingsAutoDebit);
    final savedExportFormat = await PrefsHelper.getString(_kExportFormat);

    if (!mounted) return;

    setState(() {
      if (savedCardIndex >= 0 && savedCardIndex < _cards.length) {
        _defaultCardIndex = savedCardIndex;
      }
      _autoTopUpEnabled = savedTopUpEnabled ?? _autoTopUpEnabled;
      if (savedThreshold >= 5) {
        _autoTopUpThreshold = savedThreshold;
      }
      _transactionAlertsEnabled = savedTxnAlerts ?? _transactionAlertsEnabled;
      _savingsAutoDebitEnabled = savedAutoDebit ?? _savingsAutoDebitEnabled;
      if (savedExportFormat == 'PDF' || savedExportFormat == 'CSV') {
        _exportFormat = savedExportFormat;
      }
    });
  }

  Future<void> _persistWalletSettings() async {
    await PrefsHelper.setInt(_kDefaultCardIndex, _defaultCardIndex);
    await PrefsHelper.setBool(_kAutoTopUpEnabled, _autoTopUpEnabled);
    await PrefsHelper.setInt(_kAutoTopUpThreshold, _autoTopUpThreshold);
    await PrefsHelper.setBool(_kTransactionAlerts, _transactionAlertsEnabled);
    await PrefsHelper.setBool(_kSavingsAutoDebit, _savingsAutoDebitEnabled);
    await PrefsHelper.setString(_kExportFormat, _exportFormat);
  }

  void _openWalletSettingsSheet() {
    int localDefaultCard = _defaultCardIndex;
    bool localAutoTopUp = _autoTopUpEnabled;
    double localThreshold = _autoTopUpThreshold.toDouble();
    bool localTxnAlerts = _transactionAlertsEnabled;
    bool localAutoDebit = _savingsAutoDebitEnabled;
    String localExport = _exportFormat;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return SafeArea(
              top: false,
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                decoration: BoxDecoration(
                  color:
                      Get.isDarkMode
                          ? const Color(0xF018202D)
                          : const Color(0xF7FFFFFF),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.borderColor.withValues(alpha: 0.45),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Wallet Settings',
                            style: AppStyles.h3(fontFamily: 'InterSemiBold'),
                          ),
                          IconButton(
                            onPressed: Get.back,
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Default Payment Method',
                        style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        initialValue:
                            localDefaultCard < _cards.length
                                ? localDefaultCard
                                : 0,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              Get.isDarkMode
                                  ? const Color(0x55283243)
                                  : const Color(0xFFF5F7FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: List.generate(_cards.length, (index) {
                          final card = _cards[index];
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(
                              '${card['brand']} •••• ${card['last4']}',
                              style: AppStyles.h5(),
                            ),
                          );
                        }),
                        onChanged: (value) {
                          modalSetState(() => localDefaultCard = value ?? 0);
                        },
                      ),
                      const SizedBox(height: 10),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Auto Top-up',
                          style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                        ),
                        subtitle: Text(
                          localAutoTopUp ? 'Enabled at threshold' : 'Disabled',
                          style: AppStyles.h6(
                            color: Get.textTheme.bodyMedium!.color,
                          ),
                        ),
                        value: localAutoTopUp,
                        onChanged: (value) {
                          modalSetState(() => localAutoTopUp = value);
                        },
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: localAutoTopUp ? 1 : 0.45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Top-up threshold: \$${localThreshold.toInt()}',
                              style: AppStyles.h6(
                                color: Get.textTheme.bodyMedium!.color,
                              ),
                            ),
                            Slider(
                              min: 10,
                              max: 300,
                              divisions: 29,
                              value: localThreshold,
                              onChanged:
                                  localAutoTopUp
                                      ? (value) {
                                        modalSetState(
                                          () => localThreshold = value,
                                        );
                                      }
                                      : null,
                            ),
                          ],
                        ),
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Transaction Alerts',
                          style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                        ),
                        subtitle: Text(
                          'Push alerts for charges and deposits',
                          style: AppStyles.h6(
                            color: Get.textTheme.bodyMedium!.color,
                          ),
                        ),
                        value: localTxnAlerts,
                        onChanged: (value) {
                          modalSetState(() => localTxnAlerts = value);
                        },
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Savings Auto-Debit',
                          style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                        ),
                        subtitle: Text(
                          'Automatically move funds into savings plans',
                          style: AppStyles.h6(
                            color: Get.textTheme.bodyMedium!.color,
                          ),
                        ),
                        value: localAutoDebit,
                        onChanged: (value) {
                          modalSetState(() => localAutoDebit = value);
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Export Transactions',
                        style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _settingsChoiceChip(
                              label: 'PDF',
                              selected: localExport == 'PDF',
                              onTap:
                                  () =>
                                      modalSetState(() => localExport = 'PDF'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _settingsChoiceChip(
                              label: 'CSV',
                              selected: localExport == 'CSV',
                              onTap:
                                  () =>
                                      modalSetState(() => localExport = 'CSV'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Get.snackbar(
                                  'Export Started',
                                  'Your ${localExport.toUpperCase()} statement is being prepared.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Export',
                                style: AppStyles.h6(
                                  fontFamily: 'InterSemiBold',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.support_agent_rounded),
                          onPressed: () {
                            Get.back();
                            Get.toNamed(AppRoutes.callSuportScreen);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          label: Text(
                            'Wallet Support',
                            style: AppStyles.h5(fontFamily: 'InterSemiBold'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _defaultCardIndex = localDefaultCard;
                              _autoTopUpEnabled = localAutoTopUp;
                              _autoTopUpThreshold = localThreshold.toInt();
                              _transactionAlertsEnabled = localTxnAlerts;
                              _savingsAutoDebitEnabled = localAutoDebit;
                              _exportFormat = localExport;
                            });
                            await _persistWalletSettings();
                            if (!mounted) return;
                            Get.back();
                            Get.snackbar(
                              'Saved',
                              'Wallet settings updated.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: AppStyles.h5(
                              color: Colors.white,
                              fontFamily: 'InterSemiBold',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _settingsChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient:
              selected
                  ? const LinearGradient(colors: AppColors.brandGradient)
                  : null,
          color: selected ? null : Colors.transparent,
          border: Border.all(
            color:
                selected
                    ? Colors.transparent
                    : AppColors.borderColor.withValues(alpha: 0.75),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppStyles.h6(
              color: selected ? Colors.white : Get.textTheme.bodyLarge!.color,
              fontFamily: 'InterSemiBold',
            ),
          ),
        ),
      ),
    );
  }

  void _showRechargeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Get.theme.cardColor,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Funds', style: AppStyles.h3()),
                const SizedBox(height: 8),
                Text('How much do you want to add?', style: AppStyles.h5()),
                const SizedBox(height: 12),
                CustomTextField(
                  keyboardType: TextInputType.number,
                  controller: _walletCtrl.amountTextCtrl,
                  textStyle: TextStyle(color: Get.theme.textTheme.bodyLarge!.color),
                  contenpaddingHorizontal: 14,
                  contenpaddingVertical: 13,
                  hintText: 'Enter amount',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: CustomButton(
                          text: 'Close',
                          color: Colors.red,
                          textStyle: AppStyles.h6(color: Colors.white),
                          onTap: Get.back,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => SizedBox(
                          height: 44,
                          child: CustomButton(
                            loading: _walletCtrl.paymentLoading.value,
                            text: 'Add Funds',
                            textStyle: AppStyles.h6(color: Colors.white),
                            onTap: () {
                              if (_walletCtrl.amountTextCtrl.text
                                  .trim()
                                  .isEmpty) {
                                Get.snackbar(
                                  'Amount required',
                                  'Enter amount to continue.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }
                              _walletCtrl.handlePayment();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bgGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
