import 'package:flutter/material.dart';
import 'custom_button.dart';

class FarmacoDettagliCard extends StatelessWidget {
  final String nome;
  final String dose;
  final VoidCallback onPressed;

  const FarmacoDettagliCard({
    super.key,
    required this.nome,
    required this.dose,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 300,  // larghezza massima desiderata
          minWidth: 250,  // opzionale
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 8,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$nome $dose', style: const TextStyle(fontSize: 16)),
                CustomButton(text: 'Dettagli', onPressed: onPressed),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
