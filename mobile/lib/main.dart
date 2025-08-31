import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/otp_screen.dart';
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
    // If the user has completed the full startup flow previously, go straight to InvestorDashboard.
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('flow_completed') ?? false;
    setState(() {
      _home = completed ? const InvestorDashboard() : null;
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
  // role selection removed

  void _goToNext([String? value]) {
    setState(() {
      // No need to store user input at this step
      _step++;
    });
    // If we've just advanced past OTP (step 3 is the dashboard), mark the initial flow as completed
    // so subsequent app launches can default to the dashboard.
    if (_step == 3) {
      // fire-and-forget
      SharedPreferences.getInstance().then(
        (prefs) => prefs.setBool('flow_completed', true),
      );
    }
  }

  // Removed unused support and role-selection helpers.
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
        // After OTP, go directly to investor dashboard
        return const InvestorDashboard();
      case 4:
        return const InvestorDashboard();
      default:
        return OnboardingScreen(onGetStarted: _goToNext);
    }
  }
}
