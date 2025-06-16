import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import 'aggiungi_caregiver.dart';
import '../widgets/confirm_popup.dart';
import '../widgets/custom_main_button.dart';  // importa il CustomMainButton

class CaregiverProfilePage extends StatelessWidget {
  const CaregiverProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 1,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Caregiver',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 30),
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: const AssetImage('assets/images/caregiver.png'),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Svetlana Nowak',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Telefono',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '3202356890',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  's.nowak@email.com',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 35),
            const Spacer(),
            
            CustomMainButton(
              text: 'Elimina',
              color: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return ConfirmDialog(
                      titleText: 'Vuoi davvero Eliminare?\nL’azione è irreversibile',
                      cancelButtonText: 'No, Esci',
                      confirmButtonText: 'Sì, Elimina',
                      onCancel: () {
                        Navigator.of(ctx).pop();
                      },
                      onConfirm: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const AggiungiCaregiverPage(),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
