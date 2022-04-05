import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String path_pessoas_bd = 'pessoas';

class Pessoa {
  String id;
  String nome;
  String fotoUrl;
  String uid;

  static Firestore firestore = Firestore.instance;
  static CollectionReference get path_pessoas => firestore.collection(path_pessoas_bd);

  Pessoa({
    this.id,
    this.nome,
    this.fotoUrl,
    this.uid,
  });

  factory Pessoa.fromDoc(DocumentSnapshot snapshot) {
    return Pessoa(
      id: snapshot.documentID,
      nome: snapshot['nome'],
      fotoUrl: snapshot['fotoUrl'],
      uid: snapshot['uid'],
    );
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return Pessoa(
      id: map['id'],
      nome: map['nome'],
      fotoUrl: map['fotoUrl'],
      uid: map['uid'],
    );
  }

  static List<Pessoa> fromListDoc(Map<String, dynamic> map) {
    return map == null ? null : map.entries.map((e) => Pessoa.fromMap({'id': e.key, ...e.value})).toList();
  }

  Map<String, dynamic> toJSON([bool isUpdate = false]) {
    return {
      if(!isUpdate && id != null) 'id': id,
      if(nome != null) 'nome': nome,
      if(fotoUrl != null) 'fotoUrl': fotoUrl,
      if(uid != null) 'uid': uid,
    };
  }

  Map<String, dynamic> toJSONEmbedded() {
    return {
      if(nome != null) 'nome': nome,
      if(fotoUrl != null) 'fotoUrl': fotoUrl,
    };
  }

  Future<String> save() async {
    if (id != null) {
      await path_pessoas.document(id).updateData(toJSON(true));
      return id;
    } else {
      uid = (await FirebaseAuth.instance.currentUser()).uid;
      DocumentReference doc = await path_pessoas.add(toJSON(true));
      id = doc.documentID;
      return doc.documentID;
    }
  }

  @override
  String toString() {
    return 'Pessoa{id: $id, nome: $nome}';
  }
}