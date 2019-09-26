import 'package:contratacao_funcionarios/src/screens/tabs/contact_tab.dart';
import 'package:contratacao_funcionarios/src/shared/custom_sliver_appbar.dart';
import 'package:contratacao_funcionarios/src/widgets/button_input.dart';
import 'package:contratacao_funcionarios/src/widgets/navigator_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HowWorksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CustomScrollView(slivers: <Widget>[
      CustomSliverAppbar("Como funciona"),
      SliverToBoxAdapter(
        child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Preencha seu cadastro",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Preencha seu cadastro com suas informações pessoais, quando você tiver completado o cadastro seu perfil será exibido para as empresas e estabelecimentos interessados em um profissional com sua qualificação.",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Histórico Profissional",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "A cada trabalho finalizado seu histórico profissional e avaliação serão atualizados, dessa forma o contratante tem certeza que está contratando alguém confiável e qualificado.",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Qualquer dúvida nos envie uma mensagem que iremos tirar sua dúvida.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  child: ButtonInput.getButton(
                      TYPE_BUTTON.NORMAL, COLOR_BUTTON.DEFAULT, 'Contato', () {
                    Navigator.pushNamed(context, '/contactTab');
                  }, context, null),
                )
              ],
            )),
      ),
    ]));
  }
}
