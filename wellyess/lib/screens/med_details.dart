import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/confirm_popup.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class DettagliFarmacoPage extends StatefulWidget {
  final FarmacoModel farmaco;
  final dynamic farmacoKey;

  const DettagliFarmacoPage({
    Key? key,
    required this.farmaco,
    required this.farmacoKey,
  }) : super(key: key);

  @override
  State<DettagliFarmacoPage> createState() => _DettagliFarmacoPageState();
}

class _DettagliFarmacoPageState extends State<DettagliFarmacoPage> {
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BaseLayout(
      pageTitle: 'Dettagli Farmaco',
      userType: _userType,
      onBackPressed: () => Navigator.pop(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
            .copyWith(bottom: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sezione superiore che si espande e scorre
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: Text(
                        'Dettagli farmaco',
                        style: TextStyle(
                          fontSize: (screenWidth * 0.08 * fontSizeFactor)
                              .clamp(30.0, 35.0),
                          fontWeight: FontWeight.bold,
                          color: highContrast ? Colors.black : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // DETTAGLI FARMACO
                    InfoRow(label: 'Nome', value: widget.farmaco.nome),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),                    
                    SizedBox(height: screenHeight * 0.02),
                    InfoRow(label: 'Dose', value: widget.farmaco.dose),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    InfoRow(label: 'Forma', value: widget.farmaco.formaTerapeutica),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    InfoRow(label: 'Orario', value: widget.farmaco.orario),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),  
                  ],
                ),
              ),
            ),

            // Pulsante fisso in basso
            SizedBox(height: screenHeight * 0.02),
            CustomMainButton(
              text: 'Elimina',
              color: Colors.red.shade700,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return ConfirmDialog(
                      titleText:
                          'Vuoi davvero Eliminare?\nL’azione è irreversibile',
                      cancelButtonText: 'No, Esci',
                      confirmButtonText: 'Sì, Elimina',
                      onCancel: () {
                        Navigator.of(dialogContext).pop();
                      },
                      onConfirm: () {
                        // Logica di eliminazione dal database Hive
                        final box = Hive.box<FarmacoModel>('farmaci');
                        box.delete(widget.farmacoKey);

                        Navigator.of(dialogContext).pop(); // Chiude il popup
                        Navigator.of(context).pop(); // Torna alla pagina precedente
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}