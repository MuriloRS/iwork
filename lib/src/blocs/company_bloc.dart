import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum State { IDLE, LOADING, SUCCESS, FAIL }

class AccountUserBloc extends BlocBase {
  final stateController = BehaviorSubject<State>();
  Stream<State> get outState => stateController.stream;

  Future<Map<String,dynamic>> getProfessionals(){
    //Firestore.instance.
  }

  @override
  void dispose() {
    super.dispose();

    stateController.close();
  }
}
