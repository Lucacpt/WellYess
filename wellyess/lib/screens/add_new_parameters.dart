import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/widgets/confirm_popup.dart';
import 'package:wellyess/widgets/pop_up_conferma.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:wellyess/services/flutter_tts.dart';

// Pagina per aggiungere un nuovo monitoraggio dei parametri vitali
class AggiungiMonitoraggioPage extends StatefulWidget {
  const AggiungiMonitoraggioPage({super.key});

  @override
  State<AggiungiMonitoraggioPage> createState() => _AggiungiMonitoraggioPageState();
}

class _AggiungiMonitoraggioPageState extends State<AggiungiMonitoraggioPage> {
  // Mappa dei controller per ogni parametro (inizializzati a 0)
  final Map<String, TextEditingController> controllers = {
    'SYS': TextEditingController(text: '0'),
    'DIA': TextEditingController(text: '0'),
    'BPM': TextEditingController(text: '0'),
    'HGT': TextEditingController(text: '0'),
    'SpO2': TextEditingController(text: '0'),
  };

  UserType? _userType; // Tipo utente (caregiver, anziano, ecc.)
  bool _isLoading = true; // Stato di caricamento

  @override
  void initState() {
    super.initState();
    _loadUserType(); // Carica il tipo di utente dalle preferenze
  }

