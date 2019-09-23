class UserModel {
  final String nome, email, senha, cpf, curriculum;
  final bool isCompany;

  UserModel({this.cpf, this.email, this.nome, this.senha, this.isCompany, this.curriculum});


  Map<String, dynamic> toMap(UserModel user) {
    return {
      'name': user.nome,
      'email': user.email,
      'password': user.senha,
      'cpf': user.cpf,
      'isCompany': user.isCompany,
      'curriculum': ''
    };
  }
}
