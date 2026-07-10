import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../constants.dart';
import '../../router.router.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../services/home_services.dart';
// ─── Blue Accent Palette (matches your CustomColors) ───────────────────────
const _blue = Color(0xFF448AFF);        // sourceCustomcolor1 / blueAccent
const _blueDark = Color(0xFF0065C2);    // customcolor1
const _blueDeep = Color(0xFF00376B);    // onCustomcolor1Container
const _blueLight = Color(0xFFBBDEFB);  // light fill
const _bluePale = Color(0xFFE3F2FD);   // customcolor1Container
const _blueMid = Color(0xFF90CAF9);    // dark-theme customcolor1
// ───────────────────────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _isLoggedIn = false;
  bool _openedLocationSettingsOnce = false;
  bool _openedAppSettingsOnce = false;

  // Animation controllers
  late final AnimationController _logoController;
  late final AnimationController _contentController;
  late final AnimationController _progressController;
  late final AnimationController _orbit1Controller;
  late final AnimationController _orbit2Controller;
  late final AnimationController _particleController;

  // Logo animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  // Content animations (name, tagline, footer)
  late final Animation<double> _nameFade;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _footerFade;
  late final Animation<Offset> _footerSlide;

  // Progress
  late final Animation<double> _progressValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupAnimations();
    _startAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startFlow());
    requestNotificationPermission();
    getToken();
  }

  void _setupAnimations() {
    // Logo: scale + fade pop-in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Content staggered slide-up
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _nameFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
    ));

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.2, 0.75, curve: Curves.easeOutCubic),
    ));

    _footerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
      ),
    );
    _footerSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
    ));

    // Progress bar
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Orbit rings (continuous rotation)
    _orbit1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _orbit2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: false);

    // Particle pulse
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  void _startAnimations() {
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _contentController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) _progressController.forward();
    });
  }

  // ─── Location gate (unchanged logic) ──────────────────────────────────────

  Future<bool> _ensureLocationGateAndAutoOpenSettings() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!_openedLocationSettingsOnce) {
        _openedLocationSettingsOnce = true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Geolocator.openLocationSettings();
        });
      }
      return false;
    }

    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }
    if (status.isPermanentlyDenied || status.isRestricted || status.isLimited) {
      if (!_openedAppSettingsOnce) {
        _openedAppSettingsOnce = true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await openAppSettings();
        });
      }
      return false;
    }

    return status.isGranted;
  }

  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('Permission: ${settings.authorizationStatus}');
  }

  Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN: $token");
  }

  Future<void> _performAsyncOperations() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getString("api_secret") != null &&
        prefs.getString("api_key") != null) {
      _isLoggedIn = true;
      final token = await getTocken();
      Logger().i(token);
    }
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _startFlow() async {
    if (!mounted) return;
    final ok = await _ensureLocationGateAndAutoOpenSettings();
    if (!ok) return;
    await _performAsyncOperations();

    await _performAsyncOperations();

    if (_isLoggedIn) {
      final dashboard = await HomeServices().dashboard();

      if (dashboard != null) {
        Provider.of<AppState>(context, listen: false)
            .setTracking(dashboard.trackingEnabled ?? false);

        print("Tracking Enabled: ${dashboard.trackingEnabled}");
      }
    }

    if (!mounted) return;

    if (_isLoggedIn) {
      Navigator.popAndPushNamed(context, Routes.homePage);
    } else {
      Navigator.popAndPushNamed(context, Routes.loginViewScreen);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startFlow();
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bluePale,
      body: Stack(
        children: [
          // Decorative background circles
          _buildBgCircles(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Version pill top-right
                Align(
                  alignment: Alignment.centerRight,
                  child: FadeTransition(
                    opacity: _footerFade,
                    child: Container(
                      margin: const EdgeInsets.only(right: 20, top: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _blueMid, width: 1),
                      ),
                      child: const Text(
                        'v1.0.0',
                        style: TextStyle(
                          fontSize: 10,
                          color: _blue,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                // Center logo + text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogoOrbit(),
                      const SizedBox(height: 20),
                      _buildAppName(),
                      const SizedBox(height: 6),
                      _buildTagline(),
                      const SizedBox(height: 32),
                      _buildProgressBar(),
                    ],
                  ),
                ),

                // Footer
                _buildFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Background decorative circles ────────────────────────────────────────

  Widget _buildBgCircles() {
    return Stack(
      children: [
        // Top-left large circle
        Positioned(
          top: -130,
          left: -110,
          child: Container(
            width: 380,
            height: 380,
            decoration: const BoxDecoration(
              color: _blueLight,
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Bottom-right circle
        Positioned(
          bottom: -90,
          right: -70,
          child: Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              color: _blueMid.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Small accent circle
        Positioned(
          top: 70,
          right: 60,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: _blue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Logo with orbiting rings ──────────────────────────────────────────────

  Widget _buildLogoOrbit() {
    return FadeTransition(
      opacity: _logoFade,
      child: ScaleTransition(
        scale: _logoScale,
        child: SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer orbit ring
              AnimatedBuilder(
                animation: _orbit1Controller,
                builder: (_, __) => Transform.rotate(
                  angle: _orbit1Controller.value * 2 * 3.14159,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _blue.withOpacity(0.18),
                        width: 1.5,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Transform.translate(
                        offset: const Offset(0, -5),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: _blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Inner orbit ring (reverse)
              AnimatedBuilder(
                animation: _orbit2Controller,
                builder: (_, __) => Transform.rotate(
                  angle: -(_orbit2Controller.value * 2 * 3.14159),
                  child: Container(
                    width: 138,
                    height: 138,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _blueDark.withOpacity(0.15),
                        width: 1.0,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Transform.translate(
                        offset: const Offset(4, 0),
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: _blueDark,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Logo core circle
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _bluePale, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: _blue.withOpacity(0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  "assets/images/Logo D CMYK.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── App name ─────────────────────────────────────────────────────────────

  Widget _buildAppName() {
    return FadeTransition(
      opacity: _nameFade,
      child: SlideTransition(
        position: _nameSlide,
        child: const Text(
          'Sanpra One',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _blueDeep,
            letterSpacing: -0.4,
          ),
        ),
      ),
    );
  }

  // ─── Tagline ──────────────────────────────────────────────────────────────

  Widget _buildTagline() {
    return FadeTransition(
      opacity: _taglineFade,
      child: SlideTransition(
        position: _taglineSlide,
        child: Text(
          'BUILDING THE FUTURE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: _blueDark.withOpacity(0.75),
            letterSpacing: 3.0,
          ),
        ),
      ),
    );
  }

  // ─── Progress bar ─────────────────────────────────────────────────────────

  Widget _buildProgressBar() {
    return FadeTransition(
      opacity: _taglineFade,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: AnimatedBuilder(
          animation: _progressValue,
          builder: (_, __) => ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: _progressValue.value,
              backgroundColor: _blueLight,
              valueColor: const AlwaysStoppedAnimation<Color>(_blue),
              minHeight: 3,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return FadeTransition(
      opacity: _footerFade,
      child: SlideTransition(
        position: _footerSlide,
        child: Column(
          children: [
            Text(
              'Developed by',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w300,
                color: _blueMid.withOpacity(0.9),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Sanpra Software Solutions',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _blueDark,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Dispose ──────────────────────────────────────────────────────────────

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _logoController.dispose();
    _contentController.dispose();
    _progressController.dispose();
    _orbit1Controller.dispose();
    _orbit2Controller.dispose();
    _particleController.dispose();
    super.dispose();
  }
}