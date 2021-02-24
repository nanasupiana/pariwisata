class lokasiDetails {
  final String id, nama, alamat, provinsi,kota,kecamatan,desa,informasi;
  lokasiDetails({this.id, this.nama, this.alamat, this.provinsi, this.kota,this.kecamatan,this.desa,this.informasi});

  factory lokasiDetails.fromJson(Map<String, dynamic> json) {
    return new lokasiDetails(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      provinsi: json['provinsi'],
      kota: json['kota'],
      kecamatan: json['kecamatan'],
      desa: json['desa'],
      informasi: json['informasi']
    );
  }
}
