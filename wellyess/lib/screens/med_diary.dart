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

class MedDiaryPage extends StatefulWidget {
  const MedDiaryPage({Key? key}) : super(key: key);
  @override
  State<MedDiaryPage> createState() => _MedDiaryPageState();
}

class _MedDiaryPageState extends State<MedDiaryPage> {
  DateTime _selectedDate = DateTime.now();
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

  void _onDaySelected(DateTime d) => setState(() => _selectedDate = d);
  void _onWeekChanged(int days) =>
      setState(() => _selectedDate = _selectedDate.add(Duration(days: days)));

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final box = Hive.box<AppointmentModel>('appointments');
    final allAppointments = box.values.toList();

    return BaseLayout(
      userType: _userType,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
            .copyWith(bottom: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Agenda',
                style: TextStyle(
                  fontSize: screenWidth * 0.08 * fontSizeFactor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: screenHeight * 0.01),
            WeekNavigator(
              selectedDate: _selectedDate,
              onWeekChanged: _onWeekChanged,
            ),
            SizedBox(height: screenHeight * 0.01),
            HorizontalDayScroller(
              selectedDate: _selectedDate,
              allAppointments: allAppointments,
              onDaySelected: _onDaySelected,
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Center(
              child: Text(
                'Visite ${DateFormat('d MMMM', 'it_IT').format(_selectedDate)}',
                style: TextStyle(
                  fontSize: screenWidth * 0.05 * fontSizeFactor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
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
            SizedBox(height: screenHeight * 0.012),
            CustomMainButton(
              text: 'Aggiungi visita',
              color: const Color(0xFF5DB47F),
              icon: Icons.add,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewVisitaScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}