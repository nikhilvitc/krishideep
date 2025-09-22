import 'package:flutter/material.dart';

class VoiceCommandButton extends StatefulWidget {
  final Function(String) onVoiceResult;
  final Function()? onStartListening;
  final Function()? onStopListening;

  const VoiceCommandButton({
    super.key,
    required this.onVoiceResult,
    this.onStartListening,
    this.onStopListening,
  });

  @override
  State<VoiceCommandButton> createState() => _VoiceCommandButtonState();
}

class _VoiceCommandButtonState extends State<VoiceCommandButton>
    with TickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    _animationController.repeat(reverse: true);
    widget.onStartListening?.call();

    // Simulate voice recognition for demo
    _simulateVoiceRecognition();
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _animationController.stop();
    _animationController.reset();
    widget.onStopListening?.call();
  }

  void _simulateVoiceRecognition() {
    // Simulate voice recognition delay
    Future.delayed(const Duration(seconds: 2), () {
      if (_isListening) {
        _stopListening();
        // Simulate different voice commands
        final commands = [
          'crop advice',
          'weather forecast',
          'government schemes',
          'financial help',
          'disease detection',
          'market prices',
        ];
        final randomCommand =
            commands[DateTime.now().millisecond % commands.length];
        widget.onVoiceResult(randomCommand);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isListening ? _stopListening : _startListening,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? _scaleAnimation.value : 1.0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening ? Colors.red : Colors.blue.shade600,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? Colors.red : Colors.blue.shade600)
                        .withOpacity(0.3),
                    blurRadius: _isListening ? 15 : 8,
                    spreadRadius: _isListening ? 3 : 1,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}
