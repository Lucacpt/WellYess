import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import 'aggiungi_caregiver.dart';

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
            // Titolo in alto
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

            // Immagine profilo PNG
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: const AssetImage(
                  'assets/images/caregiver.png',
                ),
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
            const SizedBox(height: 45),

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
            const SizedBox(height: 44),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text(
                          'Vuoi davvero Eliminare?\nL’azione è irreversibile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('No, Esci'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const AggiungiCaregiverPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Sì, Elimina'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Elimina',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}