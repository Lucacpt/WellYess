import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/med_card.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';

class MonitoringHistoryPage extends StatefulWidget {
  const MonitoringHistoryPage({super.key});

  @override
  State<MonitoringHistoryPage> createState() => _MonitoringHistoryPageState();
}

class _MonitoringHistoryPageState extends State<MonitoringHistoryPage> {
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

  Color _getColor(num value, num min, num max) {
    if (value < min || value > max) {
      if (value < min * 0.9 || value > max * 1.1) {
        return Colors.red.shade400;
      }
      return Colors.orange.shade700;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ParameterEntry>('parameters');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BaseLayout(
      userType: _userType,
      onBackPressed: () => Navigator.pop(context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Storico Monitoraggi',
              style: TextStyle(
                fontSize: (screenWidth * 0.07 * fontSizeFactor).clamp(22.0, 32.0),
                fontWeight: FontWeight.bold,
                color: highContrast ? Colors.black : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(
              color: highContrast ? Colors.black : Colors.grey,
              thickness: 1.2,
            ),
            Expanded(
              child: ValueListenableBuilder<Box<ParameterEntry>>(
                valueListenable: box.listenable(),
                builder: (context, box, _) {
                  final entries = box.values.toList()
                    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
                  if (entries.isEmpty) {
                    return Center(
                      child: Text(
                        'Nessun dato salvato',
                        style: TextStyle(
                          fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(14.0, 20.0),
                          color: highContrast ? Colors.black : Colors.grey.shade600,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => Column(
                      children: [
                        SizedBox(height: screenHeight * 0.01),
                        Divider(
                          thickness: 1.2,
                          color: highContrast ? Colors.black : Colors.grey,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
                    itemBuilder: (context, index) {
                      final e = entries[index];
                      final time = TimeOfDay.fromDateTime(e.timestamp);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${e.timestamp.day}/${e.timestamp.month}/${e.timestamp.year} - ${time.format(context)}",
                            style: TextStyle(
                              fontSize: (screenWidth * 0.04 * fontSizeFactor).clamp(13.0, 18.0),
                              color: highContrast ? Colors.black : Colors.grey.shade600,
                            ),
                          ),
                          FarmacoCard(
                            statoColore: _getColor(e.sys, 90, 140),
                            orario: "Pressione",
                            nome: "${e.sys} / ${e.dia}",
                            dose: "mmHg",
                          ),
                          FarmacoCard(
                            statoColore: _getColor(e.bpm, 60, 100),
                            orario: "Battito",
                            nome: "${e.bpm}",
                            dose: "MBP",
                          ),
                          FarmacoCard(
                            statoColore: _getColor(e.hgt, 70, 110),
                            orario: "Glicemia",
                            nome: "${e.hgt}",
                            dose: "MG/DL",
                          ),
                          FarmacoCard(
                            statoColore: _getColor(e.spo2, 95, 100),
                            orario: "Saturazione",
                            nome: "${e.spo2}",
                            dose: "%",
                          ),
                        ],
                      );
                    },
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