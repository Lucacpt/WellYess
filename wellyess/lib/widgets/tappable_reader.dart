import 'package:flutter/material.dart';
import 'package:wellyess/services/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class TappableReader extends StatefulWidget {
  final Widget child;
  final String label;
  const TappableReader({
    Key? key,
    required this.child,
    required this.label,
  }) : super(key: key);

  @override
  State<TappableReader> createState() => _TappableReaderState();
}

class _TappableReaderState extends State<TappableReader> {
  bool _highlight = false;

  Future<void> _read() async {
    final enabled = context.read<AccessibilitaModel>().talkbackEnabled;
    if (!enabled) return;
    setState(() => _highlight = true);
    await TalkbackService.announce(widget.label);
    // rimuovi bordo dopo un breve delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _highlight = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
  behavior: HitTestBehavior.opaque,     // intercetta sempre il gesto
      onTap: () => _read(),                 // singolo tap per leggere
      onDoubleTap: () => _read(),           // doppio tap idem
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(
            color: _highlight ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Semantics(
          label: widget.label,
          child: widget.child,
        ),
      ),
    );
  }
}