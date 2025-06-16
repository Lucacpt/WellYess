import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/screens/med_section.dart';      // FarmaciPage
import 'package:wellyess/screens/consigli_salute.dart'; // ConsigliSalutePage

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

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
