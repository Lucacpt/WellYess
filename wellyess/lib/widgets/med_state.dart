import 'package:flutter/material.dart';

class FarmacoGiornoCard extends StatelessWidget {
  final String nome;
  final String dose;
  final String orario;
  final Color statoColore;

  const FarmacoGiornoCard({
    super.key,
    required this.nome,
    required this.dose,
    required this.orario,
    required this.statoColore,
  });

  @override
  Widget build(BuildContext context) {
    return Center(  // centra orizzontalmente
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 300,  // larghezza massima
          minWidth: 250,  // opzionale, larghezza minima
        ),
        child: SizedBox(
          height: 70,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 8,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(nome, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(dose, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(orario, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          CircleAvatar(radius: 6, backgroundColor: statoColore),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
