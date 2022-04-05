import 'package:escalatrabalho/models/pessoa.dart';
import 'package:escalatrabalho/models/setor.dart';

class Restricao {
  Pessoa quem;
  String qual;
  List<Setor> onde;

  Restricao({
    this.quem,
    this.qual,
    this.onde,
  });


  factory Restricao.fromMap(Map<String, dynamic> map) {
    return Restricao(
      quem: Pessoa.fromMap(map['quem']),
      qual: map['qual'],
      onde: Setor.fromListDoc(map['onde']),
    );
  }

  Map<String, dynamic> toJSONEmbedded() {
    return {
      if(quem != null) 'quem': quem.toJSONEmbedded(),
      if(qual != null) 'qual': qual,
      if(onde != null) 'onde': Map.fromIterable(onde, key: (e) => e.id, value: (e) => (e as Setor).toJSONEmbedded(true)),
    };
  }

  static List<Restricao> fromListDoc(Map<String, dynamic> map) {
    return map == null ? null : map.entries.map((e) => Restricao.fromMap({'id': e.key, ...e.value})).toList();
  }
}