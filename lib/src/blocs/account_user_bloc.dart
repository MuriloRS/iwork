import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class AccountUserBloc extends BlocBase{

  //CONTROLLERS
  var nameController = BehaviorSubject<String>();

  //STREAMS
  Stream<String> get outName => nameController.stream;


  //SINKS
  Function(String) get changeName => nameController.sink.add;
  

  @override
  void dispose(){
    super.dispose();

    nameController.close();
  }

}