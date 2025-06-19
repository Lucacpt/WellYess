import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/confirm_popup.dart';

class AggiungiMonitoraggioPage extends StatefulWidget {
  const AggiungiMonitoraggioPage({super.key});

  @override
  State<AggiungiMonitoraggioPage> createState() => _AggiungiMonitoraggioPageState();
}

class _AggiungiMonitoraggioPageState extends State<AggiungiMonitoraggioPage> {
  final Map<String, TextEditingController> controllers = {
    'SYS': TextEditingController(text: '0'),
    'DIA': TextEditingController(text: '0'),
    'BPM': TextEditingController(text: '0'),
    'HGT': TextEditingController(text: '0'),
    'SpO2': TextEditingController(text: '0'),
  };

  void increment(String key) {
    final value = int.tryParse(controllers[key]!.text) ?? 0;
    controllers[key]!.text = (value + 1).toString();
  }

  void decrement(String key) {
    final value = int.tryParse(controllers[key]!.text) ?? 0;
    controllers[key]!.text = (value - 1).clamp(0, double.infinity).toInt().toString();
  }

  Future<bool> _showExitConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        titleText: 'Vuoi davvero annullare?\nTutti i dati inseriti andranno persi.',
        cancelButtonText: 'No, riprendi',
        confirmButtonText: 'Sì, esci',
        onCancel: () => Navigator.of(context).pop(false),
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
    return result == true;
  }

  Widget buildValueInput(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: controllers[key],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _IncrementDecrementButton(icon: Icons.remove, onTap: () => decrement(key)),
            const SizedBox(width: 6),
            _IncrementDecrementButton(icon: Icons.add, onTap: () => increment(key)),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitConfirmation,
      child: BaseLayout(
        onBackPressed: () async {
          if (await _showExitConfirmation()) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Aggiungi Monitoraggio',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 40, thickness: 1.5),
              buildValueInput('Minima (SYS)', 'SYS'),
              const SizedBox(height: 20),
              buildValueInput('Massima (DIA)', 'DIA'),
              const SizedBox(height: 20),
              buildValueInput('Frequenza Cardiaca (BPM)', 'BPM'),
              const SizedBox(height: 20),
              buildValueInput('Glicemia (HGT)', 'HGT'),
              const SizedBox(height: 20),
              buildValueInput('Saturazione (%SpO2)', 'SpO2'),
              const SizedBox(height: 40),
              CustomMainButton(
                text: 'Salva',
                color: const Color(0xFF5DB47F),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Monitoraggio salvato con successo')),
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (await _showExitConfirmation()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Annulla',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _IncrementDecrementButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IncrementDecrementButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF5DB47F), size: 22),
        ),
      ),
    );
  }
}