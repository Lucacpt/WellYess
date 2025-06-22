import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment_model.dart';
import '../widgets/base_layout.dart';
import '../widgets/custom_main_button.dart';
import '../widgets/appointment_list.dart';
import '../widgets/appointment_horizontal_day_scroller.dart';
import '../widgets/appointment_week_navigation.dart';
import 'new_visita.dart';

class MedDiaryPage extends StatefulWidget {
  const MedDiaryPage({super.key});

  @override
  State<MedDiaryPage> createState() => _MedDiaryPageState();
}

class _MedDiaryPageState extends State<MedDiaryPage> {
  // ... la logica di stato rimane invariata ...
  final List<Appointment> _allAppointments = [
    Appointment(
      tipoVisita: "Esame del Sangue",
      luogo: "Clinica Rossi",
      data: DateTime(2025, 6, 26),
      ora: DateTime(2025, 1, 1, 9, 0),
      medico: "Dott. Rossi",
    ),
    Appointment(
      tipoVisita: "Visita Cardiologica",
      luogo: "Clinica Santa Maria",
      data: DateTime(2025, 6, 23),
      ora: DateTime(2025, 1, 1, 17, 0),
      medico: "Dott. Massimo Carrisi",
    ),
    Appointment(
      tipoVisita: "Controllo Dentista",
      luogo: "Dentista Parisi",
      data: DateTime(2025, 6, 17),
      ora: DateTime(2025, 1, 1, 11, 30),
      medico: "Dott. Bianchi",
    ),
  ];

  late DateTime _selectedDate;
  late List<Appointment> _filteredAppointments;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _filterAppointments();
  }

  void _filterAppointments() {
    setState(() {
      _filteredAppointments = _allAppointments
          .where((app) => DateUtils.isSameDay(app.dateTime, _selectedDate))
          .toList();
    });
  }

  void _onWeekChanged(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      _filterAppointments();
    });
  }

  void _onDaySelected(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      _filterAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        // MODIFICA: Utilizzo di una Column per una struttura a 3 parti:
        // testata fissa, corpo scorrevole, piè di pagina fisso.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- SEZIONE SUPERIORE FISSA ---
            const SizedBox(height: 12),
            Center(
              child: Text('Agenda Medica',
                  style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ),
            const SizedBox(height: 4),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            WeekNavigator(
              selectedDate: _selectedDate,
              onWeekChanged: _onWeekChanged,
            ),
            HorizontalDayScroller(
              selectedDate: _selectedDate,
              allAppointments: _allAppointments,
              onDaySelected: _onDaySelected,
            ),
            const Divider(),
            const SizedBox(height: 8),
            Center(
              child: Text('Visite ${DateFormat('d MMMM', 'it_IT').format(_selectedDate)}',
                  style: TextStyle(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ),
            const SizedBox(height: 16),

            // --- SEZIONE CENTRALE SCORREVOLE ---
            Expanded(
              child: AppointmentList(appointments: _filteredAppointments),
            ),

            // --- SEZIONE INFERIORE FISSA ---
            const SizedBox(height: 12),
            CustomMainButton(
              text: '+ Aggiungi appuntamento',
              color: const Color(0xFF5DB47F),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewVisitaScreen()));
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}