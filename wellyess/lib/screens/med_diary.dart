import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'package:wellyess/screens/new_visita.dart'; // <-- importa NewVisitaScreen
import '../widgets/base_layout.dart';
import '../widgets/appointment_list.dart';
import '../widgets/appointment_horizontal_day_scroller.dart';
import '../widgets/appointment_week_navigation.dart';

class MedDiaryPage extends StatefulWidget {
  const MedDiaryPage({Key? key}) : super(key: key);
  @override
  State<MedDiaryPage> createState() => _MedDiaryPageState();
}

class _MedDiaryPageState extends State<MedDiaryPage> {
  DateTime _selectedDate = DateTime.now();

  void _onDaySelected(DateTime d) =>
      setState(() => _selectedDate = d);
  void _onWeekChanged(int days) =>
      setState(() => _selectedDate = _selectedDate.add(Duration(days: days)));

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<AppointmentModel>('appointments');
    final allAppointments = box.values.toList();

    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Agenda Medica',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          WeekNavigator(
            selectedDate: _selectedDate,
            onWeekChanged: _onWeekChanged,
          ),
          HorizontalDayScroller(
            selectedDate: _selectedDate,
            allAppointments: allAppointments,
            onDaySelected: _onDaySelected,
          ),
          const Divider(),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Visite ${DateFormat('d MMMM', 'it_IT').format(_selectedDate)}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AppointmentList(
              appointments: allAppointments.where((a) =>
                a.dateTime.year == _selectedDate.year &&
                a.dateTime.month == _selectedDate.month &&
                a.dateTime.day == _selectedDate.day
              ).toList(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('+ Aggiungi appuntamento'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5DB47F),
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NewVisitaScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}