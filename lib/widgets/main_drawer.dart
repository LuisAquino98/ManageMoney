import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key? key,
    required this.username,
  }) : super(key: key);

  final String username;

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pop(); // Cerrar el cajón después de cerrar sesión
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? 'Correo no disponible';

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color.fromARGB(255, 00, 34, 71), // Color de fondo
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  const Text(
                    'Correo Logeado',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      color: Colors.white, // Color de fuente
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.logout, // Cambia el ícono a uno de logout
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Cerrar Sesión', // Cambia el texto a "Cerrar Sesión"
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            onTap: () => _signOut(context), // Llamar al método de cerrar sesión
          ),
        ],
      ),
    );
  }
}
