import 'package:dam_u4_proyecto2_19400588/interfazasignacion.dart';
import 'package:dam_u4_proyecto2_19400588/interfazasistencia.dart';
import 'package:flutter/material.dart';

class InterfazPrincipal extends StatefulWidget {
  const InterfazPrincipal({Key? key}) : super(key: key);

  @override
  State<InterfazPrincipal> createState() => _InterfazPrincipalState();
}

class _InterfazPrincipalState extends State<InterfazPrincipal> {
  int _indice = 0;

  final List<Widget> _vistas = [
    InterfazAsignacion(),
    InterfazAsitencia(),
  ];

  void cambiarvista(int indice) {
    setState(() {
      _indice = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _vistas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Asignaciones",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: "Asistencias",
          ),
        ],
        currentIndex: _indice,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        backgroundColor: Colors.deepOrangeAccent,
        onTap: cambiarvista,
        iconSize: 30,
      ),
    );
  }
}
