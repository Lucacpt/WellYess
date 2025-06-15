import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';  // importa il layout base

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Profilo',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
            ),
          ),

          _divider(),
          const SizedBox(height: 20),

          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/elder_profile_pic.png'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Michele Verdi',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Data nascita', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('15 Mag 1948', style: TextStyle(fontSize: 18)),
            ],
          ),

          _divider(),
          _spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Sesso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Maschile', style: TextStyle(fontSize: 18)),
            ],
          ),

          _divider(),
          _spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Allergie', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Polline', style: TextStyle(fontSize: 18)),
            ],
          ),

          _divider(),
          _spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Intolleranze', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Lattosio', style: TextStyle(fontSize: 18)),
            ],
          ),

          _divider(),
          _spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Gruppo sanguigno', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('A', style: TextStyle(fontSize: 18)),
            ],
          ),

          _divider(),
        ],
      ),
    );
  }
}