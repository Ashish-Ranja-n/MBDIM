import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'investor_profile_page.dart';
import '../widgets/market_summary_card.dart';
import '../widgets/shop_card.dart';
import '../widgets/invest_modal.dart';
import '../widgets/shop_detail.dart';
import '../widgets/shimmer_placeholder.dart';

class InvestorDashboard extends StatefulWidget {
  const InvestorDashboard({super.key});

  @override
  State<InvestorDashboard> createState() => _InvestorDashboardState();
}

class _InvestorDashboardState extends State<InvestorDashboard> {
  final String _selectedFilter = 'All';
  bool _loading = true;
  List<Shop> _shops = [];
  List<Shop> _filteredShops = [];

  @override
  void initState() {
    super.initState();
    // ensure system status bar icons are visible on dark background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    _shops = [
      Shop(
        name: 'FreshMart',
        category: 'Grocery',
        city: 'Delhi',
        logoAsset: 'assets/shop1.png',
        avgUpi: 12000,
        ticket: 5000,
        estReturn: 1.3,
        raised: 35000,
        target: 50000,
        trending: true,
      ),
      Shop(
        name: 'Urban Tailor',
        category: 'Fashion',
        city: 'Mumbai',
        logoAsset: 'assets/shop2.png',
        avgUpi: 8000,
        ticket: 3000,
        estReturn: 1.2,
        raised: 15000,
        target: 20000,
      ),
      Shop(
        name: 'Chai Point',
        category: 'Cafe',
        city: 'Bangalore',
        logoAsset: 'assets/shop3.png',
        avgUpi: 10000,
        ticket: 4000,
        estReturn: 1.4,
        raised: 42000,
        target: 60000,
        trending: true,
      ),
    ];
    _applyFilters();
    setState(() => _loading = false);
  }

  void _applyFilters() {
    setState(() {
      // No search input UI — keep filter-only behaviour based on _selectedFilter
      _filteredShops = _shops.where((shop) {
        bool matchesFilter = _selectedFilter == 'All';
        if (_selectedFilter == 'Nearby') matchesFilter = shop.city == 'Delhi';
        if (_selectedFilter == 'High ROI') {
          matchesFilter = shop.estReturn >= 1.3;
        }
        if (_selectedFilter == 'Most Funded') {
          matchesFilter = shop.raised / shop.target > 0.7;
        }
        if (_selectedFilter == 'New') {
          matchesFilter = shop.raised / shop.target < 0.3;
        }
        return matchesFilter;
      }).toList();
    });
  }

  void _onInvest(Shop shop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) =>
          InvestModal(ticketPrice: shop.ticket, onConfirm: (qty) {}),
    );
  }

  void _onDetails(Shop shop) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ShopDetailPage(shop: shop)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Scaffold(
      backgroundColor: const Color(0xFF0B1115),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF0F9D58),
          backgroundColor: const Color(0xFF12171C),
          onRefresh: _loadMockData,
          child: CustomScrollView(
            slivers: [
              // Sticky header
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyMarketHeader(),
              ),
              // (search bar removed per design) — keeping header, KPI and content
              // KPI / Summary strip
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 2,
                  ),
                  child: MarketSummaryCard(
                    activeListings: _shops.length,
                    todayVolume: currency.format(750),
                    // compute total raised across shops for the new KPI
                    totalFundRaised: currency.format(
                      _shops.fold<double>(0.0, (p, e) => p + e.raised),
                    ),
                    avgYield: '1.3x',
                  ),
                ),
              ),
              // Add spacing between KPI and chart
              SliverToBoxAdapter(child: SizedBox(height: 8)),
              // Chart card (mock sparkline)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 2,
                  ),
                  child: _MarketChartCard(),
                ),
              ),
              // Featured shop card (first shop)
              if (_shops.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 2,
                    ),
                    child: ShopCard(
                      shop: _shops.first,
                      onInvest: () => _onInvest(_shops.first),
                      onDetails: () => _onDetails(_shops.first),
                    ),
                  ),
                ),
              // Shop list
              _loading
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 6,
                          ),
                          child: ShimmerPlaceholder(height: 120),
                        ),
                        childCount: 3,
                      ),
                    )
                  : _filteredShops.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'No shops found.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF9AA5AD),
                            ),
                          ),
                        ),
                      ),
                    )
                  : () {
                      // If we show a featured shop (the first shop), avoid duplicating it in the list.
                      final displayedShops =
                          (_shops.isNotEmpty &&
                              _filteredShops.contains(_shops.first))
                          ? _filteredShops
                                .where((s) => s != _shops.first)
                                .toList()
                          : _filteredShops;

                      return SliverList.separated(
                        itemCount: displayedShops.length,
                        separatorBuilder: (context, i) =>
                            const SizedBox(height: 4),
                        itemBuilder: (context, i) {
                          final shop = displayedShops[i];
                          // staggered slide + fade for better entrance
                          return _StaggeredItem(
                            index: i,
                            child: ShopCard(
                              shop: shop,
                              onInvest: () => _onInvest(shop),
                              onDetails: () => _onDetails(shop),
                            ),
                          );
                        },
                      );
                    }(),
            ],
          ),
        ),
      ),
    );
  }
}

