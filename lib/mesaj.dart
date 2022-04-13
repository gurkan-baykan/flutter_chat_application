import 'package:cloud_firestore/cloud_firestore.dart';

class Mesaj {
  String? kimden;
  String? kime;
  bool? bendenMi;
  String? mesaj;
  Timestamp? date;

  Mesaj({this.kimden, this.kime, this.bendenMi, this.mesaj, this.date});

  Map<String, dynamic> toMap() {
    return {
      "kimden": kimden,
      "kime": kime,
      "bendenMi": bendenMi,
      "mesaj": mesaj,
      "date": date ?? FieldValue.serverTimestamp()
    };
  }

  static Mesaj fromMap(Map<String, dynamic> map) {
    return Mesaj(
        kimden: map['kimden'],
        kime: map['kime'] != null ? map['email'] : "",
        bendenMi: map['bendenMi'],
        mesaj: map['mesaj'],
        date: map["date"]);
  }
}
