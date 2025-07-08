import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/widgets/pop_up_conferma.dart';
import '../widgets/base_layout.dart';
import '../widgets/custom_main_button.dart';
import '../widgets/input_field.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/time_picker_field.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/confirm_popup.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:wellyess/services/flutter_tts.dart';

// Pagina per aggiungere un nuovo farmaco
class AggiungiFarmacoPage extends StatefulWidget {
  const AggiungiFarmacoPage({super.key});
  @override
  State<AggiungiFarmacoPage> createState() => _AggiungiFarmacoPageState();
}

class _AggiungiFarmacoPageState extends State<AggiungiFarmacoPage> {
  // Controller per il campo nome farmaco
  final nomeController = TextEditingController();
  // Variabili per i valori selezionati nei vari campi
  String? doseValue;
  String? formaTerapeuticaValue;
  TimeOfDay? orarioValue;
  String? frequenzaValue;

  UserType? _userType; // Tipo utente (caregiver, anziano, ecc.)
  bool _isLoading = true; // Stato di caricamento

  // Opzioni disponibili per i vari campi
  final List<String> doseOptions = ['10 mg', '20 mg', '50 mg', '100 mg'];
  final List<String> formaOptions = [
    'Compressa',
    'Sciroppo',
    'Capsula',
    'Iniezione'
  ];
  final List<String> frequenzaOptions = [
    '1 volta al giorno',
    '2 volte al giorno',
    '3 volte al giorno'
  ];

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

