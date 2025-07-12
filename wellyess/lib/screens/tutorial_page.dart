import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/services/flutter_tts.dart';

class TutorialStep {
  final String title;
  final String description;
  final String imagePath;
  TutorialStep({required this.title, required this.description, required this.imagePath});
}

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: '1. Aggiungi Farmaco',
      description: 'Nella pagina “Tutta la Terapia”, tocca il pulsante "+ Aggiungi Farmaco" per inserire un nuovo farmaco.',
      imagePath: 'assets/images/aggiungi_farmaco.jpg',
    ),
    TutorialStep(
      title: '2. Compila il farmaco',
      description: 'Inserisci tutti i dati richiesti e tocca “Salva”.',
      imagePath: 'assets/images/compila_farmaco.jpg',
    ),
    TutorialStep(
      title: '3. Aggiungi Visita',
      description: 'Vai su “Agenda Medica” e tocca il pulsante "+ Aggiungi Appuntamento" per aggiungere una visita.',
      imagePath: 'assets/images/aggiungi_visita.jpg',
    ),
    TutorialStep(
      title: '4. Compila visita',
      description: 'Inserisci tutti i dati richiesti e tocca “Salva”.',
      imagePath: 'assets/images/compila_visita.jpg',
    ),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
      final access = Provider.of<AccessibilitaModel>(context, listen: false);
      if (access.talkbackEnabled) {
        TalkbackService.announce(_steps[_currentStep].title);
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
      final access = Provider.of<AccessibilitaModel>(context, listen: false);
      if (access.talkbackEnabled) {
        TalkbackService.announce(_steps[_currentStep].title);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final access = Provider.of<AccessibilitaModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeFactor = access.fontSizeFactor;
    final step = _steps[_currentStep];

    return BaseLayout(
      pageTitle: 'Tutorial',
      onBackPressed: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.015,
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              bottom: screenHeight * 0.002,
            ),
            child: Text(
              'Guida a Wellyess',
              style: TextStyle(
                fontSize: (screenWidth * 0.07 * fontSizeFactor).clamp(20.0, 28.0),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.005,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Titolo step
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 26.0),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  // Immagine step 
                  Expanded(
                    flex: 12,
                    child: Center(
                      child: Image.asset(
                        step.imagePath,
                        fit: BoxFit.contain,
                        semanticLabel: step.title,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  // Descrizione step
                  Text(
                    step.description,
                    style: TextStyle(
                      fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(14.0, 20.0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Bottoni navigazione
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _prevStep,
                            child: const Text('Indietro'),
                          ),
                        )
                      else
                        const Spacer(),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          child: Text(_currentStep < _steps.length - 1 ? 'Avanti' : 'Fine'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}