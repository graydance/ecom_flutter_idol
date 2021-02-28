import 'package:idol/store/actions/actions.dart';
import 'package:redux/redux.dart';

/// BioLinks
final bioLinksReducer = combineReducers<BioLinksState>([
  TypedReducer<BioLinksState, BioLinksAction>(_onBioLinks),
  TypedReducer<BioLinksState, BioLinksSuccessAction>(_onBioLinksSuccess),
  TypedReducer<BioLinksState, BioLinksFailureAction>(_onBioLinksFailure),
]);

BioLinksLoading _onBioLinks(BioLinksState state, BioLinksAction action) {
  return BioLinksLoading();
}

BioLinksSuccess _onBioLinksSuccess(
    BioLinksState state, BioLinksSuccessAction action) {
  return BioLinksSuccess(action.bioLinks);
}

BioLinksFailure _onBioLinksFailure(
    BioLinksState state, BioLinksFailureAction action) {
  return BioLinksFailure(action.message);
}

/// AddBioLinks
final addAddBioLinksReducer = combineReducers<AddBioLinksState>([
  TypedReducer<AddBioLinksState, AddBioLinksAction>(_onAddBioLinks),
  TypedReducer<AddBioLinksState, AddBioLinksSuccessAction>(_onAddBioLinksSuccess),
  TypedReducer<AddBioLinksState, AddBioLinksFailureAction>(_onAddBioLinksFailure),
]);

AddBioLinksLoading _onAddBioLinks(AddBioLinksState state, AddBioLinksAction action) {
  return AddBioLinksLoading();
}

AddBioLinksSuccess _onAddBioLinksSuccess(
    AddBioLinksState state, AddBioLinksSuccessAction action) {
  return AddBioLinksSuccess();
}

AddBioLinksFailure _onAddBioLinksFailure(
    AddBioLinksState state, AddBioLinksFailureAction action) {
  return AddBioLinksFailure(action.message);
}

/// EditBioLinks
final editBioLinksReducer = combineReducers<EditBioLinksState>([
  TypedReducer<EditBioLinksState, EditBioLinksAction>(_onEditBioLinks),
  TypedReducer<EditBioLinksState, EditBioLinksSuccessAction>(_onEditBioLinksSuccess),
  TypedReducer<EditBioLinksState, EditBioLinksFailureAction>(_onEditBioLinksFailure),
]);

EditBioLinksLoading _onEditBioLinks(EditBioLinksState state, EditBioLinksAction action) {
  return EditBioLinksLoading();
}

EditBioLinksSuccess _onEditBioLinksSuccess(
    EditBioLinksState state, EditBioLinksSuccessAction action) {
  return EditBioLinksSuccess();
}

EditBioLinksFailure _onEditBioLinksFailure(
    EditBioLinksState state, EditBioLinksFailureAction action) {
  return EditBioLinksFailure(action.message);
}

/// DeleteBioLinks
final deleteBioLinksReducer = combineReducers<DeleteBioLinksState>([
  TypedReducer<DeleteBioLinksState, DeleteBioLinksAction>(_onDeleteBioLinks),
  TypedReducer<DeleteBioLinksState, DeleteBioLinksSuccessAction>(_onDeleteBioLinksSuccess),
  TypedReducer<DeleteBioLinksState, DeleteBioLinksFailureAction>(_onDeleteBioLinksFailure),
]);

DeleteBioLinksLoading _onDeleteBioLinks(DeleteBioLinksState state, DeleteBioLinksAction action) {
  return DeleteBioLinksLoading();
}

DeleteBioLinksSuccess _onDeleteBioLinksSuccess(
    DeleteBioLinksState state, DeleteBioLinksSuccessAction action) {
  return DeleteBioLinksSuccess();
}

DeleteBioLinksFailure _onDeleteBioLinksFailure(
    DeleteBioLinksState state, DeleteBioLinksFailureAction action) {
  return DeleteBioLinksFailure(action.message);
}