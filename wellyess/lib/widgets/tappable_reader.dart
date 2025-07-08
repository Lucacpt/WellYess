import 'package:flutter/material.dart';
import 'package:wellyess/services/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// TappableReader è un widget che permette di leggere ad alta voce una label associata al child
// quando viene toccato (tap o doppio tap), utile per l'accessibilità (TalkBack)
class TappableReader extends StatefulWidget {
  final Widget child; // Widget figlio da rendere "tappabile"
  final String label; // Testo da leggere tramite TTS

  const TappableReader({
    Key? key,
    required this.child,
    required this.label,
  }) : super(key: key);

  @override
  State<TappableReader> createState() => _TappableReaderState();
}

class _TappableReaderState extends State<TappableReader> {
  bool _highlight = false; // Stato per mostrare il bordo blu temporaneo

  // Funzione che legge la label tramite TTS se TalkBack è attivo
  Future<void> _read() async {
    final enabled = context.read<AccessibilitaModel>().talkbackEnabled;
    if (!enabled) return;
    setState(() => _highlight = true); // Mostra bordo blu
    await TalkbackService.announce(widget.label); // Legge la label
    // Rimuove il bordo blu dopo un breve delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _highlight = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,     // intercetta sempre il gesto, anche su aree vuote
      onTap: () => _read(),                 // singolo tap per leggere la label
      onDoubleTap: () => _read(),           // doppio tap idem (compatibilità accessibilità)
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(
            color: _highlight ? Colors.blue : Colors.transparent, // Bordo blu se evidenziato
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Semantics(
          label: widget.label, // Etichetta per screen reader
          child: widget.child, // Widget figlio
        ),
      ),
    );
  }
}