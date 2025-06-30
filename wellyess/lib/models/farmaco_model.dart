import 'package:hive/hive.dart';

part 'farmaco_model.g.dart';

@HiveType(typeId: 2)
class FarmacoModel extends HiveObject {
  @HiveField(0) final String nome;
  @HiveField(1) final String dose;
  @HiveField(2) final String formaTerapeutica;
  @HiveField(3) final String orario;
  @HiveField(4) final String frequenza;
  @HiveField(5)
  bool? assunto;    // null = pending, true = assunto, false = saltato

  FarmacoModel({
    required this.nome,
    required this.dose,
    required this.formaTerapeutica,
    required this.orario,
    required this.frequenza,
    this.assunto,    // default null
  });
}