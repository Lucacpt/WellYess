import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/models/user_model.dart';

class DetailedChartScreen extends StatefulWidget {
  final String title;

  const DetailedChartScreen({
    super.key,
    required this.title,
  });

  @override
  State<DetailedChartScreen> createState() => _DetailedChartScreenState();
}

class _DetailedChartScreenState extends State<DetailedChartScreen> {
  UserType? _userType;
  bool _isLoading = true;

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

  String _generateOverallAnalysis() {
    // Analisi semplificata generica — puoi differenziare anche qui se vuoi
    return "I valori medi sono nella norma. Continua così!";
  }

  List<String> _generateAdviceList() {
    switch (widget.title.toLowerCase()) {
      case 'glicemia':
        return [
          "Limita l'assunzione di zuccheri semplici.",
          "Segui una dieta bilanciata con basso indice glicemico.",
          "Fai attività fisica regolarmente.",
          "Controlla la glicemia ogni giorno.",
          "Consulta il diabetologo per un piano personalizzato.",
        ];
      case 'pressione':
        return [
          "Riduci l'assunzione di sale nei pasti.",
          "Evita fumo, alcol e caffeina in eccesso.",
          "Mantieni un peso corporeo nella norma.",
          "Pratica attività fisica moderata e costante.",
          "Controlla regolarmente la pressione arteriosa.",
        ];
      case 'saturazione':
        return [
          "Evita ambienti con scarsa aerazione o inquinati.",
          "Pratica esercizi di respirazione profonda.",
          "Se fumi, considera seriamente di smettere.",
          "Controlla regolarmente la saturazione se hai patologie respiratorie.",
          "Consulta il medico se noti sintomi come affanno o vertigini.",
        ];
      default:
        return [
          "Segui uno stile di vita sano e attivo.",
          "Fai controlli medici periodici.",
          "Mangia in modo equilibrato.",
          "Evita situazioni stressanti.",
          "Riposati adeguatamente.",
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return BaseLayout(
      userType: _userType,
      currentIndex: -1,
      onBackPressed: () => Navigator.pop(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dettagli - ${widget.title}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 40, thickness: 1.5),
            const SizedBox(height: 20),

            // ANALISI APPROSSIMATIVA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      'Analisi Approssimativa',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _generateOverallAnalysis(),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // CONSIGLI PERSONALIZZATI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Consigli per migliorare',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._generateAdviceList().map((consiglio) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline, color: Colors.green),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                consiglio,
                                style: const TextStyle(fontSize: 16, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}