import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';

class AssistitoPage extends StatelessWidget {
  const AssistitoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayout(
      child: Center(
        child: Text(
          'Pagina Dettagli Assistito',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}