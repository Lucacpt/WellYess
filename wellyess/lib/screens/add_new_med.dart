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

  UserType? _userType;
  bool _isLoading = true;

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
    _loadUserType();
  }

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BaseLayout(
      userType: _userType,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                  .copyWith(bottom: screenHeight * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                      child: Text('Aggiungi Farmaco',
                          style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold))),
                  Divider(
                      height: screenHeight * 0.05, thickness: 1.5),
                  // Testo informativo per lo scorrimento
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: screenWidth * 0.06),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: Text(
                          "Scorri verso il basso per compilare tutti i campi.",
                          style: TextStyle(
                            fontSize: screenWidth * 0.038,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text('Nome',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04)),
                  InputField(
                      controller: nomeController,
                      placeholder: 'Nome del farmaco'),
                  SizedBox(height: screenHeight * 0.025),
                  Text('Dose',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04)),
                  DropdownField(
                      options: doseOptions,
                      value: doseValue,
                      placeholder: 'Seleziona dose',
                      onChanged: (v) => setState(() => doseValue = v)),
                  SizedBox(height: screenHeight * 0.025),
                  Text('Forma Terapeutica',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04)),
                  DropdownField(
                      options: formaOptions,
                      value: formaTerapeuticaValue,
                      placeholder: 'Seleziona forma',
                      onChanged: (v) =>
                          setState(() => formaTerapeuticaValue = v)),
                  SizedBox(height: screenHeight * 0.025),
                  Text('Orario',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04)),
                  TimePickerField(
                      value: orarioValue,
                      placeholder: 'Seleziona orario',
                      onChanged: (v) => setState(() => orarioValue = v)),
                  SizedBox(height: screenHeight * 0.025),
                  Text('Frequenza',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04)),
                  DropdownField(
                      options: frequenzaOptions,
                      value: frequenzaValue,
                      placeholder: 'Seleziona frequenza',
                      onChanged: (v) => setState(() => frequenzaValue = v)),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                .copyWith(bottom: screenHeight * 0.01, top: screenHeight * 0.01),
            child: CustomMainButton(
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

                await showDialog(
                  context: context,
                  builder: (_) => const PopUpConferma(
                    message: 'Farmaco aggiunto con successo',
                  ),
                );

                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}