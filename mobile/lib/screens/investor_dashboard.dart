import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widgets/market_summary_card.dart';
import '../widgets/search_filters.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  bool _loading = true;
  List<Shop> _shops = [];
  List<Shop> _filteredShops = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
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
      _filteredShops = _shops.where((shop) {
        final query = _searchController.text.toLowerCase();
        final matchesSearch =
            shop.name.toLowerCase().contains(query) ||
            shop.city.toLowerCase().contains(query) ||
            shop.category.toLowerCase().contains(query);
        bool matchesFilter = _selectedFilter == 'All';
        if (_selectedFilter == 'Nearby') matchesFilter = shop.city == 'Delhi';
        if (_selectedFilter == 'High ROI')
          matchesFilter = shop.estReturn >= 1.3;
        if (_selectedFilter == 'Most Funded')
          matchesFilter = shop.raised / shop.target > 0.7;
        if (_selectedFilter == 'New')
          matchesFilter = shop.raised / shop.target < 0.3;
        return matchesSearch && matchesFilter;
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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Investment Market',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.green),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.green[100],
              child: const Icon(Icons.person, color: Colors.green, size: 22),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadMockData,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchFilters(
                          controller: _searchController,
                          filters: const [
                            'All',
                            'Nearby',
                            'High ROI',
                            'Most Funded',
                            'New',
                          ],
                          selectedFilter: _selectedFilter,
                          onFilterSelected: (f) {
                            setState(() => _selectedFilter = f);
                            _applyFilters();
                          },
                          onSearchChanged: (v) => _applyFilters(),
                        ),
                        MarketSummaryCard(
                          activeListings: _shops.length,
                          todayVolume: currency.format(120000),
                          avgYield: '1.3x',
                        ),
                      ],
                    ),
                  ),
                ),
                _loading
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
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
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                          final shop = _filteredShops[i];
                          return AnimatedOpacity(
                            opacity: 1,
                            duration: Duration(milliseconds: 300 + i * 100),
                            child: ShopCard(
                              shop: shop,
                              onInvest: () => _onInvest(shop),
                              onDetails: () => _onDetails(shop),
                            ),
                          );
                        }, childCount: _filteredShops.length),
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green[300],
        onTap: (i) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Market'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}
