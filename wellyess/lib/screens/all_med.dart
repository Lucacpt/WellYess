import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/add_new_med.dart';
import 'package:wellyess/screens/med_details.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';

// Helper per interpretare qualsiasi stringa di orario
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

class AllMedsPage extends StatefulWidget {
  const AllMedsPage({Key? key}) : super(key: key);

  @override
  State<AllMedsPage> createState() => _AllMedsPageState();
}

class _AllMedsPageState extends State<AllMedsPage> {
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final box = Hive.box<FarmacoModel>('farmaci');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return BaseLayout(
      pageTitle: 'Tutta la Terapia',   // ← titolo da annunciare
      userType: _userType,
      currentIndex: 1,
      onBackPressed: () => Navigator.pop(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Intestazione fissa
            TappableReader(
              label: 'Titolo pagina Tutta la Terapia',
              child: Text(
                'Tutta la Terapia',
                style: TextStyle(
                  fontSize: (screenWidth * 0.08 * fontSizeFactor).clamp(30.0, 38.0),
                  fontWeight: FontWeight.bold,
                  color: highContrast ? Colors.black : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),

            // Corpo dinamico (scorrevole o vuoto)
            Expanded(
              child: ValueListenableBuilder<Box<FarmacoModel>>(
                valueListenable: box.listenable(),
                builder: (context, box, _) {
                  final farmaciEntries = box.toMap().entries.toList();

                  if (farmaciEntries.isEmpty) {
                    return Center(
                      child: Text(
                        'Nessun farmaco aggiunto.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(13.0, 22.0),
                          color: highContrast ? Colors.black : Colors.grey,
                        ),
                      ),
                    );
                  }

                  farmaciEntries.sort((a, b) => a.value.nome
                      .toLowerCase()
                      .compareTo(b.value.nome.toLowerCase()));

                  // Tutto il contenuto scorrevole
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: farmaciEntries.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Testo informativo in cima alla lista
                        return Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight * 0.01,
                            bottom: screenHeight * 0.02,
                          ),
                          child: Row(
                            children: [
                              TappableReader(
                                label: 'Icona informativa lista farmaci',
                                child: Icon(Icons.info_outline,
                                    color: Colors.blue.shade700,
                                    size: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 28.0)),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: TappableReader(
                                  label: 'Testo informativo lista farmaci',
                                  child: Text(
                                    "Tocca un farmaco per visualizzare i dettagli.",
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
                        );
                      }
                      if (index == farmaciEntries.length + 1) {
                        // Spazio extra in fondo per non coprire l'ultimo elemento col pulsante
                        return SizedBox(height: screenHeight * 0.02);
                      }

                      final entry = farmaciEntries[index - 1];
                      final farmaco = entry.value;
                      final farmacoKey = entry.key;

                      final orario24h = _parseTime(farmaco.orario);
                      final orarioDaMostrare = orario24h != null
                          ? DateFormat('HH:mm').format(orario24h)
                          : farmaco.orario;

                      return Card(
                        color:Colors.white,
                        elevation: 4,
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: highContrast ? Colors.black : Colors.transparent,
                            width: highContrast ? 2 : 0,
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.medication_outlined,
                            color: const Color(0xFF5DB47F),
                            size: (screenWidth * 0.08 * fontSizeFactor).clamp(22.0, 36.0),
                          ),
                          title: Text(
                            farmaco.nome,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(14.0, 26.0),
                              color: highContrast ? Colors.black : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            '${farmaco.dose} - $orarioDaMostrare',
                            style: TextStyle(
                              fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(12.0, 22.0),
                              color: highContrast ? Colors.black : Colors.grey.shade700,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DettagliFarmacoPage(
                                  farmaco: farmaco,
                                  farmacoKey: farmacoKey,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Footer fisso
            SizedBox(height: screenHeight * 0.02),
            TappableReader(
              label: 'Bottone Aggiungi farmaco',
              child: CustomMainButton(
                text: '+ Aggiungi farmaco',
                color: const Color(0xFF5DB47F),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AggiungiFarmacoPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}