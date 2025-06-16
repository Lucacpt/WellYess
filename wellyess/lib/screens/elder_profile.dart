import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';

class ProfiloAnziano extends StatelessWidget {
  const ProfiloAnziano({super.key});

  Widget _divider() {
    return const Divider(thickness: 1, color: Colors.grey);
  }

  Widget _spacer() {
    return const SizedBox(height: 15);
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 2,
      onBackPressed: () {
        Navigator.pop(context);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Profilo',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),

            _divider(),
            const SizedBox(height: 20),

            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/elder_profile_pic.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Michele Verdi',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const InfoRow(label: 'Data nascita', value: '15 Mag 1948'),
            _divider(),
            _spacer(),

            const InfoRow(label: 'Sesso', value: 'Maschile'),
            _divider(),
            _spacer(),

            const InfoRow(label: 'Allergie', value: 'Polline'),
            _divider(),
            _spacer(),

            const InfoRow(label: 'Intolleranze', value: 'Lattosio'),
            _divider(),
            _spacer(),

            const InfoRow(label: 'Gruppo sanguigno', value: 'A'),
            _divider(),
          ],
        ),
      ),
    );
  }
}
