import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/services/flutter_tts.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  int _currentStep = 0;
  final List<Step> _steps = [
    Step(
      title: TappableReader(
        label: 'Aggiungi Farmaco',
        child: Text('Aggiungi Farmaco'),
      ),
      content: TappableReader(
        label: 'Nella pagina Tutta la Terapia, tocca + per aggiungere farmaco',
        child: Text('Nella pagina “Tutta la Terapia”, tocca il pulsante + per inserire un nuovo farmaco.'),
      ),
      isActive: true,
    ),
    Step(
      title: TappableReader(
        label: 'Compila il farmaco',
        child: Text('Compila il farmaco'),
      ),
      content: TappableReader(
        label: 'Inserisci nome, dose, forma terapeutica e tocca Salva',
        child: Text('Inserisci nome, dose, forma terapeutica e tocca “Salva”.'),
      ),
      isActive: true,
    ),
    Step(
      title: TappableReader(
        label: 'Aggiungi Visita',
        child: Text('Aggiungi Visita'),
      ),
      content: TappableReader(
        label: 'Vai su Agenda Medica e tocca + per aggiungere visita',
        child: Text('Vai su “Agenda Medica” e tocca il pulsante + per aggiungere una visita.'),
      ),
      isActive: true,
    ),
    Step(
      title: TappableReader(
        label: 'Compila visita',
        child: Text('Compila visita'),
      ),
      content: TappableReader(
        label: 'Seleziona data, orario, note e tocca Salva',
        child: Text('Scegli data, orario, compila note e tocca “Salva”.'),
      ),
      isActive: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Segna il tutorial come già mostrato
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('tutorial_shown', true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      pageTitle: 'Guida passo-passo',
      onBackPressed: () {
        TalkbackService.announce('Tutorial chiuso');
        Navigator.pop(context);
      },
      child: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < _steps.length - 1) {
            setState(() => _currentStep++);
            final titleWidget = _steps[_currentStep].title.child;
            final label = titleWidget is Text ? titleWidget.data! : 'Passo ${_currentStep + 1}';
            TalkbackService.announce(label);
          } else {
            TalkbackService.announce('Fine tutorial');
            Navigator.pop(context);
          }
        },
        onStepCancel: _currentStep > 0
            ? () {
                setState(() => _currentStep--);
                final titleWidget = _steps[_currentStep].title.child;
                final label = titleWidget is Text ? titleWidget.data! : 'Passo ${_currentStep + 1}';
                TalkbackService.announce(label);
              }
            : null,
        controlsBuilder: (ctx, details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: TappableReader(
                    label: 'Passo precedente',
                    child: const Text('Indietro'),
                  ),
                ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: TappableReader(
                  label: _currentStep < _steps.length - 1
                      ? 'Passo successivo'
                      : 'Fine tutorial',
                  child: Text(_currentStep < _steps.length - 1 ? 'Avanti' : 'Fine'),
                ),
              ),
            ],
          );
        },
        steps: _steps,
      ),
    );
  }
}

extension on Widget {
   get child => null;
}