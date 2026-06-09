import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFDEEAE7),
      body: _SplashBody(),
    );
  }
}

class _SplashBody extends StatefulWidget {
  const _SplashBody();

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody> with TickerProviderStateMixin {
  static const int _kMs = 2500;
  static const _pinColor = Color(0xFFEE6A63);
  static const _bgTop = Color(0xFFDEEAE7);
  static const _bgBot = Color(0xFFCEDFE1);
  static const _ink = Color(0xFF3C4A51);
  static const _sub = Color(0xFF93A4A7);
  static const _trail = Color(0xFF9DB3B1);

  late final AnimationController _ctrl;
  late final AnimationController _driftCtrl;

  late final Animation<double> _c1, _c2, _c3, _driftX;
  late final List<Animation<double>> _dots;
  late final Animation<double> _pinOp, _pinY, _pinSY, _pinSX;
  late final Animation<double> _ripOp, _ripSc;
  late final Animation<double> _shOp, _shSx;
  late final Animation<double> _wOp, _wY, _tOp, _tY;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _kMs),
    )..forward();

    _driftCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 13000),
    )..repeat(reverse: true);

    _driftX = Tween<double>(begin: 0, end: 14).animate(
      CurvedAnimation(parent: _driftCtrl, curve: Curves.easeInOut),
    );

    _c1 = _fade(120, 1020);
    _c2 = _fade(280, 1180);
    _c3 = _fade(440, 1340);

    _dots = List.generate(13, (i) {
      final s = 150 + i * 55;
      final e = (s + 360).clamp(0, _kMs);
      return Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _ctrl,
        curve: Interval(s / _kMs, e / _kMs, curve: const Cubic(0.34, 1.56, 0.64, 1)),
      ));
    });

    _pinOp = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 8),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 92),
    ]).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(360 / _kMs, 1410 / _kMs),
    ));

    _pinY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -440.0, end: 0.0)
            .chain(CurveTween(curve: const Cubic(0.45, 0, 0.25, 1))),
        weight: 72,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 9),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 0.0), weight: 9),
    ]).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(360 / _kMs, 1410 / _kMs),
    ));

    _pinSY = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 72),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.86), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 0.86, end: 1.04), weight: 9),
      TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.0), weight: 9),
    ]).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(360 / _kMs, 1410 / _kMs),
    ));

    _pinSX = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 72),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 0.98), weight: 9),
      TweenSequenceItem(tween: Tween(begin: 0.98, end: 1.0), weight: 9),
    ]).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(360 / _kMs, 1410 / _kMs),
    ));

    // Ripple: hidden before 1180ms, then fade from 0.55→0 while expanding
    _ripOp = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 1180),
      TweenSequenceItem(
        tween: Tween(begin: 0.55, end: 0.0)
            .chain(CurveTween(curve: const Cubic(0.22, 0.8, 0.3, 1))),
        weight: 900,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 420),
    ]).animate(_ctrl);

    _ripSc = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.3), weight: 1180),
      TweenSequenceItem(
        tween: Tween(begin: 0.3, end: 2.1)
            .chain(CurveTween(curve: const Cubic(0.22, 0.8, 0.3, 1))),
        weight: 900,
      ),
      TweenSequenceItem(tween: ConstantTween(2.1), weight: 420),
    ]).animate(_ctrl);

    _shOp = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(1140 / _kMs, 1860 / _kMs, curve: Cubic(0.22, 0.8, 0.3, 1)),
    ));
    _shSx = Tween<double>(begin: 0.35, end: 1).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(1140 / _kMs, 1860 / _kMs, curve: Cubic(0.22, 0.8, 0.3, 1)),
    ));

    _wOp = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(1320 / _kMs, 2000 / _kMs, curve: Cubic(0.22, 0.8, 0.3, 1)),
    ));
    _wY = Tween<double>(begin: 13, end: 0).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(1320 / _kMs, 2000 / _kMs, curve: Cubic(0.22, 0.8, 0.3, 1)),
    ));

    _tOp = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(1520 / _kMs, 2140 / _kMs, curve: Curves.easeOut),
    ));
    _tY = Tween<double>(begin: 13, end: 0).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(1520 / _kMs, 2140 / _kMs, curve: Curves.easeOut),
    ));
  }

  Animation<double> _fade(int s, int e) =>
      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _ctrl,
        curve: Interval(s / _kMs, e.clamp(0, _kMs) / _kMs, curve: Curves.easeOut),
      ));

  @override
  void dispose() {
    _ctrl.dispose();
    _driftCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge([_ctrl, _driftCtrl]),
      builder: (context, _) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgTop, _bgBot],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _cloud(size.width * 0.06 + _driftX.value, size.height * 0.16, 150, _c1.value),
            _cloud(size.width * 0.96 - 168 + _driftX.value, size.height * 0.33, 168, _c2.value),
            _cloud(size.width * 0.74 - 120 + _driftX.value, size.height * 0.09, 120, _c3.value),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dotted trail (rotated 4°)
                  Transform.rotate(
                    angle: 4 * math.pi / 180,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(13, (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: Transform.scale(
                          scale: _dots[i].value,
                          child: Opacity(
                            opacity: (_dots[i].value * 0.9).clamp(0.0, 1.0),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: _trail,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                        ),
                      )),
                    ),
                  ),

                  // Pin stage
                  SizedBox(
                    width: 130,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        // Ripple ring
                        Positioned(
                          top: 18,
                          child: Opacity(
                            opacity: _ripOp.value,
                            child: Transform.scale(
                              scale: _ripSc.value,
                              child: Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _pinColor, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Pin drop
                        Opacity(
                          opacity: _pinOp.value,
                          child: Transform.translate(
                            offset: Offset(0, _pinY.value),
                            child: Transform(
                              alignment: const Alignment(0, 0.84),
                              transform: Matrix4.diagonal3Values(
                                  _pinSX.value, _pinSY.value, 1.0),
                              child: CustomPaint(
                                size: const Size(106, 132),
                                painter: _PinPainter(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ground shadow
                  Opacity(
                    opacity: _shOp.value,
                    child: Transform.scale(
                      scaleX: _shSx.value,
                      child: Container(
                        width: 138,
                        height: 26,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          gradient: RadialGradient(
                            colors: [
                              _pinColor.withValues(alpha: 0.30),
                              _pinColor.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                            stops: const [0, 0.78, 1],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Wordmark
                  Opacity(
                    opacity: _wOp.value,
                    child: Transform.translate(
                      offset: Offset(0, _wY.value),
                      child: Text(
                        'flatnest',
                        style: GoogleFonts.quicksand(
                          fontSize: 44,
                          fontWeight: FontWeight.w600,
                          color: _ink,
                          height: 1,
                          letterSpacing: -0.44,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tagline
                  Opacity(
                    opacity: _tOp.value,
                    child: Transform.translate(
                      offset: Offset(0, _tY.value),
                      child: Text(
                        'YOUR SPOT, MARKED',
                        style: GoogleFonts.quicksand(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: _sub,
                          letterSpacing: 0.26 * 12.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cloud(double dx, double dy, double w, double opacity) => Positioned(
        left: dx,
        top: dy,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: CustomPaint(
            size: Size(w, w * 0.46),
            painter: _CloudPainter(),
          ),
        ),
      );
}

class _PinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 120;
    final sy = size.height / 150;

    final path = Path()
      ..moveTo(60 * sx, 4 * sy)
      ..cubicTo(34 * sx, 4 * sy, 14 * sx, 24 * sy, 14 * sx, 50 * sy)
      ..cubicTo(14 * sx, 80 * sy, 44 * sx, 112 * sy, 56 * sx, 140 * sy)
      ..cubicTo(58 * sx, 144 * sy, 62 * sx, 144 * sy, 64 * sx, 140 * sy)
      ..cubicTo(76 * sx, 112 * sy, 106 * sx, 80 * sy, 106 * sx, 50 * sy)
      ..cubicTo(106 * sx, 24 * sy, 86 * sx, 4 * sy, 60 * sx, 4 * sy)
      ..close();

    // Drop shadow
    canvas.save();
    canvas.translate(0, 10 * sy);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0x2EAA3732)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );
    canvas.restore();

    canvas.drawPath(path, Paint()..color = const Color(0xFFEE6A63));
    canvas.drawCircle(
      Offset(60 * sx, 50 * sy),
      17 * (sx + sy) / 2,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _PinPainter oldDelegate) => false;
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 150;
    final sy = size.height / 70;

    final back = Paint()..color = const Color(0xFFE7EFEE);
    final stroke = Paint()
      ..color = const Color(0x52969B9B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    final front = Paint()..color = const Color(0xFFEEF4F3);

    void o(double cx, double cy, double rx, double ry, Paint p) =>
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx * sx, cy * sy),
            width: rx * 2 * sx,
            height: ry * 2 * sy,
          ),
          p,
        );

    o(58, 42, 56, 26, back);
    o(58, 42, 56, 26, stroke);
    o(104, 40, 40, 22, back);
    o(104, 40, 40, 22, stroke);
    o(58, 40, 53, 23, front);
    o(104, 38, 37, 19, front);
  }

  @override
  bool shouldRepaint(covariant _CloudPainter oldDelegate) => false;
}
