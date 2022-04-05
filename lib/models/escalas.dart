import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escalatrabalho/models/pessoa.dart';
import 'package:escalatrabalho/models/restricao.dart';
import 'package:escalatrabalho/models/setor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

const String path_escalas_bd = 'escalas';
final f = DateFormat('yyyy-MM-dd');

class Escala {
  String id;
  String inicio;
  String fim;
  List<Pessoa> pessoas;
  List<Setor> setores;
  List<Restricao> restricoes;
  String uid;

  static Firestore firestore = Firestore.instance;
  static CollectionReference get path_escalas => firestore.collection(path_escalas_bd);

  static Query path_escalas_semanal([DateTime day]) {
    day = day ?? DateTime.now();
    final inicio = day.subtract(Duration(days: day.weekday % 7));
    final fim = inicio.add(Duration(days: 6));
    print('inicio: ${f.format(inicio)} - fim: ${f.format(fim)}');
    return firestore.collection(path_escalas_bd)
        .where('inicio', isEqualTo: f.format(inicio))
        .where('fim', isEqualTo: f.format(fim));
  }

  Escala({
    this.id,
    var inicio,
    var fim,
    this.pessoas,
    this.setores,
    this.restricoes,
    this.uid,
  }) {
    if (inicio is DateTime) {
      this.inicio = f.format(inicio);
    } else if (inicio is String) {
      this.inicio = inicio;
    } else {
      throw Exception('Problema');
    }
    if (fim is DateTime) {
      this.fim = f.format(fim);
    } else if (fim is String) {
      this.fim = fim;
    } else {
      throw Exception('Problema');
    }
  }

  factory Escala.fromDoc(DocumentSnapshot snapshot) {
    return Escala(
      id: snapshot.documentID,
      inicio: snapshot['inicio'],
      fim: snapshot['fim'],
      pessoas: Pessoa.fromListDoc(snapshot['pessoas']),
      setores: Setor.fromListDoc(snapshot['setores']),
      restricoes: Restricao.fromListDoc(snapshot['restricoes']),
      uid: snapshot['uid'],
    );
  }

  factory Escala.fromMap(Map<String, dynamic> map) {
    return Escala(
      id: map['id'],
      inicio: map['inicio'],
      fim: map['fim'],
      pessoas: map['pessoas'],
      setores: map['setores'],
      restricoes: map['restricoes'],
      uid: map['uid'],
    );
  }

  Map<String, dynamic> toJSON([bool isUpdate = false]) {
    return {
      if(!isUpdate && id != null) 'id': id,
      if(inicio != null) 'inicio': inicio,
      if(fim != null) 'fim': fim,
      if(pessoas != null) 'pessoas': Map.fromIterable(pessoas, key: (e) => e.id, value: (e) => (e as Pessoa).toJSONEmbedded()),
      if(setores != null) 'setores': Map.fromIterable(setores, key: (e) => e.id, value: (e) => (e as Setor).toJSONEmbedded()),
      if(restricoes != null && restricoes.length > 0) 'restricoes': Map.fromIterable(restricoes, key: (e) => (e as Restricao).quem.id, value: (e) => (e as Restricao).toJSONEmbedded()),
      if(uid != null) 'uid': uid,
    };
  }

  Future<String> save() async {
    int fim = DateTime.parse(this.fim).add(Duration(days: 1)).millisecondsSinceEpoch;

    for(DateTime curr = DateTime.parse(inicio); curr.millisecondsSinceEpoch < fim; curr = curr.add(Duration(days: 1))) {
      print(f.format(curr));

      for (int i = 0; i < setores.length; i++) {
        Setor setor = setores[i];
        var snapshot = await Firestore.instance.collection('setores-pessoas').document(setor.id).snapshots();
        if (await snapshot.isEmpty) {
          print('isEmpty');
        } else {
          print('isNotEmpty');
        }
        print(setor);
      }
    }

    throw Exception('teste');
//    if (id != null) {
//      await path_escalas.document(id).updateData(toJSON(true));
//      return id;
//    } else {
//      uid = (await FirebaseAuth.instance.currentUser()).uid;
//      DocumentReference doc = await path_escalas.add(toJSON(true));
//      id = doc.documentID;
//      return doc.documentID;
//    }

    /// TODO: Criar algoritmo de escala
    /// escala(inicio, fim, pessoas, setores, restricoes)
    ///
    ///   colocar pessoas na lista p
    ///   colocar setores na lista s
    ///   colocar restricoes na lista r
    ///
    ///   para cada dia entre inicio e fim
    ///     para cada pessoa de pessoas
    ///       verificar se há restrição para a pessoa

  }

  @override
  String toString() {
    return 'Setor{id: $id, inicio: $inicio, fim: $fim}';
  }
}