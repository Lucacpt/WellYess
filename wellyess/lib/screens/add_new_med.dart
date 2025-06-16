import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/input_field.dart';
import 'package:wellyess/widgets/dropdown_field.dart';
import 'package:wellyess/widgets/time_picker_field.dart';
import 'package:wellyess/widgets/confirm_popup.dart';  // Importa ConfirmDialog

class AggiungiFarmacoPage extends StatefulWidget {
  const AggiungiFarmacoPage({super.key});

  @override
  State<AggiungiFarmacoPage> createState() => _AggiungiFarmacoPageState();
}

class _AggiungiFarmacoPageState extends State<AggiungiFarmacoPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? doseValue;
  String? formaTerapeuticaValue;
  TimeOfDay? orarioValue;
  String? frequenzaValue;

  final List<String> doseOptions = ['10 mg', '20 mg', '50 mg', '100 mg'];
  final List<String> formaOptions = ['Compressa', 'Sciroppo', 'Capsula', 'Iniezione'];
  final List<String> frequenzaOptions = ['1 volta al giorno', '2 volte al giorno', '3 volte al giorno'];

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.pop(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'Aggiungi Farmaco',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 40, thickness: 1.5),

            const Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            InputField(
              controller: nomeController,
              placeholder: 'Inserisci il nome del farmaco',
            ),

            const SizedBox(height: 20),

            const Text('Dose', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            DropdownField(
              options: doseOptions,
              value: doseValue,
              placeholder: 'Seleziona la dose',
              onChanged: (val) => setState(() => doseValue = val),
            ),

            const SizedBox(height: 20),

            const Text('Forma Terapeutica', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            DropdownField(
              options: formaOptions,
              value: formaTerapeuticaValue,
              placeholder: 'Seleziona la forma terapeutica',
              onChanged: (val) => setState(() => formaTerapeuticaValue = val),
            ),

            const SizedBox(height: 20),

            const Text('Orario di assunzione', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            TimePickerField(
              value: orarioValue,
              placeholder: 'Seleziona l\'orario',
              onChanged: (val) => setState(() => orarioValue = val),
            ),

            const SizedBox(height: 20),

            const Text('Note', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            InputField(
              controller: noteController,
              placeholder: 'Inserisci eventuali note',
              maxLines: 3,
            ),

            const SizedBox(height: 20),
            const Divider(height: 40, thickness: 1.5),
            const SizedBox(height: 20),

            CustomMainButton(
              text: 'Salva',
              color: const Color(0xFF5DB47F),
              onTap: () {
                final nomeFarmaco = nomeController.text.trim();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Il farmaco "$nomeFarmaco" è stato salvato con successo')),
                );
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 10),

            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      titleText: 'Vuoi davvero annullare?\nTutte le modifiche andranno perse',
                      cancelButtonText: 'No, riprendi',
                      confirmButtonText: 'Sì, esci',
                      onCancel: () => Navigator.of(context).pop(),
                      onConfirm: () {
                        Navigator.of(context).pop(); // chiude dialog
                        Navigator.of(context).pop(); // torna indietro pagina
                      },
                    ),
                  );
                },
                child: const Text(
                  'Annulla',
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
