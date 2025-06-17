import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/base_layout.dart';
// Rimuovi: import 'package:wellyess/screens/alimentazione.dart'; // Non più necessario per la navigazione tra tab

// Rinomina la classe e rendila StatefulWidget
class ConsigliSalutePage extends StatefulWidget {
  const ConsigliSalutePage({super.key});

  @override
  State<ConsigliSalutePage> createState() => _ConsigliSalutePageState();
}

class _ConsigliSalutePageState extends State<ConsigliSalutePage> {
  int _currentTabIndex = 0; // 0 per Attività Fisica, 1 per Alimentazione
  Offset _slideBeginOffset = const Offset(1.0, 0.0); // Offset iniziale per l'animazione

  Widget _buildAttivitaFisicaContent() {
    return ListView(
      key: const ValueKey('attivita_fisica_list'), // Chiave per AnimatedSwitcher
      children: const [
        _HealthTipCard(
          svgAssetPath: 'assets/icons/Vector.svg',
          title: 'Camminata leggera',
          subtitle: 'Almeno 30 minuti al giorno',
        ),
        _HealthTipCard(
          svgAssetPath: 'assets/icons/dolce.svg',
          title: 'Stretching dolce',
          subtitle: 'Esercizi di mobilità',
        ),
        _HealthTipCard(
          svgAssetPath: 'assets/icons/compass.svg',
          title: 'Orari consigliati',
          subtitle: 'Evitare le ore calde',
        ),
        _HealthTipCard(
          svgAssetPath: 'assets/icons/divano.svg',
          title: 'Esercizi da seduti',
          subtitle: 'Attiva la circolazione',
        ),
      ],
    );
  }

  Widget _buildAlimentazioneContent() {
    return ListView(
      key: const ValueKey('alimentazione_list'), // Chiave per AnimatedSwitcher
      children: const [
        _HealthTipCard(
          svgAssetPath: 'assets/icons/mela.svg',
          title: 'Frutta e verdura',
          subtitle: 'Cinque porzioni al giorno',
        ),
        _HealthTipCard(
          svgAssetPath: 'assets/icons/fish.svg',
          title: 'Proteine magre',
          subtitle: 'Pesce, legumi, carni bianche',
        ),
        _HealthTipCard(
          svgAssetPath: 'assets/icons/no_sugar.svg',
          title: 'Limitare lo zucchero',
          subtitle: 'Evitare bevande zuccherate',
        ),
        _HealthTipCard(
          svgAssetPath: 'assets/icons/bottle.svg',
          title: 'Bere regolarmente',
          subtitle: 'Mantieni il corpo idratato',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Consigli Di Salute',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 12),
            // Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (_currentTabIndex == 1) { // Se si proviene da Alimentazione
                          setState(() {
                            _slideBeginOffset = const Offset(-1.0, 0.0); // Attività Fisica scorre da sinistra
                            _currentTabIndex = 0;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: _currentTabIndex == 0
                            ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.green.shade700,
                                    width: 3,
                                  ),
                                ),
                              )
                            : null,
                        child: Center(
                          child: Text(
                            'Attività Fisica',
                            style: TextStyle(
                              fontSize: 15,
                              color: _currentTabIndex == 0
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (_currentTabIndex == 0) { // Se si proviene da Attività Fisica
                           setState(() {
                            _slideBeginOffset = const Offset(1.0, 0.0); // Alimentazione scorre da destra
                            _currentTabIndex = 1;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: _currentTabIndex == 1
                            ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.green.shade700,
                                    width: 3,
                                  ),
                                ),
                              )
                            : null,
                        child: Center(
                          child: Text(
                            'Alimentazione',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _currentTabIndex == 1
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final tween = Tween<Offset>(begin: _slideBeginOffset, end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeInOut));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                child: _currentTabIndex == 0
                    ? _buildAttivitaFisicaContent()
                    : _buildAlimentazioneContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _HealthTipCard extends StatelessWidget {
  final String svgAssetPath;
  final String title;
  final String subtitle;

  const _HealthTipCard({
    required this.svgAssetPath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Aggiunto Padding orizzontale per ridurre la larghezza della Card
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0), // Ridotto per allargare la card
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 14), // Margine tra le card
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          leading: SvgPicture.asset(
            svgAssetPath,
            height: 40,
            width: 40,
            colorFilter: ColorFilter.mode(Colors.green.shade700, BlendMode.srcIn),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 167, 167, 167),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}