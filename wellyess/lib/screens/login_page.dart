import 'package:flutter/material.dart';
import 'package:wellyess/services/auth_service.dart';
import 'package:wellyess/models/user_model.dart';        // <-- importa UserType da qui
import 'package:wellyess/screens/homepage.dart';
import 'package:wellyess/screens/profilo_caregiver.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  UserType _selected = UserType.elder;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 10),
          TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
          const SizedBox(height: 20),
          Row(
            children: UserType.values.map((t) {
              final label = t == UserType.elder ? 'Anziano' : 'Caregiver';
              return Expanded(
                child: RadioListTile<UserType>(
                  title: Text(label), value: t, groupValue: _selected,
                  onChanged: (v) => setState(() => _selected = v!),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    setState(() => _loading = true);
                    final ok = await AuthService.login(_emailCtrl.text, _passCtrl.text, _selected);
                    setState(() => _loading = false);
                    if (ok) {
                      if (_selected == UserType.elder) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const CaregiverProfilePage()),
                        );
                      }
                    }
                  },
                  child: const Text('Accedi'),
                ),
        ]),
      ),
    );
  }
}