import 'package:contratacao_funcionarios/src/blocs/signup_user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_company_model.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/email_confirmation_screen.dart';
import 'package:contratacao_funcionarios/src/widgets/input_field.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:contratacao_funcionarios/src/widgets/navigator_animation.dart';
import 'package:contratacao_funcionarios/src/widgets/title_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class SignupCompanyPage extends StatefulWidget {
  @override
  _SignupCompanyPageState createState() => _SignupCompanyPageState();
}

class _SignupCompanyPageState extends State<SignupCompanyPage> {
  static final GlobalKey<FormBuilderState> _fbProfessional =
      GlobalKey<FormBuilderState>();

  SignupUserBloc _userBloc;
  UserProviderModel model;

  TextEditingController _cnpjController = new TextEditingController();
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
          title: TitleScaffold(
            title: 'Cadastrar',
          ),
        ),
        body: _signupScreenForms());
  }

  Widget _buildFormBuilderProfessional() {
    return FormBuilder(
      key: _fbProfessional,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            _buildTextBuildCnpj(),
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
              height: 50,
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

  void _listenOutState() {
    _userBloc.outState.listen((state) {
      switch (state) {
        case SignupState.SUCCESS:
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => EmailConfirmationScreen(
              typeUser: 2,
            ),
            transitionsBuilder: (context, anim1, anim2, child) =>
                FadeTransition(opacity: anim1, child: child),
            transitionDuration: Duration(seconds: 1),
          ));

          break;
        default:
          return Container();
      }
    });
  }

  Widget _buildButtonSignup() {
    return Container(
      child: FlatButton(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.all(10),
        child: Text(
          'Cadastrar',
          style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          UserCompanyModel user = new UserCompanyModel(
              cnpj: _cnpjController.text,
              email: _emailController.text,
              senha: _passController.text,
              nome: _nameController.text,
              isCompany: true);

          signupActionButton(_fbProfessional, user);
        },
      ),
      width: double.infinity,
    );
  }

  void signupActionButton(
      GlobalKey<FormBuilderState> key, UserCompanyModel user) {
    key.currentState.save();

    if (key.currentState.validate()) {
      _userBloc.doSignUp.add(user.toMap(user));
    }
  }

  FormBuilderTextField _buildTextBuildPasswordRep(TextEditingController key) {
    return FormBuilderTextField(
      autofocus: false,
      attribute: "Confirmar Senha",
      controller: key,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: new InputDecoration(
        helperStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Color.fromRGBO(255, 255, 255, 1),
        hintText: 'Confirmar Senha',
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
        'Email Cadastro empresa',
        false);
  }

  Widget _signupScreenForms() {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildFormBuilderProfessional(),
        
      ],
    ));
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
        FormBuilderValidators.min(14,
            errorText: 'O CNPJ precisa ter 14 números.'),
      ],
    );
  }
}
