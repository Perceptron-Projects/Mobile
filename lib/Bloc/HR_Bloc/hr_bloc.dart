import 'package:ams/Model/ui_state.dart';
import 'package:ams/resource/Service/network_error.dart';
import 'package:ams/resource/Service/unauthenticated_error_response.dart';
import 'package:ams/resource/repo/hr/hr_repository.dart';
import 'package:ams/resource/repo/hr/hr_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

class HRBloc {
  final HRRepository _hrRepository;
  final BehaviorSubject<UIState> _allUserController;

  HRBloc()
      : _hrRepository = HRRepositoryImpl(),
        _allUserController = BehaviorSubject<UIState>.seeded(IdleUIState());

  Stream<UIState> get allUser => _allUserController.stream;

  getAllUsers(String token, String companyId) async {
    _allUserController.sink.add(LoadingUIState());
    try {
      var result = await _hrRepository.getAllUsers(token, companyId);
      if (result.isEmpty) {
        _allUserController.sink.add(NoResultUIState());
      } else {
        _allUserController.sink.add(ResultUIState(result));
      }
    } on UnAuthenticatedErrorResponse catch (e) {
      _allUserController.sink.add(UnAuthenticatedUIState(e.message));
    } on NetworkError catch (e) {
      _allUserController.sink.add(ErrorUIState(e.message));
    } catch (e) {
      _allUserController.sink.add(ErrorUIState(e.toString()));
    }
  }

  void dispose() {
    _allUserController.close();
  }
}
