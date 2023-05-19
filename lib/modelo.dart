import 'package:cloud_firestore/cloud_firestore.dart';

class Asignacion {
  String? uid;
  String docente;
  String materia;
  String horario;
  String edificio;
  String salon;
  List<Asistencia>? asistencia;

  Asignacion({
    this.uid,
    required this.docente,
    required this.materia,
    required this.horario,
    required this.edificio,
    required this.salon,
    this.asistencia,
  });

  Map<String, dynamic> toMap() {
    return {
      'docente': docente,
      'materia': materia,
      'horario': horario,
      'edificio': edificio,
      'salon': salon,
    };
  }

  String getAsistencias() {
    String cadenaasistencias = "";
    asistencia?.forEach((asi) {
      cadenaasistencias += "  *  FECHA: " +
          asi.getFecha() +
          " HORA:" +
          asi.getHora() +
          "   REVISOR: " +
          asi.revisor +
          "\n";
    });
    return cadenaasistencias;
  }
}

class Asistencia {
  Timestamp fechahora;
  String revisor;

  Asistencia({
    required this.fechahora,
    required this.revisor,
  });

  Map<String, dynamic> toMap() {
    return {
      'fechahora': fechahora,
      'revisor': revisor,
    };
  }

  String getFecha() {
    DateTime dateTime = fechahora.toDate();
    String fecha =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    return fecha;
  }

  String getHora() {
    DateTime dateTime = fechahora.toDate();
    String hora =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return hora;
  }
}
