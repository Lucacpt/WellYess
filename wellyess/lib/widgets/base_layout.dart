import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/settings.dart';
import 'package:wellyess/screens/user_profile.dart';
import 'package:wellyess/widgets/menu.dart';
import 'package:wellyess/widgets/go_back_button.dart';
import 'package:wellyess/widgets/bottom_navbar.dart';
import 'package:wellyess/services/flutter_tts.dart';    // ← import corretto
import 'package:wellyess/main.dart';                   // per routeObserver

class BaseLayout extends StatefulWidget {
  final String pageTitle;       // ← titolo da annunciare
  final Widget child;
  final int currentIndex;
  final VoidCallback? onBackPressed;
  final UserType? userType;

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
  bool _menuOpen = false;
  String? _lastAnnounced;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush()    => _announceTitle();
  @override
  void didPopNext() => _announceTitle();

  void _announceTitle() {
    if (widget.pageTitle != _lastAnnounced) {
      TalkbackService.announce(widget.pageTitle);
      _lastAnnounced = widget.pageTitle;
    }
  }

  void _toggleMenuPopup(BuildContext context) async {
    if (_menuOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() => _menuOpen = false);
    } else {
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
    final access       = context.watch<AccessibilitaModel>();
    final fontSize     = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

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
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Semantics(
                        label: 'Logo Wellyess',
                        button: true,
                        child: GestureDetector(
                          onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                          child: Image.asset('assets/logo/wellyess.png', height: sh*0.06),
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
                  // BODY
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
                          if (widget.onBackPressed != null)
                            Semantics(
                              label: 'Torna indietro',
                              button: true,
                              child: BackCircleButton(onPressed: widget.onBackPressed),
                            ),
                          Expanded(child: widget.child),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // BOTTOM NAV BAR
            Positioned(
              left: 0, right: 0, bottom: sh*0.006,
              child: Semantics(
                container: true,
                label: 'Barra di navigazione principale',
                child: CustomBottomNavBar(
                  currentIndex: widget.currentIndex,
                  isMenuOpen: _menuOpen,
                  onTap: (i) {
                    switch (i) {
                      case 0: _toggleMenuPopup(context); break;
                      case 1: Navigator.popUntil(context, (r)=>r.isFirst); break;
                      case 2: Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SettingsPage()));
                              break;
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