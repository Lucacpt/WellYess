import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/new_visita.dart';
import '../widgets/base_layout.dart';
import '../widgets/appointment_list.dart';
import '../widgets/appointment_horizontal_day_scroller.dart';
import '../widgets/appointment_week_navigation.dart';
import '../widgets/custom_main_button.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:wellyess/services/flutter_tts.dart';

// Pagina principale dell'agenda medica
class MedDiaryPage extends StatefulWidget {
  const MedDiaryPage({Key? key}) : super(key: key);
  @override
  State<MedDiaryPage> createState() => _MedDiaryPageState();
}

class _MedDiaryPageState extends State<MedDiaryPage> {
  DateTime _selectedDate = DateTime.now(); // Data selezionata nel calendario
  UserType? _userType; // Tipo utente (caregiver, anziano, ecc.)
  bool _isLoading = true; // Stato di caricamento

  @override
  void initState() {
    super.initState();
    // Carica il tipo di utente all'avvio della pagina
    _loadUserType();
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

  // Aggiorna la data selezionata quando si sceglie un giorno diverso
  void _onDaySelected(DateTime d) => setState(() => _selectedDate = d);

  // Cambia settimana avanti o indietro
  void _onWeekChanged(int days) =>
      setState(() => _selectedDate = _selectedDate.add(Duration(days: days)));

  @override
  Widget build(BuildContext context) {
    // Mostra un caricamento finché non si conosce l'utente
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final box = Hive.box<AppointmentModel>('appointments');
    final allAppointments = box.values.toList();

    // Accessibilità: recupera i valori dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Layout principale della pagina
    return BaseLayout(
      pageTitle: 'Agenda Medica',      // Titolo della pagina
      userType: _userType,             // Passa il tipo di utente corretto
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Titolo grande in alto
          TappableReader(
            label: 'Titolo pagina Agenda Medica',
            child: Center(
              child: Text(
                'Agenda Medica',
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width * 0.08 * fontSizeFactor).clamp(22.0, 36.0),
                  fontWeight: FontWeight.bold,
                  color: highContrast ? Colors.black : Colors.black87,
                ),
              ),
            ),
          ),
          // Navigatore settimanale (frecce per cambiare settimana)
          TappableReader(
            label: 'Navigatore settimanale. Settimana del ${DateFormat('d MMMM', 'it_IT').format(_selectedDate)}',
            child: WeekNavigator(
              selectedDate: _selectedDate,
              onWeekChanged: _onWeekChanged,
            ),
          ),
          // Selettore giorno orizzontale
          TappableReader(
            label: 'Selettore giorno',
            child: HorizontalDayScroller(
              selectedDate: _selectedDate,
              allAppointments: allAppointments,
              onDaySelected: (d) {
                setState(() => _selectedDate = d);
                if (access.talkbackEnabled) {
                  final spoken = DateFormat('EEEE d MMMM', 'it_IT').format(d);
                  TalkbackService.announce(spoken);
                }
              },
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          // Titolo della sezione visite del giorno
          TappableReader(
            label: 'Visite del giorno ${DateFormat('EEEE d MMMM', 'it_IT').format(_selectedDate)}',
            child: Center(
              child: Text(
                'Visite ${DateFormat('d MMMM', 'it_IT').format(_selectedDate)}',
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width * 0.05 * fontSizeFactor).clamp(16.0, 27.0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Lista delle visite del giorno selezionato
          Expanded(
            child: AppointmentList(
              appointments: allAppointments
                  .where((a) =>
                      a.dateTime.year == _selectedDate.year &&
                      a.dateTime.month == _selectedDate.month &&
                      a.dateTime.day == _selectedDate.day)
                  .toList(),
            ),
          ),
          // Bottone per aggiungere un nuovo appuntamento
          TappableReader(
            label: 'Aggiungi appuntamento',
            child: CustomMainButton(
              text: '+ Aggiungi appuntamento',
              color: const Color(0xFF5DB47F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewVisitaScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}