  // Carica il tipo di utente dalle SharedPreferences
  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeString = prefs.getString('userType');
    if (mounted) {
      setState(() {
        if (userTypeString != null) {
          _userType =
              UserType.values.firstWhere((e) => e.toString() == userTypeString);
        }
        _isLoading = false;
      });
    }
  }

  // Incrementa il valore del parametro selezionato
  void increment(String key) {
    final value = int.tryParse(controllers[key]!.text) ?? 0;
    controllers[key]!.text = (value + 1).toString();
  }

  // Decrementa il valore del parametro selezionato (non va sotto zero)
  void decrement(String key) {
    final value = int.tryParse(controllers[key]!.text) ?? 0;
    controllers[key]!.text = (value - 1).clamp(0, double.infinity).toInt().toString();
  }

  // Mostra un popup di conferma quando si tenta di uscire senza salvare
  Future<bool> _showExitConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        titleText: 'Vuoi davvero annullare?\nTutti i dati inseriti andranno persi.',
        cancelButtonText: 'No, riprendi',
        confirmButtonText: 'Sì, esci',
        onCancel: () => Navigator.of(context).pop(false),
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
    return result == true;
  }

  // Costruisce il widget per l'inserimento di un parametro (con + e -)
  Widget buildValueInput(String label, String key, double fontSize, bool highContrast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etichetta del parametro
        TappableReader(
          label: label,
          child: Text(label, style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: highContrast ? Colors.black : Colors.black,
          )),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Campo di input numerico
            Expanded(
              child: TappableReader(
                label: '$label campo input',
                child: Container(
                  decoration: BoxDecoration(
                    color: highContrast ? Colors.yellow.shade700 : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: highContrast
                        ? Border.all(color: Colors.black, width: 2)
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: controllers[key],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: fontSize,
                      color: highContrast ? Colors.black : Colors.black,
                    ),
                    onChanged: (val) {
                      // Annuncio vocale se TalkBack attivo
                      if (context.read<AccessibilitaModel>().talkbackEnabled) {
                        TalkbackService.announce('$label: $val');
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Pulsante per decrementare il valore
            TappableReader(
              label: 'Diminuisci $label',
              child: _IncrementDecrementButton(
                icon: Icons.remove,
                onTap: () => decrement(key),
                highContrast: highContrast,
              ),
            ),
            const SizedBox(width: 6),
            // Pulsante per incrementare il valore
            TappableReader(
              label: 'Incrementa $label',
              child: _IncrementDecrementButton(
                icon: Icons.add,
                onTap: () => increment(key),
                highContrast: highContrast,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Salva i parametri inseriti nel database Hive
  void _save() async {
    final entry = ParameterEntry(
      timestamp: DateTime.now(),
      sys: int.parse(controllers['SYS']!.text),
      dia: int.parse(controllers['DIA']!.text),
      bpm: int.parse(controllers['BPM']!.text),
      hgt: int.parse(controllers['HGT']!.text),
      spo2: int.parse(controllers['SpO2']!.text),
    );
    final box = Hive.box<ParameterEntry>('parameters');
    await box.add(entry);

    // Mostra popup di conferma
    await showDialog(
      context: context,
      builder: (_) => const PopUpConferma(
        message: 'Parametri salvati con successo',
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // Libera i controller quando la pagina viene chiusa
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mostra loader se i dati sono in caricamento
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Calcola dimensioni schermo e accessibilità
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final double titleFontSize = (screenWidth * 0.08 * fontSizeFactor).clamp(22.0, 32.0);
    final double fieldFontSize = (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0);

    return WillPopScope(
      onWillPop: _showExitConfirmation, // Intercetta il tasto indietro
      child: BaseLayout(
        pageTitle: 'Aggiungi Monitoraggio',
        userType: _userType,
        onBackPressed: () async {
          if (await _showExitConfirmation()) {
            Navigator.pop(context);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER FISSO
            Center(
              child: TappableReader(
                label: 'Titolo pagina Aggiungi Monitoraggio',
                child: Text(
                  'Aggiungi Monitoraggio',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: highContrast ? Colors.black : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Divider(
              color:Colors.grey,
              thickness: 1
            ),
            // CONTENUTO SCORRIBILE
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Testo informativo per lo scorrimento
                    Row(
                      children: [
                        TappableReader(
                          label: 'Icona informativa',
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 28.0),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: TappableReader(
                            label: 'Testo informativo scorrimento',
                            child: Text(
                              "Scorri verso il basso per compilare tutti i campi.",
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
                    // Campo Minima (SYS)
                    TappableReader(
                      label: 'Sezione Minima (SYS)',
                      child: buildValueInput('Minima (SYS)', 'SYS', fieldFontSize, highContrast),
                    ),
                    const SizedBox(height: 20),
                    // Campo Massima (DIA)
                    TappableReader(
                      label: 'Sezione Massima (DIA)',
                      child: buildValueInput('Massima (DIA)', 'DIA', fieldFontSize, highContrast),
                    ),
                    const SizedBox(height: 20),
                    // Campo Frequenza Cardiaca (BPM)
                    TappableReader(
                      label: 'Sezione Frequenza Cardiaca (BPM)',
                      child: buildValueInput('Frequenza Cardiaca (BPM)', 'BPM', fieldFontSize, highContrast),
                    ),
                    const SizedBox(height: 20),
                    // Campo Glicemia (HGT)
                    TappableReader(
                      label: 'Sezione Glicemia (HGT)',
                      child: buildValueInput('Glicemia (HGT)', 'HGT', fieldFontSize, highContrast),
                    ),
                    const SizedBox(height: 20),
                    // Campo Saturazione (%SpO2)
                    TappableReader(
                      label: 'Sezione Saturazione (%SpO2)',
                      child: buildValueInput('Saturazione (%SpO2)', 'SpO2', fieldFontSize, highContrast),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // FOOTER FISSO: Bottone Salva
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                  .copyWith(bottom: screenHeight * 0.01, top: screenHeight * 0.01),
              child: TappableReader(
                label: 'Bottone Salva monitoraggio',
                child: CustomMainButton(
                  text: 'Salva',
                  color: const Color(0xFF5DB47F),
                  onTap: _save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget per il pulsante di incremento/decremento (+/-)
class _IncrementDecrementButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool highContrast;

  const _IncrementDecrementButton({
    required this.icon,
    required this.onTap,
    required this.highContrast,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: highContrast ? Colors.yellow.shade700 : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: highContrast
                ? Border.all(color: Colors.black, width: 2)
                : null,
          ),
          child: Icon(
            icon,
            color: highContrast ? Colors.black : const Color(0xFF5DB47F), // nero se contrasto attivo
            size: 22,
          ),
        ),
      ),
    );
  }
}