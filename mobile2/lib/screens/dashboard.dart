import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../widgets/campaign_card.dart';
import '../widgets/kpi_tile.dart';
import '../widgets/transaction_row.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.headerGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.horizontalPadding),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        _buildShopHeader(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  // TODO: Navigate to settings
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                    _buildCurrentCampaign(),
                    const SizedBox(height: 24),
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTransactionsList(),
                    const SizedBox(height: 24),
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildQuickActions(),
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to new funding request
        },
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
        backgroundColor: AppTheme.primaryTeal,
      ),
    );
  }

  Widget _buildShopHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppTheme.tealLight,
          child: Text(
            'A',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTeal.withOpacity(0.8),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Ashish's Chai Point",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, size: 12, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Mumbai, Maharashtra',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.primaryText.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: [AppTheme.defaultShadow],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: KpiTile(
                  title: "Today's UPI",
                  value: _currencyFormat.format(3200),
                  subtitle: 'Estimated',
                  icon: Icons.payment,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: KpiTile(
                  title: 'Avg UPI/day',
                  value: _currencyFormat.format(8500),
                  subtitle: 'Last 30 days',
                  icon: Icons.trending_up,
                  iconColor: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to QR replacement
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Replace QR'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to support
                  },
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Support'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentCampaign() {
    return CampaignCard(
      title: 'Shop Expansion',
      raised: 32000,
      target: 50000,
      daysLeft: 12,
      investorCount: 21,
      onManage: () {
        // TODO: Navigate to campaign details
      },
    );
  }

  Widget _buildTransactionsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
        boxShadow: [AppTheme.defaultShadow],
      ),
      child: Column(
        children: [
          TransactionRow(
            date: DateTime.now(),
            type: TransactionType.sale,
            amount: 250,
            status: 'Completed',
            currencyFormat: _currencyFormat,
          ),
          TransactionRow(
            date: DateTime.now().subtract(const Duration(hours: 2)),
            type: TransactionType.sale,
            amount: 180,
            status: 'Completed',
            currencyFormat: _currencyFormat,
          ),
          TransactionRow(
            date: DateTime.now().subtract(const Duration(hours: 4)),
            type: TransactionType.payout,
            amount: 500,
            status: 'Processing',
            currencyFormat: _currencyFormat,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: [AppTheme.defaultShadow],
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Upload Documents'),
            subtitle: const Text('Complete KYC verification'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to document upload
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Bank & Payout'),
            subtitle: const Text('Manage your bank accounts'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to bank settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Agreements'),
            subtitle: const Text('View terms and conditions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to agreements
            },
          ),
        ],
      ),
    );
  }
}
