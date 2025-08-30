import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/fund_request_card.dart';
import '../widgets/shimmer_placeholder.dart';

class ShopDashboard extends StatefulWidget {
  final VoidCallback onCall;
  const ShopDashboard({super.key, required this.onCall});

  @override
  State<ShopDashboard> createState() => _ShopDashboardState();
}

class _ShopDashboardState extends State<ShopDashboard> {
  bool _loading = true;
  List<FundRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    _requests = [
      FundRequest(
        status: 'Active',
        raised: 32000,
        target: 50000,
        title: 'Shop Expansion',
      ),
      FundRequest(
        status: 'Completed',
        raised: 20000,
        target: 20000,
        title: 'Inventory Restock',
      ),
      FundRequest(
        status: 'Pending',
        raised: 0,
        target: 15000,
        title: 'New Equipment',
      ),
    ];
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final activeRequest = _requests.where((r) => r.status == 'Active').toList();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Raise Fund',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.teal[900],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF60A5FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadMockData,
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                const SizedBox(height: 16),
                if (activeRequest.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FundRequestCard(request: activeRequest.first),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Support',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.call, color: Colors.white),
                              label: Text(
                                'Call Support',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                minimumSize: const Size.fromHeight(44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: widget.onCall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(
                    'My Fund Requests',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (_loading)
                  ...List.generate(
                    2,
                    (i) => const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: ShimmerPlaceholder(height: 90),
                    ),
                  )
                else
                  ..._requests.map(
                    (r) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FundRequestCard(request: r),
                    ),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add),
        label: Text(
          'Create Request',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.teal[300],
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
