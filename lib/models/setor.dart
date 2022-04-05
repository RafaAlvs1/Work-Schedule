import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String path_setores_bd = 'setores';

class Setor {
  String id;
  String nome;
  int quantidade;
  bool ativo;
  String fotoUrl;
  String uid;

  bool get estaAtivado {
    return ativo ?? true;
  }

  static Firestore firestore = Firestore.instance;
  static CollectionReference get path_setores => firestore.collection(path_setores_bd);
  static Query get setores_lista => firestore
      .collection(path_setores_bd)
      .orderBy('ativo', descending: true)
      .orderBy('quantidade', descending: true)
      .orderBy('nome');
  static Query get setores_lista_ativos => firestore
      .collection(path_setores_bd)
      .where('ativo', isEqualTo: true)
      .orderBy('quantidade', descending: true)
      .orderBy('nome');

  Setor({
    this.id,
    this.nome,
    this.quantidade,
    this.ativo,
    this.fotoUrl,
    this.uid,
  });

  factory Setor.fromDoc(DocumentSnapshot snapshot) {
    return Setor(
      id: snapshot.documentID,
      nome: snapshot['nome'],
      quantidade: snapshot['quantidade'],
      ativo: snapshot['ativo'],
      fotoUrl: snapshot['fotoUrl'],
      uid: snapshot['uid'],
    );
  }

  factory Setor.fromMap(Map<String, dynamic> map) {
    return Setor(
      id: map['id'],
      nome: map['nome'],
      quantidade: map['quantidade'],
      ativo: map['ativo'],
      fotoUrl: map['fotoUrl'],
      uid: map['uid'],
    );
  }

  static List<Setor> fromListDoc(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return map == null ? null : map.entries.map((e) => Setor.fromMap({'id': e.key, ...e.value})).toList();
  }

  Map<String, dynamic> toJSON([bool isUpdate = false]) {
    return {
      if(!isUpdate && id != null) 'id': id,
      if(nome != null) 'nome': nome,
      if(quantidade != null) 'quantidade': quantidade,
      'ativo': estaAtivado,
      if(fotoUrl != null) 'fotoUrl': fotoUrl,
      if(uid != null) 'uid': uid,
    };
  }

  Map<String, dynamic> toJSONEmbedded([bool isUpdate = false]) {
    return {
      if(nome != null) 'nome': nome,
      if(fotoUrl != null) 'fotoUrl': fotoUrl,
      if(!isUpdate && quantidade != null) 'quantidade': quantidade,
    };
  }

  Future<String> save() async {
    if (id != null) {
      await path_setores.document(id).updateData(toJSON(true));
      return id;
    } else {
      uid = (await FirebaseAuth.instance.currentUser()).uid;
      DocumentReference doc = await path_setores.add(toJSON(true));
      id = doc.documentID;
      return doc.documentID;
    }
  }

  @override
  String toString() {
    return 'Setor{id: $id, nome: $nome, quantidade: $quantidade}';
  }

}