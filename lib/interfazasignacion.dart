import 'package:dam_u4_proyecto2_19400588/controlador.dart';
import 'package:dam_u4_proyecto2_19400588/modelo.dart';
import 'package:flutter/material.dart';

class InterfazAsignacion extends StatefulWidget {
  const InterfazAsignacion({Key? key}) : super(key: key);

  @override
  State<InterfazAsignacion> createState() => _InterfazAsignacionState();
}

class _InterfazAsignacionState extends State<InterfazAsignacion> {
  List<Asignacion> listaAsignaciones = [];
  TimeOfDay horaselect = TimeOfDay.now().replacing(minute: 0);
  String datohora = "";
  List<String> listaedificio = ["UVP", "UD", "LC", "CB", "X"];
  String edificioselect = "UVP";
  List<String> listasalon = [
    "Salon A",
    "Salon B",
    "Salon C",
    "Salon D",
    "Salon E"
  ];
  String salonselect = "Salon A";
  List<String> listamateria = [
    "DAM",
    "ADMIN REDES",
    "BDNOSql",
    "INFRA WEB",
    "GPS",
    "TINV2",
    "PROLOG"
  ];
  String materiaselect = "DAM";
  final datomaestro = TextEditingController();

  @override
  void initState() {
    super.initState();
    filtrarTodos();
    formatoHora();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignaciones'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: listaAsignaciones.length,
              itemBuilder: (context, indice) {
                return Column(
                  children: [
                    ListTile(
                      leading:
                          Text("DOCENTE: ${listaAsignaciones[indice].docente}"),
                      title: Text(
                          "MATERIA: ${listaAsignaciones[indice].materia}   HORARIO: ${listaAsignaciones[indice].horario}"),
                      subtitle: Text(
                          "EDIFICIO: ${listaAsignaciones[indice].edificio}   SALON: ${listaAsignaciones[indice].salon}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                datomaestro.text =
                                    listaAsignaciones[indice].docente;
                                materiaselect =
                                    listaAsignaciones[indice].materia;
                                horaselect = TimeOfDay(
                                    hour: int.parse(listaAsignaciones[indice]
                                        .horario
                                        .split(':')[0]),
                                    minute: int.parse(listaAsignaciones[indice]
                                        .horario
                                        .split(':')[1]));
                                datohora = listaAsignaciones[indice].horario;
                                edificioselect =
                                    listaAsignaciones[indice].edificio;
                                salonselect = listaAsignaciones[indice].salon;
                                UpdateAsignacion(listaAsignaciones[indice]);
                              },
                              icon: Icon(Icons.edit)),
                          SizedBox(width: 15),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return AlertDialog(
                                        title: Text("ATENCION"),
                                        content: Text(
                                            "¿DESEA ELIMINAR LA ASIGNACION?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                FDB.deleteAsignacion(
                                                    listaAsignaciones[indice]);
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: const Text(
                                                            "ELIMINADO CORRECTAMENTE")));
                                                filtrarTodos();
                                              },
                                              child: const Text(
                                                  "ELIMINAR")), //modalbotton sheet
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("CANCELAR")),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.delete)),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          InsertarAsignacion();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void filtrarTodos() async {
    List<Asignacion> temporal = await FDB.selectAsignacion();
    if (mounted) {
      setState(() {
        listaAsignaciones = temporal;
      });
    }
  }

  void formatoHora() {
    setState(() {
      datohora = horaselect.hour.toString().padLeft(2, '0') + ":00";
    });
  }

  Future<void> SeleccionarHora() async {
    final TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: horaselect,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      helpText: 'SELECCIONE UNA HORA',
      initialEntryMode: TimePickerEntryMode.input,
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
    );

    if (horaSeleccionada != null) {
      final int selectedHour = horaSeleccionada.hour;
      if (selectedHour >= 7 && selectedHour <= 20) {
        setState(() {
          horaselect = horaSeleccionada;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('HORA NO VALIDA'),
              content: Text('SELECCIONE UNA HORA ENTRE LAS 7 AM Y LAS 8 PM.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void InsertarAsignacion() {
    showModalBottomSheet(
        elevation: 20,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("DATOS DE ASIGNACION"),
                SizedBox(height: 10),
                TextField(
                    controller: datomaestro,
                    decoration: InputDecoration(labelText: "MAESTRO:")),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text('MATERIA:'),
                        value: materiaselect,
                        onChanged: (value) {
                          setState(() {
                            materiaselect = value as String;
                          });
                          Navigator.pop(context);
                          InsertarAsignacion();
                        },
                        items: listamateria.map((tipo) {
                          return DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("HORARIO: ${datohora}"),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await SeleccionarHora();
                          formatoHora();
                          Navigator.pop(context);
                          InsertarAsignacion();
                        },
                        child: const Text('SELECIONAR HORARIO:'))
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text('EDIFICIO:'),
                        value: edificioselect,
                        onChanged: (value) {
                          setState(() {
                            edificioselect = value as String;
                          });
                          Navigator.pop(context);
                          InsertarAsignacion();
                        },
                        items: listaedificio.map((tipo) {
                          return DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text('SALON:'),
                        value: salonselect,
                        onChanged: (value) {
                          setState(() {
                            salonselect = value as String;
                          });
                          Navigator.pop(context);
                          InsertarAsignacion();
                        },
                        items: listasalon.map((tipo) {
                          return DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                FilledButton(
                    onPressed: () async {
                      int errores = 0;

                      if (datomaestro.text.isEmpty) {
                        errores++;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                                "NO SE A INGRESADO EL DATO DEL DOCENTE")));
                      }

                      if (datohora == "") {
                        errores++;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                                "NO SE HA SElECCIONADO UN HORARIO")));
                      }

                      if (errores == 0) {
                        Asignacion asignacion = Asignacion(
                            docente: datomaestro.text,
                            materia: materiaselect,
                            horario: datohora,
                            edificio: edificioselect,
                            salon: salonselect,
                            asistencia: []);

                        int verif = await FDB.verificarDatos(asignacion);

                        switch (verif) {
                          case 1:
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text(
                                    "ESE HORARIO YA ESTA ASIGNADO AL DOCENTE")));
                            break;

                          case 2:
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text(
                                    "OTRO DOCENTE YA ESTA ASIGNADO A ESE SALON EN ESE HORARIO")));
                            break;

                          case 3:
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text(
                                    "ESE HORARIO YA ESTA ASIGNADO AL DOCENTE Y OTRO DOCENTE YA ESTA ASIGNADO A ESE SALON EN ESE HORARIO")));
                            break;

                          default:
                            FDB.insertAsignacion(asignacion);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    const Text("INSERTADO CORRECTAMENTE")));
                            Navigator.pop(context);
                            datomaestro.clear();
                            materiaselect = "DAM";
                            horaselect = TimeOfDay.now().replacing(minute: 0);
                            datohora = "";
                            salonselect = "UVP";
                            salonselect = "Salon A";
                            filtrarTodos();
                            break;
                        }
                      }
                    },
                    child: Text("INSERTAR")),
              ],
            ),
          );
        });
  }

  void UpdateAsignacion(Asignacion a) {
    showModalBottomSheet(
        elevation: 20,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("DATOS DE ASIGNACION"),
                SizedBox(height: 10),
                TextField(
                    controller: datomaestro,
                    decoration: InputDecoration(labelText: "MAESTRO:")),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text('MATERIA:'),
                        value: materiaselect,
                        onChanged: (value) {
                          setState(() {
                            materiaselect = value as String;
                          });
                          Navigator.pop(context);
                          UpdateAsignacion(a);
                        },
                        items: listamateria.map((tipo) {
                          return DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("HORARIO: ${datohora}"),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await SeleccionarHora();
                          formatoHora();
                          Navigator.pop(context);
                          UpdateAsignacion(a);
                        },
                        child: const Text('SELECIONAR HORARIO:'))
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text('EDIFICIO:'),
                        value: edificioselect,
                        onChanged: (value) {
                          setState(() {
                            edificioselect = value as String;
                          });
                          Navigator.pop(context);
                          UpdateAsignacion(a);
                        },
                        items: listaedificio.map((tipo) {
                          return DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text('SALON:'),
                        value: salonselect,
                        onChanged: (value) {
                          setState(() {
                            salonselect = value as String;
                          });
                          Navigator.pop(context);
                          UpdateAsignacion(a);
                        },
                        items: listasalon.map((tipo) {
                          return DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                FilledButton(
                    onPressed: () async {
                      int errores = 0;

                      if (datomaestro.text.isEmpty) {
                        errores++;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                                "NO SE A INGRESADO EL DATO DEL DOCENTE")));
                      }

                      if (datohora == "") {
                        errores++;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                                "NO SE HA SElECCIONADO UN HORARIO")));
                      }

                      if (errores == 0) {
                        String dant = a.docente;
                        a.docente = datomaestro.text;
                        a.materia = materiaselect;
                        a.horario = datohora;
                        a.edificio = edificioselect;
                        a.salon = salonselect;

                        int verif = await FDB.verificarDatosUpdate(a, dant);

                        switch (verif) {
                          case 1:
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text(
                                    "ESE HORARIO YA ESTA ASIGNADO AL DOCENTE")));
                            break;

                          case 2:
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text(
                                    "OTRO DOCENTE YA ESTA ASIGNADO A ESE SALON EN ESE HORARIO")));
                            break;

                          case 3:
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text(
                                    "ESE HORARIO YA ESTA ASIGNADO AL DOCENTE Y OTRO DOCENTE YA ESTA ASIGNADO A ESE SALON EN ESE HORARIO")));
                            break;

                          default:
                            FDB.updateAsignacion(a);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    const Text("ACTUALIZADO CORRECTAMENTE")));
                            Navigator.pop(context);
                            datomaestro.clear();
                            materiaselect = "DAM";
                            horaselect = TimeOfDay.now().replacing(minute: 0);
                            datohora = "";
                            salonselect = "UVP";
                            salonselect = "Salon A";
                            filtrarTodos();
                            break;
                        }
                      }
                    },
                    child: Text("ACTUALIZAR")),
              ],
            ),
          );
        });
  }
}