  @override
  Widget build(BuildContext context) {
    // Ottieni dimensioni schermo per layout responsivo
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità: recupera i valori dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Mostra loader se i dati sono in caricamento
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WillPopScope(
      onWillPop: _showExitConfirmation, // Intercetta il tasto indietro
      child: BaseLayout(
        pageTitle: 'Aggiungi Farmaco',
        userType: _userType,
        onBackPressed: () async {
          if (await _showExitConfirmation()) {
            Navigator.of(context).pop();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER FISSO
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: TappableReader(
                label: 'Titolo pagina Aggiungi Farmaco',
                child: Text(
                  'Aggiungi Farmaco',
                  style: TextStyle(
                    fontSize: (screenWidth * 0.08 * fontSizeFactor).clamp(22.0, 36.0),
                    fontWeight: FontWeight.bold,
                    color: highContrast ? Colors.black : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
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
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                    .copyWith(bottom: screenHeight * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Testo informativo per lo scorrimento
                    Row(
                      children: [
                        TappableReader(
                          label: 'Icona informativa',
                          child: Icon(Icons.info_outline,
                              color: Colors.blue.shade700,
                              size: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 28.0)),
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
                    // Campo Nome
                    TappableReader(
                      label: 'Etichetta Nome',
                      child: Text('Nome',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0),
                              color: Colors.black)),
                    ),
                    Semantics(
                      textField: true,
                      label: 'Nome del farmaco',
                      hint: 'Digita il nome del farmaco',
                      child: InputField(
                        controller: nomeController,
                        placeholder: 'Nome del farmaco',
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Campo Dose
                    TappableReader(
                      label: 'Etichetta Dose',
                      child: Text('Dose',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0),
                              color: highContrast ? Colors.black : Colors.black)),
                    ),
                    Semantics(
                      button: true,
                      label: doseValue != null
                        ? 'Dose selezionata $doseValue. Doppio tap per cambiare.'
                        : 'Nessuna dose selezionata, doppio tap per aprire il menu.',
                      child: DropdownButton<String>(
                        value: doseValue,
                        isExpanded: true,
                        hint: Text('Seleziona dose'),
                        onChanged: (v) {
                          setState(() => doseValue = v);
                          if (access.talkbackEnabled) {
                            TalkbackService.announce('Dose selezionata $v');
                          }
                        },
                        items: doseOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt,
                            child: Semantics(
                              button: true,
                              label: opt,
                              child: Text(opt),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Campo Forma Terapeutica
                    TappableReader(
                      label: 'Etichetta Forma Terapeutica',
                      child: Text('Forma Terapeutica',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0),
                              color: highContrast ? Colors.black : Colors.black)),
                    ),
                    Semantics(
                      button: true,
                      label: formaTerapeuticaValue != null
                        ? 'Forma terapeutica selezionata $formaTerapeuticaValue. Doppio tap per cambiare.'
                        : 'Nessuna forma selezionata, doppio tap per aprire il menu.',
                      child: DropdownButton<String>(
                        value: formaTerapeuticaValue,
                        isExpanded: true,
                        hint: const Text('Seleziona forma'),
                        onChanged: (v) {
                          setState(() => formaTerapeuticaValue = v);
                          if (access.talkbackEnabled) {
                            TalkbackService.announce('Forma terapeutica selezionata $v');
                          }
                        },
                        items: formaOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt,
                            child: Semantics(
                              button: true,
                              label: opt,
                              child: Text(opt),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Campo Orario
                    TappableReader(
                      label: 'Etichetta Orario',
                      child: Text('Orario',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0),
                              color: highContrast ? Colors.black : Colors.black)),
                    ),
                    Semantics(
                      button: true,
                      label: orarioValue != null
                        ? 'Orario selezionato ${orarioValue!.format(context)}. Doppio tap per cambiare.'
                        : 'Nessun orario selezionato, doppio tap per aprire il selettore.',
                      child: TimePickerField(
                        value: orarioValue,
                        placeholder: 'Seleziona orario',
                        onChanged: (v) {
                          setState(() => orarioValue = v);
                          if (access.talkbackEnabled) {
                            TalkbackService.announce('Orario selezionato ${v!.format(context)}');
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Campo Frequenza
                    TappableReader(
                      label: 'Etichetta Frequenza',
                      child: Text('Frequenza',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0),
                              color: highContrast ? Colors.black : Colors.black)),
                    ),
                    Semantics(
                      button: true,
                      label: frequenzaValue != null
                        ? 'Frequenza selezionata $frequenzaValue. Doppio tap per cambiare.'
                        : 'Nessuna frequenza selezionata, doppio tap per aprire il menu.',
                      child: DropdownButton<String>(
                        value: frequenzaValue,
                        isExpanded: true,
                        hint: Text('Seleziona frequenza'),
                        onChanged: (v) {
                          setState(() => frequenzaValue = v);
                          if (access.talkbackEnabled) {
                            TalkbackService.announce('Frequenza selezionata $v');
                          }
                        },
                        items: frequenzaOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt,
                            child: Semantics(
                              button: true,
                              label: opt,
                              child: Text(opt),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
            // Bottone Salva in fondo alla pagina
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                  .copyWith(bottom: screenHeight * 0.01, top: screenHeight * 0.01),
              child: TappableReader(
                label: 'Bottone Salva Farmaco',
                child: CustomMainButton(
                  text: 'Salva',
                  color: const Color(0xFF5DB47F),
                  onTap: () async {
                    // 1. Controllo di validità per evitare crash
                    if (nomeController.text.trim().isEmpty ||
                        doseValue == null ||
                        formaTerapeuticaValue == null ||
                        orarioValue == null ||
                        frequenzaValue == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Per favore, compila tutti i campi.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Interrompe il salvataggio se i campi sono vuoti
                    }

                    // 2. Creazione del modello del farmaco
                    final orarioString = orarioValue!.format(context);
                    final nuovoFarmaco = FarmacoModel(
                      nome: nomeController.text.trim(),
                      dose: doseValue!,
                      formaTerapeutica: formaTerapeuticaValue!,
                      orario: orarioString,
                      frequenza: frequenzaValue!,
                    );

                    // 3. Salvataggio in Hive e recupero della chiave
                    final box = Hive.box<FarmacoModel>('farmaci');
                    final key = await box.add(nuovoFarmaco);

                    // 4. Pianificazione automatica della notifica
                    await scheduleFarmacoNotification(
                      key,
                      nuovoFarmaco.nome,
                      nuovoFarmaco.dose,
                      nuovoFarmaco.orario,
                    );

                    // 5. Conferma e navigazione
                    if (!mounted) return;
                    await showDialog(
                      context: context,
                      builder: (_) => const PopUpConferma(
                        message: 'Farmaco aggiunto e notifica pianificata!',
                      ),
                    );

                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}