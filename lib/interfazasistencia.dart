import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u4_proyecto2_19400588/controlador.dart';
import 'package:dam_u4_proyecto2_19400588/modelo.dart';
import 'package:flutter/material.dart';

class InterfazAsitencia extends StatefulWidget {
  const InterfazAsitencia({Key? key}) : super(key: key);

  @override
  State<InterfazAsitencia> createState() => _InterfazAsitenciaState();
}

class _InterfazAsitenciaState extends State<InterfazAsitencia> {
  List<Asignacion> listaAsignaciones = [];
  final datorevisor = TextEditingController();
  DateTime datofechahora = DateTime.now();
  String filtrodocente = "";
  List<String> listadocentes = [];
  String filtrorevisor = "";
  List<String> listadorevisor = [];
  List<String> listaedificio = ["UVP", "UD", "LC", "CB", "X"];
  String edificioselect = "UVP";
  DateTime filtrofecha1 = DateTime.now();
  DateTime filtrofecha2 = DateTime.now();
  TimeOfDay filtrohora1 = TimeOfDay.now();
  TimeOfDay filtrohora2 = TimeOfDay.now();
  String formatofecha1 = "";
  String formatofecha2 = "";

  @override
  void initState() {
    super.initState();
    filtrarTodos();
    ponerdatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencias'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 15),
          const Text('FILTROS'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    filtrarTodos();
                  },
                  child: const Text('TODOS')),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (listadocentes.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              const Text('NO HAY DOCENTES QUE SELECCIONAR')));
                    } else {
                      filtrodocente = listadocentes[0];
                      filtrarDocente();
                    }
                  },
                  child: const Text('DOCENTE')),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: () {
                    filtrofecha1 = DateTime.now();
                    filtrofecha2 = DateTime.now();
                    filtrohora1 = TimeOfDay.now();
                    filtrohora2 = TimeOfDay.now();
                    formatofecha1 = filtrofecha1.year.toString() +
                        "/" +
                        filtrofecha1.month.toString() +
                        "/" +
                        filtrofecha1.day.toString() +
                        "   " +
                        filtrohora1.hour.toString() +
                        ":" +
                        filtrohora1.minute.toString();
                    formatofecha2 = filtrofecha2.year.toString() +
                        "/" +
                        filtrofecha2.month.toString() +
                        "/" +
                        filtrofecha2.day.toString() +
                        "   " +
                        filtrohora2.hour.toString() +
                        ":" +
                        filtrohora2.minute.toString();
                    filtrarFecha();
                  },
                  child: const Text('FECHA')),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: () {
                    filtrofecha1 = DateTime.now();
                    filtrofecha2 = DateTime.now();
                    filtrohora1 = TimeOfDay.now();
                    filtrohora2 = TimeOfDay.now();
                    formatofecha1 = filtrofecha1.year.toString() +
                        "/" +
                        filtrofecha1.month.toString() +
                        "/" +
                        filtrofecha1.day.toString() +
                        "   " +
                        filtrohora1.hour.toString() +
                        ":" +
                        filtrohora1.minute.toString();
                    formatofecha2 = filtrofecha2.year.toString() +
                        "/" +
                        filtrofecha2.month.toString() +
                        "/" +
                        filtrofecha2.day.toString() +
                        "   " +
                        filtrohora2.hour.toString() +
                        ":" +
                        filtrohora2.minute.toString();
                    filtrarFechaEdif();
                  },
                  child: const Text('FECHA EDIF')),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (listadorevisor.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              const Text('NO HAY REVISORES QUE SELECCIONAR')));
                    } else {
                      filtrorevisor = listadorevisor[0];
                      filtrarRevisor();
                    }
                  },
                  child: const Text('REVISOR')),
            ],
          ),
          SizedBox(height: 15),
          Flexible(
              child: ListView.builder(
                  itemCount: listaAsignaciones.length,
                  itemBuilder: (context, indice) {
                    return InkWell(
                      onTap: () {
                        datofechahora = DateTime.now();
                        addAsistencia(listaAsignaciones[indice]);
                      },
                      child: ListTile(
                          title: Text(
                              "DOCENTE: ${listaAsignaciones[indice].docente}    MATERIA: ${listaAsignaciones[indice].materia}   HORARIO: ${listaAsignaciones[indice].horario} \n EDIFICIO: ${listaAsignaciones[indice].edificio}   SALON: ${listaAsignaciones[indice].salon}"),
                          subtitle: Text(
                              "${listaAsignaciones[indice].getAsistencias()}")),
                    );
                  })),
        ],
      ),
    );
  }

  void ponerdatos() async {
    listadocentes = await FDB.getListaDocente();
    listadorevisor = await FDB.getListaRevisor();
  }

  void filtrarTodos() async {
    List<Asignacion> temporal = await FDB.selectAsignacion();
    setState(() {
      listaAsignaciones = temporal;
    });
  }

  void filtrarDocente() async {
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
                Text("INGRESE FILTRO"),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text('DOCENTE:'),
                        value: filtrodocente,
                        onChanged: (value) {
                          setState(() {
                            filtrodocente = value as String;
                          });
                          Navigator.pop(context);
                          filtrarDocente();
                        },
                        items: listadocentes.map((tipo) {
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
                      List<Asignacion> temporal =
                          await FDB.selectAsignacionDocente(filtrodocente);
                      setState(() {
                        listaAsignaciones = temporal;
                      });
                      Navigator.pop(context);
                    },
                    child: Text("FILTRAR")),
              ],
            ),
          );
        });
  }

  void filtrarFecha() async {
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
                Text("INGRESE FILTRO"),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'DESDE: ${formatofecha1}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selectfecha1(context).then((value) {
                              formatofecha1 = filtrofecha1.year.toString() +
                                  "/" +
                                  filtrofecha1.month.toString() +
                                  "/" +
                                  filtrofecha1.day.toString() +
                                  "   " +
                                  filtrohora1.hour.toString() +
                                  ":" +
                                  filtrohora1.minute.toString();
                              filtrarFecha();
                            });
                          },
                          child: Text('SELECCIONAR FECHA'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selecthora1(context).then((value) {
                              formatofecha1 = filtrofecha1.year.toString() +
                                  "/" +
                                  filtrofecha1.month.toString() +
                                  "/" +
                                  filtrofecha1.day.toString() +
                                  "   " +
                                  filtrohora1.hour.toString() +
                                  ":" +
                                  filtrohora1.minute.toString();
                              filtrarFecha();
                            });
                          },
                          child: Text('SELECCIONAR HORA'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'HASTA: ${formatofecha2}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selectfecha2(context).then((value) {
                              formatofecha2 = filtrofecha2.year.toString() +
                                  "/" +
                                  filtrofecha2.month.toString() +
                                  "/" +
                                  filtrofecha2.day.toString() +
                                  "   " +
                                  filtrohora2.hour.toString() +
                                  ":" +
                                  filtrohora2.minute.toString();
                              filtrarFecha();
                            });
                          },
                          child: Text('SELECCIONAR FECHA'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selecthora2(context).then((value) {
                              formatofecha2 = filtrofecha2.year.toString() +
                                  "/" +
                                  filtrofecha2.month.toString() +
                                  "/" +
                                  filtrofecha2.day.toString() +
                                  "   " +
                                  filtrohora2.hour.toString() +
                                  ":" +
                                  filtrohora2.minute.toString();
                              filtrarFecha();
                            });
                          },
                          child: Text('SELECCIONAR HORA'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FilledButton(
                    onPressed: () async {
                      DateTime fecha1 = DateTime(
                          filtrofecha1.year,
                          filtrofecha1.month,
                          filtrofecha1.day,
                          filtrohora1.hour,
                          filtrohora1.minute);
                      DateTime fecha2 = DateTime(
                          filtrofecha2.year,
                          filtrofecha2.month,
                          filtrofecha2.day,
                          filtrohora2.hour,
                          filtrohora2.minute);
                      List<Asignacion> temporal = await FDB
                          .selectAsignacionFecha(fecha1, fecha2);
                      setState(() {
                        listaAsignaciones = temporal;
                      });
                      Navigator.pop(context);
                    },
                    child: Text("FILTRAR")),
              ],
            ),
          );
        });
  }

  void filtrarFechaEdif() async {
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
                Text("INGRESE FILTRO"),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'DESDE: ${formatofecha1}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selectfecha1(context).then((value) {
                              formatofecha1 = filtrofecha1.year.toString() +
                                  "/" +
                                  filtrofecha1.month.toString() +
                                  "/" +
                                  filtrofecha1.day.toString() +
                                  "   " +
                                  filtrohora1.hour.toString() +
                                  ":" +
                                  filtrohora1.minute.toString();
                              filtrarFechaEdif();
                            });
                          },
                          child: Text('SELECCIONAR FECHA'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selecthora1(context).then((value) {
                              formatofecha1 = filtrofecha1.year.toString() +
                                  "/" +
                                  filtrofecha1.month.toString() +
                                  "/" +
                                  filtrofecha1.day.toString() +
                                  "   " +
                                  filtrohora1.hour.toString() +
                                  ":" +
                                  filtrohora1.minute.toString();
                              filtrarFechaEdif();
                            });
                          },
                          child: Text('SELECCIONAR HORA'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'HASTA: ${formatofecha2}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selectfecha2(context).then((value) {
                              formatofecha2 = filtrofecha2.year.toString() +
                                  "/" +
                                  filtrofecha2.month.toString() +
                                  "/" +
                                  filtrofecha2.day.toString() +
                                  "   " +
                                  filtrohora2.hour.toString() +
                                  ":" +
                                  filtrohora2.minute.toString();
                              filtrarFechaEdif();
                            });
                          },
                          child: Text('SELECCIONAR FECHA'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            selecthora2(context).then((value) {
                              formatofecha2 = filtrofecha2.year.toString() +
                                  "/" +
                                  filtrofecha2.month.toString() +
                                  "/" +
                                  filtrofecha2.day.toString() +
                                  "   " +
                                  filtrohora2.hour.toString() +
                                  ":" +
                                  filtrohora2.minute.toString();
                              filtrarFechaEdif();
                            });
                          },
                          child: Text('SELECCIONAR HORA'),
                        ),
                      ],
                    ),
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
                          filtrarFechaEdif();
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
                SizedBox(
                  height: 20,
                ),
                FilledButton(
                    onPressed: () async {
                      DateTime fecha1 = DateTime(
                          filtrofecha1.year,
                          filtrofecha1.month,
                          filtrofecha1.day,
                          filtrohora1.hour,
                          filtrohora1.minute);
                      DateTime fecha2 = DateTime(
                          filtrofecha2.year,
                          filtrofecha2.month,
                          filtrofecha2.day,
                          filtrohora2.hour,
                          filtrohora2.minute);
                      List<Asignacion> temporal = await FDB
                          .selectAsignacionFechaEdif(edificioselect, fecha1, fecha2);
                      setState(() {
                        listaAsignaciones = temporal;
                      });
                      Navigator.pop(context);
                    },
                    child: Text("FILTRAR")),
              ],
            ),
          );
        });
  }

  void filtrarRevisor() async {
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
                Text("INGRESE FILTRO"),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text('REVISOR:'),
                        value: filtrorevisor,
                        onChanged: (value) {
                          setState(() {
                            filtrorevisor = value as String;
                          });
                          Navigator.pop(context);
                          filtrarRevisor();
                        },
                        items: listadorevisor.map((tipo) {
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
                      List<Asignacion> temporal =
                          await FDB.selectAsignacionRevisor(filtrorevisor);
                      setState(() {
                        listaAsignaciones = temporal;
                      });
                      Navigator.pop(context);
                    },
                    child: Text("FILTRAR")),
              ],
            ),
          );
        });
  }

  void addAsistencia(Asignacion asig) {
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
                Text("DATOS DE ASISTENCIA"),
                SizedBox(height: 10),
                Text("FECHA: " +
                    datofechahora.year.toString() +
                    "/" +
                    datofechahora.month.toString() +
                    "/" +
                    datofechahora.day.toString() +
                    "    HORA: " +
                    datofechahora.hour.toString().padLeft(2, '0') +
                    ":" +
                    datofechahora.minute.toString().padLeft(2, '0')),
                SizedBox(height: 10),
                TextField(
                    controller: datorevisor,
                    decoration: InputDecoration(labelText: "REVISOR:")),
                SizedBox(height: 10),
                FilledButton(
                    onPressed: () async {
                      Asistencia asis = Asistencia(
                          fechahora: Timestamp.fromDate(datofechahora),
                          revisor: datorevisor.text);
                      FDB.insertAsistencia(asig, asis);
                      datorevisor.clear();
                      ponerdatos();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              const Text("ASISTENCIA TOMARA CORRECTAMENTE")));
                      filtrarTodos();
                    },
                    child: Text("TOMAR ASISTENCIA")),
              ],
            ),
          );
        });
  }

  Future<void> selectfecha1(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
    );

    if (pickedDate != null && pickedDate != filtrofecha1) {
      setState(() {
        filtrofecha1 = pickedDate;
      });
    }
  }

  Future<void> selectfecha2(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
    );

    if (pickedDate != null && pickedDate != filtrofecha2) {
      setState(() {
        filtrofecha2 = pickedDate;
      });
    }
  }

  Future<void> selecthora1(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != filtrohora1) {
      setState(() {
        filtrohora1 = pickedTime;
      });
    }
  }

  Future<void> selecthora2(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != filtrohora2) {
      setState(() {
        filtrohora2 = pickedTime;
      });
    }
  }
}