// simple staggered slide+fade wrapper
class _StaggeredItem extends StatefulWidget {
  final Widget child;
  final int index;
  const _StaggeredItem({required this.child, required this.index});

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _offset;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    final curve = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _offset = Tween(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curve);
    _opacity = Tween(begin: 0.0, end: 1.0).animate(curve);
    Future.delayed(
      Duration(milliseconds: 80 * widget.index),
      () => _ctrl.forward(),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: FadeTransition(opacity: _opacity, child: widget.child),
    );
  }
}

// Sticky header delegate for Market page
class _StickyMarketHeader extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 68;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        // give the sticky header a solid background so the top area
        // isn't transparent over the system status bar
        color: const Color(0xFF0B1115),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.18 * 255).round()),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InvestorProfilePage(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF12171C),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF0F9D58),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Center(
                child: Text(
                  'Investment Market',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    color: Color(0xFFE6EEF3),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Color(0xFF0F9D58),
              ),
              onPressed: () {},
              splashRadius: 24,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

// Mock chart card widget for dashboard
class _MarketChartCard extends StatefulWidget {
  @override
  State<_MarketChartCard> createState() => _MarketChartCardState();
}

class _MarketChartCardState extends State<_MarketChartCard> {
  bool showTotalReturn = true;
  final List<double> mockData = [
    1.0,
    1.1,
    1.15,
    1.2,
    1.18,
    1.25,
    1.3,
    1.28,
    1.32,
    1.35,
    1.33,
    1.38,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12171C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.18 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => showTotalReturn = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: showTotalReturn
                        ? const Color(0xFF0F9D58)
                        : const Color(0xFF232A31),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Total Return',
                    style: TextStyle(
                      color: showTotalReturn ? Colors.white : Color(0xFFB7C2C8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => showTotalReturn = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: !showTotalReturn
                        ? const Color(0xFF0F9D58)
                        : const Color(0xFF232A31),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'NAV Per Unit',
                    style: TextStyle(
                      color: !showTotalReturn
                          ? Colors.white
                          : Color(0xFFB7C2C8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: CustomPaint(
              painter: _SparklinePainter(
                mockData,
                accent: const Color(0xFF66FFA6),
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color accent;
  _SparklinePainter(this.data, {required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final path = Path();
    if (data.isNotEmpty) {
      final min = data.reduce((a, b) => a < b ? a : b);
      final max = data.reduce((a, b) => a > b ? a : b);
      for (int i = 0; i < data.length; i++) {
        final x = i * size.width / (data.length - 1);
        final y =
            size.height -
            ((data[i] - min) / (max - min + 0.0001)) * size.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
