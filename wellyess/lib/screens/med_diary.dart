import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import '../widgets/custom_button.dart';
import 'dettagli_visita.dart';
import '../widgets/custom_main_button.dart';
import 'new_visita.dart';

class MedDiaryPage extends StatefulWidget {
  const MedDiaryPage({super.key});

  @override
  State<MedDiaryPage> createState() => _MedDiaryPageState();
}

class _MedDiaryPageState extends State<MedDiaryPage> {
  final List<Map<String, String>> _appointments = [
    {
      "title": "Esame del Sangue",
      "location": "Studio Medico Dott. Rossi",
      "time": "09:00",
      "date": "7 Maggio 2025",
      "doctor": "Dott. Rossi",
      "mapAsset": "assets/images/map_sample.png",
    },
    {
      "title": "Visita Cardiologica",
      "location": "Clinica Santa Maria",
      "time": "17:00",
      "date": "7 Maggio 2025",
      "doctor": "Dott. Massimo Carrisi",
      "mapAsset": "assets/images/map_sample.png",
    },
  ];

  int _selectedDay = 7;
  final Color _primaryColor = Colors.green.shade500;

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Agenda Medica',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 15),

          // Selettore settimana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '7 - 13 Maggio 2025',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 32,
                child: CustomButton(
                  text: '14 - 20 Maggio',
                  icon: Icons.arrow_forward_ios, // ← icona di Flutter
                  color: const Color(0xFF5DB47F),
                  fontSize: 15,
                  onPressed: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Selettore giorno
          _buildDaySelector(),
          const SizedBox(height: 25),

          const Center(
            child: Text(
              'Visite Mediche',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),

          Expanded(
            child: ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                return _buildAppointmentCard(context, _appointments[index]);
              },
            ),
          ),
          const SizedBox(height: 15),

          const Divider(),

          const SizedBox(height: 15),

          CustomMainButton(
            text: '+ Aggiungi appuntamento',
            color: const Color(0xFF5DB47F),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewVisitaScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    const List<String> daysOfWeek = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
    const List<int> dates = [7, 8, 9, 10, 11, 12, 13];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysOfWeek
              .map((day) => Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dates.asMap().entries.map((entry) {
            int index = entry.key;
            int date = entry.value;
            bool isSelected = date == _selectedDay;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = date;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? _primaryColor : Colors.transparent,
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      date.toString(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (index < dates.length - 1)
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                  ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Map<String, String> appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.18),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment['title']!,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    appointment['location']!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    appointment['time']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 26,
                  width: 95,
                  child: CustomButton(
                    text: 'Dettagli',
                    color: Color(0xFF5DB47F),  // puoi cambiare il colore come preferisci

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DettagliVisitaScreen(
                            appointment: appointment,
                          ),
                        ),
                      );
                    },
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}