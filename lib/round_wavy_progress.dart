library round_wavy_progress;

import 'package:flutter/material.dart';
import 'package:round_wavy_progress/painter/round_base_painter.dart';
import 'package:round_wavy_progress/painter/round_progress_painter.dart';
import 'package:round_wavy_progress/painter/wavy_painter.dart';
import 'package:round_wavy_progress/progress_controller.dart';

class RoundWavyProgress extends StatefulWidget {
  RoundWavyProgress(this.progress, this.radius, this.controller,
      {Key? key,
      this.mainColor,
      this.secondaryColor,
      this.roundSideColor = Colors.grey,
      this.roundProgressColor = Colors.white})
      : super(key: key);

  final double progress;
  final double radius;
  final ProgressController controller;
  final Color? mainColor;
  final Color? secondaryColor;
  final Color roundSideColor;
  final Color roundProgressColor;

  @override
  _RoundWavyProgressState createState() => _RoundWavyProgressState();
}

class _RoundWavyProgressState extends State<RoundWavyProgress>
    with TickerProviderStateMixin {
  late AnimationController wareController;
  late AnimationController mainController;
  late AnimationController secondController;

  late Animation<double> waveAnimation;
  late Animation<double> mainAnimation;
  late Animation<double> secondAnimation;

  double currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.stream.listen((event) {
      print(event);
      wareController.reset();
      waveAnimation = Tween(begin: currentProgress, end: event as double)
          .animate(wareController);
      currentProgress = event;
      wareController.forward();
    });

    wareController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    mainController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3200),
    );

    secondController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1800),
    );

    waveAnimation = Tween(begin: currentProgress, end: widget.progress)
        .animate(wareController);
    mainAnimation =
        Tween(begin: 0.0, end: widget.radius * 2).animate(mainController);
    secondAnimation =
        Tween(begin: widget.radius * 2, end: 0.0).animate(secondController);

    wareController.forward();
    mainController.repeat();
    secondController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
      return AnimatedBuilder(
          animation: mainAnimation,
          builder: (BuildContext ctx, Widget? child) {
            return AnimatedBuilder(
                animation: secondAnimation,
                builder: (BuildContext ctx, Widget? child) {
                  return AnimatedBuilder(
                      animation: waveAnimation,
                      builder: (BuildContext ctx, Widget? child) {
                        return Stack(
                          children: [
                            RepaintBoundary(
                              child: CustomPaint(
                                size: viewportSize,
                                painter: WavyPainter(
                                    waveAnimation.value,
                                    mainAnimation.value,
                                    widget.mainColor ??
                                        Theme.of(context).primaryColor),
                                child: RepaintBoundary(
                                  child: CustomPaint(
                                    size: viewportSize,
                                    painter: WavyPainter(
                                        waveAnimation.value,
                                        secondAnimation.value,
                                        widget.secondaryColor ??
                                            Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5)),
                                    child: RepaintBoundary(
                                      child: CustomPaint(
                                        size: viewportSize,
                                        painter: RoundBasePainter(
                                            widget.roundSideColor),
                                        child: RepaintBoundary(
                                          child: CustomPaint(
                                            size: viewportSize,
                                            painter: RoundProgressPainter(
                                                widget.roundProgressColor,
                                                waveAnimation.value),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                '${(waveAnimation.value * 100).toStringAsFixed(2)}%',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: widget.roundProgressColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      });
                });
          });
    });
  }
}
