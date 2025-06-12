import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 

void main() {
  runApp(MyHomeApp());
}

class MyHomeApp extends StatelessWidget {
  const MyHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Sfondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/phone_wallpaper.png'), // <-- Cambia con il tuo asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay trasparente
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          // Contenuti sovrapposti
          SafeArea(
            child: Center( // Centro per limitare larghezza
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 420), // Limita larghezza a 420 px tipica smartphone
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ora e data
                      Text(
                        '18:00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lun, 7 Maggio',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Meteo
                      Row(
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            '20°',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Spacer(),
                          Icon(Icons.location_on, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text(
                            'Rho',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Griglia icone
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 24,
                          runSpacing: 24,
                          children: [
                            _appSvgIcon('assets/Sofa.svg', "Sofa"),   //Icona di prova in svg
                            _appIcon(Icons.photo, "Galleria"),
                            _appIcon(Icons.favorite, "Salute"),
                            _appIcon(Icons.call, "Telefono"),
                            _appIcon(Icons.message, "Messaggi"),
                            _appIcon(Icons.public, "Browser"),
                            _appIcon(Icons.camera_alt, "Fotocamera"),
                          ],
                        ),
                      ),
                      SizedBox(height: 40), // spazio tra icone e barra inferiore
                      // Barra inferiore
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.grey),
                                  SizedBox(width: 8),
                                  Text('Cerca...', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.apps, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white,
          child: Icon(icon, size: 32, color: Colors.green),
        ),
        SizedBox(height: 6),
        Text(label,
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

Widget _appSvgIcon(String assetPath, String label) {
  return Column(
    children: [
      CircleAvatar(
        radius: 32,
        backgroundColor: Colors.white,
        child: SvgPicture.asset(
          assetPath,
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
        ),
      ),
      SizedBox(height: 6),
      Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

