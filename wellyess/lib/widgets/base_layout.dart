import 'package:flutter/material.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/settings.dart';
import 'bottom_navbar.dart';
import 'go_back_button.dart';
import 'package:wellyess/screens/user_profile.dart';
import 'package:wellyess/widgets/menu.dart'; 

class BaseLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final VoidCallback? onBackPressed;
  final UserType? userType;

  const BaseLayout({
    super.key,
    required this.child,
    this.currentIndex = 0,
    this.onBackPressed,
    this.userType,
  });

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  bool _menuOpen = false;

  void _toggleMenuPopup(BuildContext context) async {
    if (_menuOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() => _menuOpen = false);
    } else {
      setState(() => _menuOpen = true);
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => MenuPopup(
          userType: widget.userType ?? UserType.elder,
        ),
      );
      setState(() => _menuOpen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isCaregiver = widget.userType == UserType.caregiver;
    final profileImageAsset = isCaregiver
        ? 'assets/images/svetlana.jpg'
        : 'assets/images/elder_profile_pic.png';
    final profilePage = const ProfiloUtente();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05,
                screenHeight * 0.012,
                screenWidth * 0.05,
                screenHeight * 0.12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: Semantics(
                          label: 'Logo Wellyess',
                          child: Image.asset(
                            'assets/logo/wellyess.png',
                            height: screenHeight * 0.06,
                          ),
                        ),
                      ),
                      Semantics(
                        label: 'Foto profilo utente',
                        button: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => profilePage),
                            );
                          },
                          child: CircleAvatar(
                            radius: screenWidth * 0.075,
                            backgroundImage: AssetImage(profileImageAsset),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.018),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.075),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.075),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.onBackPressed != null) ...[
                            Semantics(
                              button: true,
                              child: BackCircleButton(onPressed: widget.onBackPressed),
                            ),
                            SizedBox(height: screenHeight * 0.025),
                          ],
                          Expanded(child: widget.child),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: screenHeight * 0.006,
              child: Semantics(
                container: true,
                label: 'Barra di navigazione principale',
                child: CustomBottomNavBar(
                  currentIndex: widget.currentIndex,
                  isMenuOpen: _menuOpen,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        _toggleMenuPopup(context);
                        break;
                      case 1:
                        Navigator.popUntil(context, (r) => r.isFirst);
                        break;
                      case 2:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SettingsPage()));
                        break;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}