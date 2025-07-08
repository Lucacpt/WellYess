import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/settings.dart';
import 'package:wellyess/screens/user_profile.dart';
import 'package:wellyess/widgets/menu.dart';
import 'package:wellyess/widgets/go_back_button.dart';
import 'package:wellyess/widgets/bottom_navbar.dart';
import 'package:wellyess/services/flutter_tts.dart';    // ← già presente
import 'package:wellyess/main.dart';                   // per routeObserver
import 'package:wellyess/widgets/tappable_reader.dart'; // ← aggiunto per usare TappableReader
import 'package:wellyess/screens/homepage.dart';        // ← import HomePage

// Layout di base riutilizzabile per tutte le schermate principali dell'app
class BaseLayout extends StatefulWidget {
  final String pageTitle;       // Titolo della pagina da annunciare e mostrare
  final Widget child;           // Contenuto principale della pagina
  final int currentIndex;       // Indice della bottom navigation bar
  final VoidCallback? onBackPressed; // Callback per il pulsante "indietro"
  final UserType? userType;     // Tipo utente (caregiver o anziano)

  const BaseLayout({
    Key? key,
    required this.pageTitle,
    required this.child,
    this.currentIndex = 0,
    this.onBackPressed,
    this.userType,
  }) : super(key: key);

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> with RouteAware {
  bool _menuOpen = false;         // Stato del menu popup (aperto/chiuso)
  String? _lastAnnounced;         // Ultimo titolo annunciato per evitare ripetizioni

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Si iscrive al routeObserver per sapere quando la pagina è attiva
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // Si disiscrive dal routeObserver quando la pagina viene distrutta
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Annuncia il titolo della pagina quando viene aperta o torna in primo piano
  @override
  void didPush()    => _announcePageIfEnabled();
  @override
  void didPopNext() => _announcePageIfEnabled();

  // Annuncia il titolo della pagina tramite TTS se TalkBack è attivo
  Future<void> _announcePageIfEnabled() async {
    final enabled = context.read<AccessibilitaModel>().talkbackEnabled;
    if (!enabled) return;

    // Annuncia solo se il titolo è cambiato rispetto all'ultimo annunciato
    if (_lastAnnounced != widget.pageTitle) {
      _lastAnnounced = widget.pageTitle;
      await TalkbackService.announce(widget.pageTitle);
    }
  }

  // Gestisce l'apertura e la chiusura del menu popup
  void _toggleMenuPopup(BuildContext context) async {
    if (_menuOpen) {
      // Se il menu è già aperto, lo chiude
      Navigator.of(context, rootNavigator: true).pop();
      setState(() => _menuOpen = false);
    } else {
      // Altrimenti lo apre e attende la chiusura della dialog
      setState(() => _menuOpen = true);
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => MenuPopup(userType: widget.userType ?? UserType.elder),
      );
      setState(() => _menuOpen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recupera impostazioni di accessibilità dal provider
    final access       = context.watch<AccessibilitaModel>();
    final fontSize     = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final sw = MediaQuery.of(context).size.width;   // Larghezza schermo
    final sh = MediaQuery.of(context).size.height;  // Altezza schermo

    // Determina se l'utente è un caregiver per mostrare l'avatar corretto
    final isCaregiver = widget.userType == UserType.caregiver;
    final avatarAsset = isCaregiver
        ? 'assets/images/svetlana.jpg'
        : 'assets/images/elder_profile_pic.png';
    final profilePage = const ProfiloUtente();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: highContrast ? Colors.white : const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(sw*0.05, sh*0.012, sw*0.05, sh*0.12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER: logo e avatar profilo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TappableReader(
                        label: 'Logo Wellyess',
                        child: GestureDetector(
                          onTap: () {
                            // Vai alla Home se clicchi sul logo
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const HomePage()),
                              (route) => false,
                            );
                          },
                          child: Image.asset('assets/logo/wellyess.png', height: sh * 0.06),
                        ),
                      ),
                      Semantics(
                        label: 'Foto profilo utente',
                        button: true,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => profilePage),
                          ),
                          child: CircleAvatar(
                            radius: sw*0.075,
                            backgroundImage: AssetImage(avatarAsset),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sh*0.018),
                  // BODY: contenuto principale della pagina
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(sw*0.075),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(sw*0.075),
                        boxShadow: [ BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20, offset: Offset(0,10),
                        )],
                        border: highContrast ? Border.all(color: Colors.black, width: 2) : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pulsante "indietro" se richiesto
                          if (widget.onBackPressed != null)
                            Semantics(
                              label: 'Torna indietro',
                              button: true,
                              child: BackCircleButton(onPressed: widget.onBackPressed),
                            ),
                          // Contenuto della pagina
                          Expanded(child: widget.child),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // BOTTOM NAV BAR: barra di navigazione principale in basso
            Positioned(
              left: 0, right: 0, bottom: sh*0.006,
              child: Semantics(
                container: true,
                label: 'Barra di navigazione principale',
                child: CustomBottomNavBar(
                  currentIndex: widget.currentIndex,
                  isMenuOpen: _menuOpen,
                  onTap: (i) {
                    // Gestisce il tap sui tre pulsanti della navbar
                    switch (i) {
                      case 0: _toggleMenuPopup(context); break; // Menu
                      case 1: Navigator.popUntil(context, (r)=>r.isFirst); break; // Home
                      case 2: Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SettingsPage()));
                              break; // Impostazioni
                    }
                  },
                  highContrast: highContrast,
                  fontSize: fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}