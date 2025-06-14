//  flutter_splash.dart
//
//  A richer splash-screen that layers three effects:
//
//  1.  Soft, looping sine-waves at the bottom (parallax).
//  2.  "Firefly" bubbles that drift upward and twinkle.
//  3.  A pulsating neon ring behind the logo.
//
//  The title types itself out, gains a shimmer, and the whole
//  scene exits after 3.2 s → "/login" or "/home" based on auth status.
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ────────────────────────── Entrance ──────────────────────────
  late final AnimationController _logoCtrl;
  late final Animation<Offset>  _logoOffset;
  late final Animation<double>  _logoOpacity;
  late final Animation<double>  _logoRotation;

  // ───────────────────────── Text effect ────────────────────────
  late final AnimationController _typeCtrl;
  static const _fullText = 'AgriCure';
  String _visibleText = '';
  bool _showSlogan = false;
  bool _showRipple = false;
  Offset? _rippleOffset;
  double _rippleRadius = 0;
  bool _showProgress = false;

  static const _slogan = 'Smart Farming, Bright Future';

  // ───────────────────────── Backgrounds ────────────────────────
  late final AnimationController _waveCtrl;   // sine-waves
  late final AnimationController _bubbleCtrl; // drifting bubbles
  static const _routeDelay = Duration(milliseconds: 3200);

  @override
  void initState() {
    super.initState();

    /* logo ---------------------------------------------------------------- */
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoOffset   = Tween(begin: const Offset(0, .5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutCubic));
    _logoOpacity  = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn));
    _logoRotation = Tween(begin: -.08, end: 0.0)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut));
    _logoCtrl.forward();

    /* type-writer --------------------------------------------------------- */
    _typeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addListener(_handleTypewriter);
    Future.delayed(const Duration(milliseconds: 700), _typeCtrl.forward);

    /* waves & bubbles ----------------------------------------------------- */
    _waveCtrl   = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat(reverse: true);
    _bubbleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat();

    /* slogan and progress ------------------------------------------------- */
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _showSlogan = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _showProgress = true);
      });
    });

    /* route change -------------------------------------------------------- */
    Future.delayed(_routeDelay, () {
      if (mounted) {
        // Check authentication status and navigate accordingly
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.isLoggedIn) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    });
  }

  void _handleTypewriter() {
    final count = (_typeCtrl.value * _fullText.length).ceil();
    if (count != _visibleText.length) {
      setState(() => _visibleText = _fullText.substring(0, count));
    }
  }

  void _triggerRipple(TapUpDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    setState(() {
      _showRipple = true;
      _rippleOffset = box.globalToLocal(details.globalPosition);
      _rippleRadius = 0;
    });
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        _rippleRadius = 120;
      });
      Future.delayed(const Duration(milliseconds: 350), () {
        setState(() {
          _showRipple = false;
          _rippleRadius = 0;
        });
      });
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _typeCtrl
      ..removeListener(_handleTypewriter)
      ..dispose();
    _waveCtrl.dispose();
    _bubbleCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────── Build ────────────────────────────
  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: Stack(
        children: [
          // Diagonal brand gradient.
          const _DiagonalGradient(),

          // Sine-wave layers.
          AnimatedBuilder(
            animation: _waveCtrl,
            builder: (_, __) => CustomPaint(
              painter: _WavePainter(phase: _waveCtrl.value * 2 * math.pi),
              size: Size.infinite,
            ),
          ),

          // Floating bubbles / fireflies.
          AnimatedBuilder(
            animation: _bubbleCtrl,
            builder: (_, __) => CustomPaint(
              painter: _BubblePainter(progress: _bubbleCtrl.value),
              size: Size.infinite,
            ),
          ),

          // Logo, pulsating ring & title.
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTapUp: _triggerRipple,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ScaleTransition(
                        scale: Tween(begin: .9, end: 1.0).animate(
                          CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutBack),
                        ),
                        child: FadeTransition(
                          opacity: _logoOpacity,
                          child: RotationTransition(
                            turns: _logoRotation,
                            child: _NeonRing(
                              child: Semantics(
                                label: 'AgriCure logo',
                                child: Padding(
                                  padding: const EdgeInsets.all(28),
                                  child: Image.asset(
                                    'assets/images/Screenshot_2025-06-12_061854-removebg-preview.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_showRipple && _rippleOffset != null)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOut,
                          width: _rippleRadius * 2,
                          height: _rippleRadius * 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.18),
                          ),
                          margin: EdgeInsets.only(
                            left: _rippleOffset!.dx - _rippleRadius,
                            top: _rippleOffset!.dy - _rippleRadius,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _typeCtrl,
                  child: _ShimmerText(_visibleText),
                ),
                if (_showSlogan)
                  AnimatedOpacity(
                    opacity: _showSlogan ? 1 : 0,
                    duration: const Duration(milliseconds: 600),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        _slogan,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18 * textScale,
                          color: Colors.white.withOpacity(0.92),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                if (_showProgress)
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: SizedBox(
                      width: 48,
                      height: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white.withOpacity(0.13),
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*─────────────────────────────────────────────────────────────*/
/*                     Decorative widgets                      */
/*─────────────────────────────────────────────────────────────*/

class _DiagonalGradient extends StatelessWidget {
  const _DiagonalGradient();

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF388E3C), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
}

// Pulsating neon ring w/ blur.
class _NeonRing extends StatefulWidget {
  final Widget child;
  const _NeonRing({required this.child});

  @override
  State<_NeonRing> createState() => _NeonRingState();
}

class _NeonRingState extends State<_NeonRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final pulse = 1 + (_ctrl.value * .05); // subtle scale pulse
        return Transform.scale(
          scale: pulse,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(.25),
                  Colors.white.withOpacity(.05),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(.3 * _ctrl.value),
                  blurRadius: 30,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

// Shimmering headline text.
class _ShimmerText extends StatefulWidget {
  final String text;
  const _ShimmerText(this.text);

  @override
  State<_ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<_ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            colors: [
              Colors.white.withOpacity(.15),
              Colors.white,
              Colors.white.withOpacity(.15),
            ],
            stops: const [0, .5, 1],
            begin: Alignment(-1 - _ctrl.value, 0),
            end: Alignment(1 - _ctrl.value, 0),
          ).createShader(rect);
        },
        blendMode: BlendMode.srcATop,
        child: child,
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

/*─────────────────────────────────────────────────────────────*/
/*                          Painters                           */
/*─────────────────────────────────────────────────────────────*/

// Wavy horizon.
class _WavePainter extends CustomPainter {
  final double phase;
  _WavePainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    const backColor  = Color(0xFF1976D2);
    const frontColor = Color(0xFF388E3C);
    _drawWave(canvas, size, backColor .withOpacity(.12), 20, .80, phase, 1.0);
    _drawWave(canvas, size, frontColor.withOpacity(.18), 26, .82, phase, 1.6);
  }

  void _drawWave(Canvas c, Size s, Color color, double amp, double hFactor,
      double ph, double freq) {
    final path  = Path()..moveTo(0, s.height);
    final paint = Paint()..color = color;
    for (double x = 0; x <= s.width; x++) {
      final y = math.sin((x / s.width * 2 * math.pi * freq) + ph) * amp +
          s.height * hFactor;
      path.lineTo(x, y);
    }
    path
      ..lineTo(s.width, s.height)
      ..close();
    c.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.phase != phase;
}

// Floating bubble "fireflies".
class _BubblePainter extends CustomPainter {
  final double progress;
  static final _rnd = math.Random();
  static final _bubbles = List<_Bubble>.generate(
    18,
    (i) => _Bubble(
      dx: _rnd.nextDouble(),
      size: _rnd.nextDouble() * 4 + 2,
      offset: _rnd.nextDouble(),
      speed: 0.4 + _rnd.nextDouble() * .6,
    ),
  );

  _BubblePainter({required this.progress});

  @override
  void paint(Canvas c, Size s) {
    for (final b in _bubbles) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(.25 * b.opacity(progress));
      final x = b.dx * s.width;
      final y = s.height *
          (1 - ((progress * b.speed + b.offset) % 1.0)) *
          .9; // vertical loop
      c.drawCircle(Offset(x, y), b.size, paint);
    }
  }

  @override
  bool shouldRepaint(_BubblePainter old) => old.progress != progress;
}

class _Bubble {
  final double dx;   // horizontal pos (0-1)
  final double size; // radius
  final double offset;
  final double speed;

  _Bubble({
    required this.dx,
    required this.size,
    required this.offset,
    required this.speed,
  });

  double opacity(double t) {
    final phase = ((t * speed + offset) % 1.0);
    return phase < .1
        ? phase * 10
        : phase > .9
            ? (1 - phase) * 10
            : 1;
  }
}
