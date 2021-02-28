import 'package:idol/models/biolinks.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/net/request/biolinks.dart';

/// BioLinksState
abstract class BioLinksState {}

class BioLinksInitial implements BioLinksState {
  const BioLinksInitial();
}

class BioLinksLoading implements BioLinksState {}

class BioLinksSuccess implements BioLinksState {
  final BioLinks bioLinks;

  BioLinksSuccess(this.bioLinks);
}

class BioLinksFailure implements BioLinksState {
  final String message;

  BioLinksFailure(this.message);
}
/// BioLinksAction
class BioLinksAction {

  final BaseRequest request;

  BioLinksAction(this.request);
}

class BioLinksSuccessAction {
  final BioLinks bioLinks;

  BioLinksSuccessAction(this.bioLinks);
}

class BioLinksFailureAction {
  final String message;
  BioLinksFailureAction(this.message);
}

abstract class AddBioLinksState {}

class AddBioLinksInitial implements AddBioLinksState {
  const AddBioLinksInitial();
}

class AddBioLinksLoading implements AddBioLinksState {}

class AddBioLinksSuccess implements AddBioLinksState {

}

class AddBioLinksFailure implements AddBioLinksState {
  final String message;

  AddBioLinksFailure(this.message);
}
/// AddBioLinksAction
class AddBioLinksAction {

  final AddLinksRequest request;

  AddBioLinksAction(this.request);
}

class AddBioLinksSuccessAction {

}

class AddBioLinksFailureAction {
  final String message;
  AddBioLinksFailureAction(this.message);
}

abstract class EditBioLinksState {}

class EditBioLinksInitial implements EditBioLinksState {
  const EditBioLinksInitial();
}

class EditBioLinksLoading implements EditBioLinksState {}

class EditBioLinksSuccess implements EditBioLinksState {

}

class EditBioLinksFailure implements EditBioLinksState {
  final String message;

  EditBioLinksFailure(this.message);
}
/// EditBioLinksAction
class EditBioLinksAction {

  final EditLinksRequest request;

  EditBioLinksAction(this.request);
}

class EditBioLinksSuccessAction {
}

class EditBioLinksFailureAction {
  final String message;
  EditBioLinksFailureAction(this.message);
}

/// DeleteBioLinksState
abstract class DeleteBioLinksState {}

class DeleteBioLinksInitial implements DeleteBioLinksState {
  const DeleteBioLinksInitial();
}

class DeleteBioLinksLoading implements DeleteBioLinksState {}

class DeleteBioLinksSuccess implements DeleteBioLinksState {

}

class DeleteBioLinksFailure implements DeleteBioLinksState {
  final String message;

  DeleteBioLinksFailure(this.message);
}
/// DeleteBioLinksAction
class DeleteBioLinksAction {

  final BaseRequest request;

  DeleteBioLinksAction(this.request);
}

class DeleteBioLinksSuccessAction {
}

class DeleteBioLinksFailureAction {
  final String message;
  DeleteBioLinksFailureAction(this.message);
}

/// UpdateUserInfoState
abstract class UpdateUserInfoState {}

class UpdateUserInfoInitial implements UpdateUserInfoState {
  const UpdateUserInfoInitial();
}

class UpdateUserInfoLoading implements UpdateUserInfoState {}

class UpdateUserInfoSuccess implements UpdateUserInfoState {

}

class UpdateUserInfoFailure implements UpdateUserInfoState {
  final String message;

  UpdateUserInfoFailure(this.message);
}
/// UpdateUserInfoAction
class UpdateUserInfoAction {

  final UpdateUserInfoRequest request;

  UpdateUserInfoAction(this.request);
}

class UpdateUserInfoSuccessAction {
}

class UpdateUserInfoFailureAction {
  final String message;
  UpdateUserInfoFailureAction(this.message);
}