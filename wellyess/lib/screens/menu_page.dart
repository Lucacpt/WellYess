import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/screens/med_section.dart';      // FarmaciPage
import 'package:wellyess/screens/consigli_salute.dart'; // ConsigliSalutePage
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';                         // <— import Intl
import 'package:wellyess/models/appointment_model.dart'; // <— import model
import '../widgets/appointment_list.dart';
import '../widgets/appointment_horizontal_day_scroller.dart';
import '../widgets/appointment_week_navigation.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 0,
      onBackPressed: () => Navigator.of(context).pop(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Menu", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 24),

          _buildMenuButton(context, "Farmaci"),
          _buildMenuButton(context, "Agenda Medica"),
          _buildMenuButton(context, "Sport & Alimentazione"),
          _buildMenuButton(context, "Parametri"),
          _buildMenuButton(context, "Help Me"),

          const SizedBox(height: 24),
          // SOS rimane invariato oppure punta a una pagina reale
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          if (label == 'Farmaci') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FarmaciPage()),
            );
          } else if (label == 'Sport & Alimentazione') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ConsigliSalutePage()),
            );
          } else if (label == 'Agenda Medica') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MedDiaryPage()),
            );
          } else {
            // TODO: sostituire con navigazione reale o disabilitare
          }
        },
        child: Container(
          height: 50,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: const Color(0xFF5DB47F),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shadows: const [
              BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4)),
            ],
          ),
          child: Text(label, style: const TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
    );
  }
}

class MedDiaryPage extends StatefulWidget {
  const MedDiaryPage({Key? key}) : super(key: key);
  @override
  State<MedDiaryPage> createState() => _MedDiaryPageState();
}

class _MedDiaryPageState extends State<MedDiaryPage> {
  DateTime _selectedDate = DateTime.now();

  void _onDaySelected(DateTime d) => setState(() => _selectedDate = d);
  void _onWeekChanged(int days) => setState(() => _selectedDate = _selectedDate.add(Duration(days: days)));

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<AppointmentModel>('appointments');
    final allAppointments = box.values.toList(); // <— definisci lista

    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          Text('Agenda Medica', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          WeekNavigator(selectedDate: _selectedDate, onWeekChanged: _onWeekChanged),
          HorizontalDayScroller(
            selectedDate: _selectedDate,
            allAppointments: allAppointments, // <— passa qui
            onDaySelected: _onDaySelected,
          ),
          Expanded(
            child: AppointmentList(
              appointments: allAppointments.where((a) =>
                a.data.year == _selectedDate.year &&
                a.data.month == _selectedDate.month &&
                a.data.day == _selectedDate.day
              ).toList(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Aggiungi appuntamento'),
            onPressed: () => Navigator.pushNamed(context, '/new_visita'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5DB47F),
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ],
      ),
    );
  }
}
