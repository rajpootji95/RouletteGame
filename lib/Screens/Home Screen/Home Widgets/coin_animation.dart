import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roullet_app/Helper_Constants/Images_path.dart';


class FlyCoinAnimation extends StatefulWidget {
  const FlyCoinAnimation({super.key});

  @override
  State<FlyCoinAnimation> createState() => FlyCoinAnimationState();
}

class FlyCoinAnimationState extends State<FlyCoinAnimation> {
  bool _animationSwitch = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Stack(
              children: [
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: BaseAnimationWidget(
                    type: AnimationType.OFFSET,
                    duration: const Duration(seconds: 1),
                    body: const Icon(Icons.attach_money),
                    offset: Offset(-width, 0),
                    offsetType: OffsetType.Left,
                    animationSwitch: () => _animationSwitch,
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: BaseAnimationWidget(
                    type: AnimationType.OFFSET,
                    duration: const Duration(seconds: 1),
                    body: const Icon(Icons.attach_money),
                    offset: Offset(-width, -height),
                    offsetType: OffsetType.UP,
                    animationSwitch: () => _animationSwitch,
                  ),
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: _animationSwitch
            ? BaseAnimationWidget(
          type: AnimationType.ROTATION,
          duration: const Duration(seconds: 1),
          body:  Image.asset(ImagesPath.coinForeGroundImage),
          offset: Offset(-width, 0),
          offsetType: OffsetType.Left,
          rotationValue: pi,
          animationSwitch: () => _animationSwitch,
        )
            : BaseAnimationWidget(
          type: AnimationType.ROTATION,
          duration: const Duration(seconds: 1),
          body: Image.asset(ImagesPath.coinForeGroundImage),
          offset: Offset(-width, 0),
          offsetType: OffsetType.Left,
          rotationValue: pi,
          animationSwitch: () => _animationSwitch,
        ),
        onPressed: () {
          _animationSwitch = !_animationSwitch;
          setState(() {});
        },
      ),
    );
  }
}

enum AnimationType {
  ROTATION,
  OFFSET,
}

enum OffsetType {
  UP,
  Left,
}

typedef AnimationSwitch = bool Function();

class BaseAnimationWidget extends StatefulWidget {
  const BaseAnimationWidget(
      {Key? key,
        required this.type,
        required this.body,
        this.animationSwitch,
        this.rotationValue,
        this.offset,
        this.duration,
        this.offsetType})
      : assert(type == AnimationType.ROTATION
      ? rotationValue != null
      : type == AnimationType.OFFSET
      ? offset != null && offsetType != null
      : true),
        super(key: key);
  final AnimationSwitch? animationSwitch;
  final Widget body;
  final Offset? offset;
  final double? rotationValue;
  final AnimationType type;
  final Duration? duration;
  final OffsetType? offsetType;
  @override
  State<BaseAnimationWidget> createState() => _BaseAnimationWidgetState();
}

class _BaseAnimationWidgetState extends State<BaseAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: widget.duration ?? const Duration(milliseconds: 300),
        vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Offset get _offset => widget.offsetType == OffsetType.UP
      ? Offset(
      widget.offset!.dx*_animationController.value, widget.offset!.dy * _animationController.value)
      : Offset(
      widget.offset!.dx * _animationController.value, widget.offset!.dy);
  @override
  Widget build(BuildContext context) {
    if (widget.animationSwitch == null) {
      DoNothingAction();
    } else if (mounted && widget.animationSwitch!()) {
      _animationController.forward();
    } else if (mounted && !widget.animationSwitch!()) {
      _animationController.reverse();
    }
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return widget.type == AnimationType.ROTATION
              ? Transform.rotate(
              angle: widget.rotationValue! * _animationController.value,
              child: widget.body)
              : Transform.translate(
            offset: _offset,
            child: widget.body,
          );
        });
  }
}



class CoinAnimation extends StatefulWidget {
  const CoinAnimation({super.key});

  @override
  _CoinAnimationState createState() => _CoinAnimationState();
}

class _CoinAnimationState extends State<CoinAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..forward()
      ..addListener(() {
        if (_controller.isCompleted) {
          _controller.repeat();
        }
      });

    _opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Animation'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Coins icon
                const Icon(
                  Icons.attach_money,
                  size: 100,
                ),
                // Flashing light effect
                Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.7),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}