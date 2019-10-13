import 'package:contratacao_funcionarios/src/blocs/signup_user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/signup_company_page.dart';
import 'package:contratacao_funcionarios/src/screens/email_confirmation_screen.dart';
import 'package:contratacao_funcionarios/src/widgets/input_field.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:contratacao_funcionarios/src/widgets/navigator_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class CadastroClientePage extends StatefulWidget {
  @override
  _CadastroClientePageState createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  static final GlobalKey<FormBuilderState> _fbProfessional =
      GlobalKey<FormBuilderState>();

  SignupUserBloc _userBloc;
  UserProviderModel model;

  TextEditingController _cpfController = new TextEditingController();
  TextEditingController _cnpjController;
  TextEditingController _passController = new TextEditingController();
  TextEditingController _passRepController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    model = Provider.of<UserProviderModel>(context);
    
    _userBloc = SignupUserBloc(model);

    _listenOutState();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 2,
          title: Text(
            "Cadastrar",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: _signupScreenForms());
  }

  void _listenOutState(){
    _userBloc.outState.listen((state) {
      switch (state) {
        case SignupState.SUCCESS:
          Navigator.of(context).pop();
          Navigator.of(context)
              .pushReplacement(NavigatorAnimation(widget: EmailConfirmationScreen(typeUser: 1)));
          break;
        default:
          return Container();
      }
    });
  }

  Widget _signupScreenForms() {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildFormBuilderProfessional(),
        SizedBox(
          height: 5,
        ),
        FlatButton(
          child: Text(
            "Cadastrar Empresa",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 16,
                color: Theme.of(context).cardColor),
          ),
          onPressed: () {
            Navigator.push(
              context,
              NavigatorAnimation(widget: SignupCompanyPage()),
            );
          },
        )
      ],
    ));
  }

  Widget _buildFormBuilderProfessional() {
    return FormBuilder(
      key: _fbProfessional,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            _buildTextBuildName(),
            SizedBox(
              height: 30,
            ),
            _buildTextBuildCpf(),
            SizedBox(
              height: 10,
            ),
            _buildTextBuildEmail(_emailController),
            SizedBox(
              height: 30,
            ),
            _buildTextBuildPassword(_passController),
            SizedBox(
              height: 30,
            ),
            _buildTextBuildPasswordRep(_passRepController),
            SizedBox(
              height: 30,
            ),
            StreamBuilder(
              stream: _userBloc.outState,
              initialData: SignupState.IDLE,
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case SignupState.LOADING:
                    return Loader();
                    break;
                  case SignupState.IDLE:
                    return _buildButtonSignup();
                    break;

                  default:
                    return _buildButtonSignup();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void signupActionButton(GlobalKey<FormBuilderState> key, UserModel user) {
    key.currentState.save();

    if (key.currentState.validate()) {
      _userBloc.doSignUp.add(user.toMap(user));
    }
  }

  FormBuilderTextField _buildTextBuildCnpj() {
    return FormBuilderTextField(
      autofocus: false,
      attribute: "Cnpj",
      keyboardType: TextInputType.number,
      controller: _cnpjController,
      maxLength: 14,
      decoration: new InputDecoration(
        helperStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Color.fromRGBO(255, 255, 255, 1),
        hintText: 'Cnpj',
        hintStyle: TextStyle(color: Colors.grey[600]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        focusedBorder: OutlineInputBorder(
          borderSide:
              new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
            borderRadius: BorderRadius.all(Radius.circular(3))),
      ),
      validators: [
        FormBuilderValidators.required(errorText: 'O CNPJ é obrigatório'),
        FormBuilderValidators.max(14),
        FormBuilderValidators.min(14),
      ],
    );
  }

  FormBuilderTextField _buildTextBuildName() {
    return FormBuilderTextField(
      autofocus: false,
      attribute: "Nome",
      controller: _nameController,
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
        helperStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Color.fromRGBO(255, 255, 255, 1),
        hintText: 'Nome',
        hintStyle: TextStyle(color: Colors.grey[600]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        focusedBorder: OutlineInputBorder(
          borderSide:
              new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
            borderRadius: BorderRadius.all(Radius.circular(3))),
      ),
      validators: [
        FormBuilderValidators.required(errorText: 'O Nome é obrigatório'),
        FormBuilderValidators.maxLength(30,
            errorText: 'Passou de 30 carcateres.'),
      ],
    );
  }

  FormBuilderTextField _buildTextBuildCpf() {
    return FormBuilderTextField(
      autofocus: false,
      attribute: "Cpf",
      controller: _cpfController,
      keyboardType: TextInputType.number,
      maxLength: 11,
      decoration: new InputDecoration(
        helperStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Color.fromRGBO(255, 255, 255, 1),
        hintText: 'Cpf',
        hintStyle: TextStyle(color: Colors.grey[600]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        focusedBorder: OutlineInputBorder(
          borderSide:
              new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
            borderRadius: BorderRadius.all(Radius.circular(3))),
      ),
      validators: [
        FormBuilderValidators.required(errorText: 'O CPF é obrigatório'),
        FormBuilderValidators.maxLength(12,
            errorText: 'O cpf precisa ter 11 números.'),
      ],
    );
  }

  Widget _buildTextBuildEmail(TextEditingController key) {
    return InputField(
        key,
        false,
        TextInputType.emailAddress,
        'Email',
        [
          FormBuilderValidators.required(errorText: 'O email é obrigatório'),
          FormBuilderValidators.email(
              errorText: 'O formato do email está inválido'),
          FormBuilderValidators.max(50),
          FormBuilderValidators.min(12),
        ],
        _userBloc.outEmail,
        _userBloc.changeEmail,
        'Email Cadastro',
        false);
  }

  FormBuilderTextField _buildTextBuildPassword(TextEditingController key) {
    return FormBuilderTextField(
      autofocus: false,
      attribute: "Senha",
      controller: key,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: new InputDecoration(
        helperStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Color.fromRGBO(255, 255, 255, 1),
        hintText: 'Senha',
        hintStyle: TextStyle(color: Colors.grey[600]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        focusedBorder: OutlineInputBorder(
          borderSide:
              new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
            borderRadius: BorderRadius.all(Radius.circular(3))),
      ),
      validators: [
        FormBuilderValidators.required(
            errorText: 'O campo da senha é obrigatória'),
        FormBuilderValidators.passEquals(
            pass: _passController.text, passRep: _passRepController.text),
        FormBuilderValidators.max(50),
        FormBuilderValidators.min(7),
      ],
    );
  }

  FormBuilderTextField _buildTextBuildPasswordRep(TextEditingController key) {
    return FormBuilderTextField(
      autofocus: false,
      attribute: "Repetir Senha",
      controller: key,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: new InputDecoration(
        helperStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Color.fromRGBO(255, 255, 255, 1),
        hintText: 'Repetir Senha',
        hintStyle: TextStyle(color: Colors.grey[600]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        focusedBorder: OutlineInputBorder(
          borderSide:
              new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
            borderRadius: BorderRadius.all(Radius.circular(3))),
      ),
      validators: [
        FormBuilderValidators.required(
            errorText: 'O campo da senha é obrigatória'),
        FormBuilderValidators.passEquals(
            pass: _passController.text, passRep: _passRepController.text),
        FormBuilderValidators.max(50),
        FormBuilderValidators.min(7),
      ],
    );
  }

  Widget _buildButtonSignup() {
    return Container(
      child: FlatButton(
        color: Colors.black,
        padding: EdgeInsets.all(10),
        child: Text(
          'Cadastrar',
          style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          UserModel user = new UserModel(
              cpf: _cpfController.text,
              email: _emailController.text,
              senha: _passController.text,
              nome: _nameController.text,
              isCompany: false);

          signupActionButton(_fbProfessional, user);
        },
      ),
      width: double.infinity,
    );
  }
}
