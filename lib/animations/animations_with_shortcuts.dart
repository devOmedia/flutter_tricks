import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PartyShortcutsApp extends StatelessWidget {
  const PartyShortcutsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PartyShortcutsHome());
  }
}

class PartyShortcutsHome extends StatefulWidget {
  const PartyShortcutsHome({super.key});

  @override
  State<PartyShortcutsHome> createState() => _PartyShortcutsHomeState();
}

class _PartyShortcutsHomeState extends State<PartyShortcutsHome>
    with SingleTickerProviderStateMixin {
  double _partyLevel = 5;
  late AnimationController _controller;
  final _random = Random();
  static const _emojis = ['🎉', '🎊', '💃', '🕺', '🥳', '🍾', '🔥'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _adjustPartyLevel(double delta) {
    setState(() {
      _partyLevel = (_partyLevel + delta).clamp(1, 20);
    });
  }

  List<Widget> _buildRandomEmojis() {
    return List.generate((_partyLevel).toInt(), (index) {
      final emoji = _emojis[_random.nextInt(_emojis.length)];
      final left = _random.nextDouble() * MediaQuery.sizeOf(context).width;
      final top = _random.nextDouble() * MediaQuery.sizeOf(context).height;

      return Positioned(
        left: left,
        top: top,
        child: Text(emoji, style: const TextStyle(fontSize: 32)),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncrementIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const DecrementIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          IncrementIntent: CallbackAction<IncrementIntent>(
            onInvoke: (intent) => _adjustPartyLevel(1),
          ),
          DecrementIntent: CallbackAction<DecrementIntent>(
            onInvoke: (intent) => _adjustPartyLevel(-1),
          ),
        },
        child: Focus(
          autofocus: true,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Scaffold(
                body: Container(
                  color: Color.lerp(
                    Colors.blueAccent,
                    Colors.pinkAccent,
                    _controller.value,
                  ),
                  child: Stack(
                    children: [
                      ..._buildRandomEmojis(),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '🎉 Party Level: ${_partyLevel.toInt()} 🎉\nPress ↑ / ↓ to adjust',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class IncrementIntent extends Intent {
  const IncrementIntent();
}

class DecrementIntent extends Intent {
  const DecrementIntent();
}
