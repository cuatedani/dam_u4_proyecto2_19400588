import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u4_proyecto2_19400588/modelo.dart';

class FDB {
  static Future<FirebaseFirestore> abrirFire() async {
    return FirebaseFirestore.instance;
  }

  static Future<void> insertAsignacion(Asignacion a) async {
    FirebaseFirestore base = await abrirFire();
    await base.collection('Asignacion').add(a.toMap());
  }

  static Future<void> updateAsignacion(Asignacion a) async {
    FirebaseFirestore base = await abrirFire();
    await base.collection('Asignacion').doc(a.uid).set(a.toMap());
  }

  static Future<List<Asignacion>> selectAsignacion() async {
    FirebaseFirestore base = await abrirFire();
    QuerySnapshot querySnapshot = await base.collection('Asignacion').get();
    List<Asignacion> listaAsignaciones = [];

    await Future.forEach(querySnapshot.docs, (documento) async {
      QuerySnapshot<Map<String, dynamic>> asistenciaSnapshot =
          await documento.reference.collection('asistencia').get();
      List<Asistencia> listaAsistencias = [];

      await Future.forEach(asistenciaSnapshot.docs, (asistenciaDoc) {
        Asistencia asistencia = Asistencia(
          fechahora: asistenciaDoc['fechahora'],
          revisor: asistenciaDoc['revisor'],
        );

        listaAsistencias.add(asistencia);
      });

      Asignacion datoAsignacion = Asignacion(
        uid: documento.id,
        docente: documento['docente'],
        materia: documento['materia'],
        horario: documento['horario'],
        edificio: documento['edificio'],
        salon: documento['salon'],
        asistencia: listaAsistencias,
      );

      listaAsignaciones.add(datoAsignacion);
    });

    return listaAsignaciones;
  }

  static Future<List<Asignacion>> selectAsignacionDocente(
      String docente) async {
    FirebaseFirestore base = await abrirFire();
    QuerySnapshot querySnapshot = await base.collection('Asignacion').get();
    List<Asignacion> listaAsignaciones = [];

    await Future.forEach(querySnapshot.docs, (documento) async {
      if (documento['docente'] == docente) {
        QuerySnapshot<Map<String, dynamic>> asistenciaSnapshot =
            await documento.reference.collection('asistencia').get();
        List<Asistencia> listaAsistencias = [];

        await Future.forEach(asistenciaSnapshot.docs, (asistenciaDoc) {
          Asistencia asistencia = Asistencia(
            fechahora: asistenciaDoc['fechahora'],
            revisor: asistenciaDoc['revisor'],
          );

          listaAsistencias.add(asistencia);
        });

        Asignacion datoAsignacion = Asignacion(
          uid: documento.id,
          docente: documento['docente'],
          materia: documento['materia'],
          horario: documento['horario'],
          edificio: documento['edificio'],
          salon: documento['salon'],
          asistencia: listaAsistencias,
        );

        listaAsignaciones.add(datoAsignacion);
      }
    });

    return listaAsignaciones;
  }

  static Future<List<String>> getListaDocente() async {
    FirebaseFirestore base = await abrirFire();
    QuerySnapshot querySnapshot = await base.collection('Asignacion').get();
    List<String> listadocentes = [];

    await Future.forEach(querySnapshot.docs, (documento) async {
      if (!listadocentes.contains(documento['docente'])) {
        listadocentes.add(documento['docente']);
      }
    });

    return listadocentes;
  }

  static Future<List<Asignacion>> selectAsignacionRevisor(
      String revisor) async {
    FirebaseFirestore base = await abrirFire();
    QuerySnapshot querySnapshot = await base.collection('Asignacion').get();
    List<Asignacion> listaAsignaciones = [];

    await Future.forEach(querySnapshot.docs, (documento) async {
      QuerySnapshot<Map<String, dynamic>> asistenciaSnapshot =
          await documento.reference.collection('asistencia').get();
      List<Asistencia> listaAsistencias = [];

      await Future.forEach(asistenciaSnapshot.docs, (asistenciaDoc) {
        Asistencia asistencia = Asistencia(
          fechahora: asistenciaDoc['fechahora'],
          revisor: asistenciaDoc['revisor'],
        );
        if (asistencia.revisor == revisor) {
          listaAsistencias.add(asistencia);
        }
      });

      Asignacion datoAsignacion = Asignacion(
        uid: documento.id,
        docente: documento['docente'],
        materia: documento['materia'],
        horario: documento['horario'],
        edificio: documento['edificio'],
        salon: documento['salon'],
        asistencia: listaAsistencias,
      );

      if (!listaAsistencias.isEmpty) {
        listaAsignaciones.add(datoAsignacion);
      }
    });

    return listaAsignaciones;
  }

  static Future<List<String>> getListaRevisor() async {
    FirebaseFirestore base = await abrirFire();
    QuerySnapshot querySnapshot = await base.collection('Asignacion').get();
    List<String> listarevisor = [];

    await Future.forEach(querySnapshot.docs, (documento) async {
      QuerySnapshot<Map<String, dynamic>> asistenciaSnapshot =
          await documento.reference.collection('asistencia').get();

      await Future.forEach(asistenciaSnapshot.docs, (asistenciaDoc) {
        if (!listarevisor.contains(asistenciaDoc['revisor'])) {
          listarevisor.add(asistenciaDoc['revisor']);
        }
      });
    });

    return listarevisor;
  }

