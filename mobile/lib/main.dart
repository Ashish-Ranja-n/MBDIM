import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/shop_dashboard.dart';
import 'screens/investor_dashboard.dart';

void main() {
  runApp(const MbdimApp());
}

class MbdimApp extends StatefulWidget {
  const MbdimApp({super.key});

  @override
  State<MbdimApp> createState() => _MbdimAppState();
}

class _MbdimAppState extends State<MbdimApp> {
  Widget? _home;

  @override
  void initState() {
    super.initState();
    _loadInitialScreen();
  }

  Future<void> _loadInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('user_role');
    setState(() {
      if (role == 'shop') {
        _home = ShopDashboard(onCall: () {});
      } else if (role == 'investor') {
        _home = const InvestorDashboard();
      } else {
        _home = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MBDIM',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _home ?? MbdimFlow(),
    );
  }
}

class MbdimFlow extends StatefulWidget {
  const MbdimFlow({super.key});

  @override
  State<MbdimFlow> createState() => _MbdimFlowState();
}

class _MbdimFlowState extends State<MbdimFlow> {
  int _step = 0;
  String? _role;

  void _goToNext([String? value]) {
    setState(() {
      // No need to store user input at this step
      if (_step == 3 && value != null) _role = value;
      _step++;
    });
  }

  void _goToDashboard(String role) {
    setState(() {
      _role = role;
      _step = 4;
    });
  }

  void _callSupport() {
    // TODO: Implement call support
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Call support feature coming soon!')),
    );
  }

  // Removed unused _changeRole method

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case 0:
        return OnboardingScreen(onGetStarted: _goToNext);
      case 1:
        return WelcomeScreen(onContinue: _goToNext);
      case 2:
        return OtpScreen(onVerified: _goToNext);
      case 3:
        return RoleSelectionScreen(onRoleSelected: _goToDashboard);
      case 4:
        if (_role == 'shop') {
          return ShopDashboard(onCall: _callSupport);
        } else {
          return const InvestorDashboard();
        }
      default:
        return OnboardingScreen(onGetStarted: _goToNext);
    }
  }
}
