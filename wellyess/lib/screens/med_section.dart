import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/models/user_model.dart';

import 'package:wellyess/screens/all_med.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/confirm_popup.dart';
import 'package:wellyess/widgets/med_legenda.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/med_card.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';

// Pagina principale che mostra i farmaci del giorno e permette di segnare l'assunzione
class FarmaciPage extends StatefulWidget {
  final int? farmacoKeyToShow; // Chiave opzionale per evidenziare un farmaco

  const FarmaciPage({Key? key, this.farmacoKeyToShow}) : super(key: key);

  @override
  State<FarmaciPage> createState() => _FarmaciPageState();
}

class _FarmaciPageState extends State<FarmaciPage> {
  final Map<dynamic, Color> _statiFarmaci = {}; // Mappa che tiene traccia dello stato di ogni farmaco (assunto, saltato, in attesa)
  late final Box<FarmacoModel> _farmaciBox;     // Box Hive che contiene i farmaci
  UserType? _userType;                          // Tipo utente (caregiver, anziano, ecc.)
  bool _isLoading = true;                       // Stato di caricamento

  @override
  void initState() {
    super.initState();
    _initializePage(); // Inizializza la pagina caricando dati e stato utente
  }

  // Inizializza la pagina: carica tipo utente e stato dei farmaci
  Future<void> _initializePage() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeString = prefs.getString('userType');
    _farmaciBox = Hive.box<FarmacoModel>('farmaci');

    // Inizializza la mappa degli stati dei farmaci in base al valore salvato
    for (var key in _farmaciBox.keys) {
      final f = _farmaciBox.get(key);
      _statiFarmaci[key] = (f?.assunto == true)
          ? Colors.green
          : (f?.assunto == false)
              ? Colors.red
              : Colors.orange;
    }

    if (userTypeString != null) {
      _userType =
          UserType.values.firstWhere((e) => e.toString() == userTypeString);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Funzione helper per interpretare qualsiasi stringa di orario
  DateTime? _parseTime(String timeString) {
    try {
      return DateFormat("h:mm a").parse(timeString);
    } catch (e) {
      try {
        return DateFormat("HH:mm").parse(timeString);
      } catch (e) {
        return null;
      }
    }
  }

  // Mostra un dialog di conferma per segnare l'assunzione o il salto di un farmaco
  void _showConfirmationDialog(int key) {
    final farmaco = _farmaciBox.get(key)!;
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        titleText: 'Hai assunto ${farmaco.nome}?',
        cancelButtonText: 'No',
        confirmButtonText: 'Sì',
        onCancel: () {
          Navigator.of(ctx).pop();              // Chiude il dialog
          farmaco.assunto = false;              // Segna come saltato
          farmaco.save();
          setState(() => _statiFarmaci[key] = Colors.red);
        },
        onConfirm: () {
          Navigator.of(ctx).pop();
          farmaco.assunto = true;               // Segna come assunto
          farmaco.save();
          setState(() => _statiFarmaci[key] = Colors.green);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Mostra loader se i dati sono in caricamento
    if (_isLoading) {
      return BaseLayout(
        pageTitle: 'Farmaci',
        userType: _userType,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final isCaregiver = _userType == UserType.caregiver;

    return BaseLayout(
      pageTitle: 'Farmaci', // Titolo della pagina nella barra superiore
      userType: _userType,
      currentIndex: 1,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER FISSO
          SizedBox(height: screenHeight * 0.01),
          TappableReader(
            label: 'Titolo pagina Farmaci',
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Farmaci',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (screenWidth * 0.08 * fontSizeFactor),
                  fontWeight: FontWeight.bold,
                  color: highContrast ? Colors.black : Colors.black87,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          // CONTENUTO SCORRIBILE
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                    .copyWith(bottom: screenHeight * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Titolo sezione farmaci di oggi
                    TappableReader(
                      label: 'Sezione Farmaci di Oggi',
                      child: Text(
                        'Farmaci di Oggi',
                        style: TextStyle(
                          fontSize: (screenWidth * 0.055 * fontSizeFactor),
                          fontWeight: FontWeight.bold,
                          color: highContrast ? Colors.black : Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Legenda dei colori per lo stato dei farmaci
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LegendaPallino(text: 'Assunto', color: Colors.green),
                        LegendaPallino(text: 'In attesa', color: Colors.orange),
                        LegendaPallino(text: 'Saltato', color: Colors.red),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Testo informativo su come cambiare lo stato di assunzione
                    Row(
                      children: [
                        TappableReader(
                          label: 'Icona informativa cambio stato',
                          child: Icon(Icons.info_outline,
                              color: Colors.blue.shade700,
                              size: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 28.0)),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: TappableReader(
                            label: 'Testo informativo cambio stato farmaco',
                            child: Text(
                              "Tocca un farmaco per cambiare lo stato di assunzione.",
                              style: TextStyle(
                                fontSize: (screenWidth * 0.038 * fontSizeFactor).clamp(15.0, 24.0),
                                fontStyle: FontStyle.italic,
                                color: highContrast ? Colors.black : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Lista dei farmaci ordinati per orario
                    ValueListenableBuilder<Box<FarmacoModel>>(
                      valueListenable: _farmaciBox.listenable(),
                      builder: (context, box, _) {
                        final keys = box.keys.toList()..sort(
                          (a, b) {
                            final farmacoA = box.get(a);
                            final farmacoB = box.get(b);
                            if (farmacoA == null || farmacoB == null) return 0;

                            final timeA = _parseTime(farmacoA.orario);
                            final timeB = _parseTime(farmacoB.orario);

                            if (timeA == null || timeB == null) return 0;
                            return timeA.compareTo(timeB);
                          },
                        );
                        if (keys.isEmpty) {
                          // Messaggio se non ci sono farmaci
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.05),
                              child: Text(
                                'Nessun farmaco aggiunto.',
                                style: TextStyle(
                                  fontSize: (screenWidth * 0.045 * fontSizeFactor),
                                  color: highContrast ? Colors.black : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          );
                        }

                        // Costruisce la lista dei farmaci
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: keys.length,
                          itemBuilder: (ctx, i) {
                            final key = keys[i];
                            final f = box.get(key)!;

                            final orario24h = _parseTime(f.orario);
                            final orarioDaMostrare = orario24h != null
                                ? DateFormat('HH:mm').format(orario24h)
                                : f.orario;

                            return Column(
                              key: ValueKey(key),
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TappableReader(
                                  label: 'Farmaco ${f.nome}, dose ${f.dose}, orario ${orarioDaMostrare}',
                                  child: FarmacoCard(
                                    statoColore: _statiFarmaci[key] ?? Colors.orange,
                                    orario: orarioDaMostrare,
                                    nome: f.nome,
                                    dose: f.dose,
                                    onTap: () => _showConfirmationDialog(key),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.012),
                  ],
                ),
              ),
            ),
          ),
          // FOOTER FISSO: Bottone per vedere tutti i farmaci
          SizedBox(height: screenHeight * 0.02),
          TappableReader(
            label: 'Bottone Vedi tutti i farmaci',
            child: CustomMainButton(
              text: 'Vedi tutti i farmaci',
              color: const Color(0xFF5DB47F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllMedsPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}