import 'package:flutter/material.dart';

class FarmacoGiornoCard extends StatelessWidget {
  final String nome;
  final String? dose;
  final String? orario;
  final Color statoColore;

  const FarmacoGiornoCard({
    super.key,
    required this.nome,
    this.dose,
    this.orario,
    required this.statoColore,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 300,
          minWidth: 250,
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
                  // Nome farmaco - sempre presente
                  Flexible(
                    flex: 4,
                    fit: FlexFit.tight,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        nome,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Spazio e dose (se presente)
                  if (dose != null && dose!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.loose,
                      child: Text(
                        dose!,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],

                  // Spazio e orario + pallino (se presente orario)
                  if (orario != null && orario!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.loose,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              orario!,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 6,
                              backgroundColor: statoColore,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Se orario non presente, mostra solo il pallino all'estrema destra
                    const Spacer(),
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: statoColore,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
