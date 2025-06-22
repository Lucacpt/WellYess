class Appointment {
  final String tipoVisita;
  final String luogo;
  final DateTime data;
  final DateTime ora;
  final String medico;

  Appointment({
    required this.tipoVisita,
    required this.luogo,
    required this.data,
    required this.ora,
    required this.medico,
  });

  // MODIFICA: Aggiunto un getter per combinare data e ora.
  // Questo crea un DateTime completo che può essere usato dal resto dell'app.
  DateTime get dateTime {
    return DateTime(
      data.year,
      data.month,
      data.day,
      ora.hour,
      ora.minute,
    );
  }
}