class Expositor{
  final int id;
  final String name;
  final String surname;
  final String? email;
  final String? telephone;
  final String? nation;
  final String? province;
  final String? cap;
  final String? socialName;

  Expositor({
    required this.id,
    required this.name,
    required this.surname,
    this.email,
    this.telephone,
    this.nation,
    this.province,
    this.cap,
    required this.socialName
  });

}

final arrayExpositor = [
  Expositor(id: 1, name: 'Luigi', surname: 'Tarantini', socialName: 'VIVATICKET S.P.A', email: 'baiardi10@gmail.com', telephone: '231328482', cap: "12345"),
  Expositor(id: 2, name: 'Stefano', surname: 'Baiardi', socialName: 'SIGEP S.P.A', email: 'baiardi10@gmail.com', telephone: '231328482', cap: "12345"),
  Expositor(id: 3, name: 'Massimo', surname: 'Procopio', socialName: 'VIVATICKET S.P.A', email: 'baiardi10@gmail.com', telephone: '231328482', cap: "12345"),
  Expositor(id: 4, name: 'Mario', surname: 'Rossi', socialName: 'TEST', email: 'baiardi10@gmail.com', telephone: '231328482', cap: "12345"),
  Expositor(id: 5, name: 'Andrea', surname: 'Neri', socialName: 'Prova S.P.A', email: 'baiardi10@gmail.com', telephone: '231328482', cap: "12345"),
  Expositor(id: 1, name: 'Luigi', surname: 'Tarantini', socialName: 'VIVATICKET S.P.A', email: 'baiardi10@gmail.com', telephone: '231328482', cap: "12345"),
  Expositor(id: 2, name: 'Stefano', surname: 'Baiardi', socialName: 'SIGEP S.P.A', email: 'baiardi10@gmail.com', telephone: '231328482', cap: "12345"),
  Expositor(id: 3, name: 'Massimo', surname: 'Procopio', socialName: 'VIVATICKET S.P.A', email: 'baiardi10@gmail.com', telephone: '231328482', cap: "12345"),
  Expositor(id: 4, name: 'Mario', surname: 'Rossi', socialName: 'TEST', email: 'baiardi10@gmail.com', telephone: '231328482', cap: "12345"),
  Expositor(id: 5, name: 'Andrea', surname: 'Neri', socialName: 'Prova S.P.A', email: 'baiardi10@gmail.com', telephone: '231328482', cap: "12345"),
];