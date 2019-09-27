class UserCompanyModel {
  final String nome, email, senha, cnpj;
  final bool isCompany, profileCompleted;

  UserCompanyModel(
      {this.cnpj,
      this.email,
      this.nome,
      this.senha,
      this.isCompany,
      this.profileCompleted});

  Map<String, dynamic> toMap(UserCompanyModel user) {
    return {
      'name': user.nome,
      'email': user.email,
      'password': user.senha,
      'cnpj': user.cnpj,
      'profileCompleted': false,
      'isCompany': user.isCompany
    };
  }
}
