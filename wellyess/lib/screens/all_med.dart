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

    return BaseLayout(
      userType: _userType,
      currentIndex: 1,
      onBackPressed: () => Navigator.pop(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Intestazione
            Text(
              'Tutta la Terapia',
              style: TextStyle(
                  fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(thickness: 1.5, height: screenHeight * 0.04),

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
                            fontSize: screenWidth * 0.045, color: Colors.grey),
                      ),
                    );
                  }

                  farmaciEntries.sort((a, b) => a.value.nome
                      .toLowerCase()
                      .compareTo(b.value.nome.toLowerCase()));

                  // Se ci sono farmaci, mostra info + lista scorrevole
                  return Column(
                    children: [
                      // Testo informativo (ora è fisso sopra la lista)
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.blue.shade700,
                              size: screenWidth * 0.06),
                          SizedBox(width: screenWidth * 0.02),
                          Expanded(
                            child: Text(
                              "Tocca un farmaco per visualizzare i dettagli.",
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Lista dei farmaci (unica parte scorrevole)
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.01),
                          itemCount: farmaciEntries.length,
                          itemBuilder: (context, index) {
                            final entry = farmaciEntries[index];
                            final farmaco = entry.value;
                            final farmacoKey = entry.key;

                            final orario24h = _parseTime(farmaco.orario);
                            final orarioDaMostrare = orario24h != null
                                ? DateFormat('HH:mm').format(orario24h)
                                : farmaco.orario;

                            return Card(
                              color: Colors.white,
                              elevation: 4,
                              margin: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01),
                              child: ListTile(
                                leading: Icon(
                                  Icons.medication_outlined,
                                  color: const Color(0xFF5DB47F),
                                  size: screenWidth * 0.08,
                                ),
                                title: Text(
                                  farmaco.nome,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.05),
                                ),
                                subtitle: Text(
                                  '${farmaco.dose} - $orarioDaMostrare',
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.045),
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
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Footer fisso
            SizedBox(height: screenHeight * 0.02),
            CustomMainButton(
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
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}