  static Future<List<Asignacion>> selectAsignacionFecha(
      DateTime fecha1, DateTime fecha2) async {
    FirebaseFirestore base = await abrirFire();
    QuerySnapshot querySnapshot = await base.collection('Asignacion').get();
    List<Asignacion> listaAsignaciones = [];

    await Future.forEach(querySnapshot.docs, (documento) async {
      QuerySnapshot<Map<String, dynamic>> asistenciaSnapshot =
          await documento.reference.collection('asistencia').get();
      List<Asistencia> listaAsistencias = [];

      await Future.forEach(asistenciaSnapshot.docs, (asistenciaDoc) {
        Asistencia asistencia = Asistencia(
          fechahora: asistenciaDoc['fechahora'],
          revisor: asistenciaDoc['revisor'],
        );
        DateTime fechahora = asistencia.fechahora.toDate();
        if (fechahora.isAfter(fecha1) && fechahora.isBefore(fecha2)) {
          listaAsistencias.add(asistencia);
        }
      });

      Asignacion datoAsignacion = Asignacion(
        uid: documento.id,
        docente: documento['docente'],
        materia: documento['materia'],
        horario: documento['horario'],
        edificio: documento['edificio'],
        salon: documento['salon'],
        asistencia: listaAsistencias,
      );

      listaAsignaciones.add(datoAsignacion);
    });

    return listaAsignaciones;
  }

  static Future<List<Asignacion>> selectAsignacionFechaEdif(
      String edificio, DateTime fecha1, DateTime fecha2) async {
    FirebaseFirestore base = await abrirFire();
    QuerySnapshot querySnapshot = await base.collection('Asignacion').get();
    List<Asignacion> listaAsignaciones = [];

    await Future.forEach(querySnapshot.docs, (documento) async {
      QuerySnapshot<Map<String, dynamic>> asistenciaSnapshot =
          await documento.reference.collection('asistencia').get();
      List<Asistencia> listaAsistencias = [];

      await Future.forEach(asistenciaSnapshot.docs, (asistenciaDoc) {
        Asistencia asistencia = Asistencia(
          fechahora: asistenciaDoc['fechahora'],
          revisor: asistenciaDoc['revisor'],
        );
        DateTime fechahora = asistencia.fechahora.toDate();
        print(fechahora);
        print(fecha1);
        print(fecha2);
        if (fechahora.isAfter(fecha1) && fechahora.isBefore(fecha2)) {
          listaAsistencias.add(asistencia);
        }
      });

      Asignacion datoAsignacion = Asignacion(
        uid: documento.id,
        docente: documento['docente'],
        materia: documento['materia'],
        horario: documento['horario'],
        edificio: documento['edificio'],
        salon: documento['salon'],
        asistencia: listaAsistencias,
      );

      if (datoAsignacion.edificio == edificio) {
        listaAsignaciones.add(datoAsignacion);
      }
    });

    return listaAsignaciones;
  }

  static Future<void> deleteAsignacion(Asignacion a) async {
    FirebaseFirestore base = await abrirFire();
    await base.collection('Asignacion').doc(a.uid).delete();

    QuerySnapshot<Map<String, dynamic>> asistenciaSnapshot = await base
        .collection('Asignacion')
        .doc(a.uid)
        .collection('asistencia')
        .get();

    await Future.forEach(asistenciaSnapshot.docs, (asistenciaDoc) async {
      await base
          .collection('Asignacion')
          .doc(a.uid)
          .collection('asistencia')
          .doc(asistenciaDoc.id)
          .delete();
    });
  }

  static Future<int> verificarDatos(Asignacion a) async {
    int e = 0;
    FirebaseFirestore base = await abrirFire();
    QuerySnapshot querySnapshot = await base.collection('Asignacion').get();

    await Future.forEach(querySnapshot.docs, (documento) async {
      if (documento['docente'] == a.docente &&
          documento['horario'] == a.horario) {
        if (e == 0) {
          e = 1;
        } else {
          if (e == 2) {
            e = 3;
          }
        }
      }
      if (documento['docente'] == a.docente &&
          documento['horario'] == a.horario &&
          documento['edificio'] == a.edificio &&
          documento['salon'] == a.salon) {
        if (e == 0) {
          e = 2;
        } else {
          if (e == 1) {
            e = 3;
          }
        }
      }
    });
    return e;
  }

  static Future<int> verificarDatosUpdate(Asignacion a, String dant) async {
    int e = 0;
    FirebaseFirestore base = await abrirFire();
    QuerySnapshot querySnapshot = await base.collection('Asignacion').get();

    await Future.forEach(querySnapshot.docs, (documento) async {
      if (documento['docente'] == a.docente &&
          documento['horario'] == a.horario) {
        if (e == 0) {
          e = 1;
        } else {
          if (e == 2) {
            e = 3;
          }
        }
      }
      if (documento['docente'] == a.docente &&
          documento['docente'] != dant &&
          documento['horario'] == a.horario &&
          documento['edificio'] == a.edificio &&
          documento['salon'] == a.salon) {
        if (e == 0) {
          e = 2;
        } else {
          if (e == 1) {
            e = 3;
          }
        }
      }
    });
    return e;
  }

  static Future<void> insertAsistencia(Asignacion asig, Asistencia asis) async {
    FirebaseFirestore base = await abrirFire();
    DocumentReference docasignacion =
        await base.collection('Asignacion').doc(asig.uid);
    await docasignacion.collection('asistencia').add(asis.toMap());
  }
}
