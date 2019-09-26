class UserModel {
  final String nome, email, senha, cpf, curriculum;
  final bool isCompany;
  final double rating;

  UserModel({this.cpf, this.email, this.nome, this.senha, this.isCompany, this.curriculum, this.rating});


  Map<String, dynamic> toMap(UserModel user) {
    return {
      'name': user.nome,
      'email': user.email,
      'password': user.senha,
      'cpf': user.cpf,
      'isCompany': user.isCompany,
      'rating': -1,
      'curriculum': ''
    };
  }
}
