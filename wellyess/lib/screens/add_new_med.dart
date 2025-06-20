import 'package:flutter/material.dart';
import 'package:hive/hive.dart';                        // <-- import
import 'package:wellyess/models/farmaco_model.dart';    // <-- model Hive
import 'package:wellyess/widgets/pop_up_conferma.dart';  // <-- correggi l’import
import '../widgets/base_layout.dart';
import '../widgets/custom_main_button.dart';
import '../widgets/input_field.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/time_picker_field.dart';

class AggiungiFarmacoPage extends StatefulWidget {
  const AggiungiFarmacoPage({super.key});
  @override
  State<AggiungiFarmacoPage> createState() => _AggiungiFarmacoPageState();
}

class _AggiungiFarmacoPageState extends State<AggiungiFarmacoPage> {
  final nomeController = TextEditingController();
  String? doseValue;
  String? formaTerapeuticaValue;
  TimeOfDay? orarioValue;
  String? frequenzaValue;

  final List<String> doseOptions = ['10 mg', '20 mg', '50 mg', '100 mg'];
  final List<String> formaOptions = ['Compressa','Sciroppo','Capsula','Iniezione'];
  final List<String> frequenzaOptions = ['1 volta al giorno','2 volte al giorno','3 volte al giorno'];

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: Text('Aggiungi Farmaco', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
            const Divider(height: 40, thickness: 1.5),
            const Text('Nome', style: TextStyle(fontWeight: FontWeight.bold)),
            InputField(controller: nomeController, placeholder: 'Nome del farmaco'),
            const SizedBox(height: 20),
            const Text('Dose', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownField(options: doseOptions, value: doseValue, placeholder: 'Seleziona dose', onChanged: (v)=>setState(()=>doseValue=v)),
            const SizedBox(height: 20),
            const Text('Forma Terapeutica', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownField(options: formaOptions, value: formaTerapeuticaValue, placeholder: 'Seleziona forma', onChanged: (v)=>setState(()=>formaTerapeuticaValue=v)),
            const SizedBox(height: 20),
            const Text('Orario', style: TextStyle(fontWeight: FontWeight.bold)),
            TimePickerField(value: orarioValue, placeholder: 'Seleziona orario', onChanged: (v)=>setState(()=>orarioValue=v)),
            const SizedBox(height: 20),
            const Text('Frequenza', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownField(options: frequenzaOptions, value: frequenzaValue, placeholder: 'Seleziona frequenza', onChanged: (v)=>setState(()=>frequenzaValue=v)),
            const SizedBox(height: 40),
            CustomMainButton(
              text: 'Salva',
              color: const Color(0xFF5DB47F),
              onTap: () async {
                final box = Hive.box<FarmacoModel>('farmaci');
                final nuovo = FarmacoModel(
                  nome: nomeController.text.trim(),
                  dose: doseValue!,
                  formaTerapeutica: formaTerapeuticaValue!,
                  orario: orarioValue!.format(context),
                  frequenza: frequenzaValue!,
                );
                await box.add(nuovo);

                // mostra il dialog di conferma
                await showDialog(
                  context: context,
                  builder: (_) => const PopUpConferma(
                    message: 'Farmaco aggiunto con successo',
                  ),
                );

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
