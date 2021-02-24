import 'dart:convert';
import 'dart:typed_data';

class pariwisataData {
  final String id, nama;
  final Uint8List foto;
  pariwisataData({this.id, this.nama, this.foto});

  factory pariwisataData.fromJson(Map<String, dynamic> json) {
    return new pariwisataData(
        id: json['id'],
        nama: json['nama'],
        foto: base64.decode((json['foto']).split(',').last)
    );
  }
}
