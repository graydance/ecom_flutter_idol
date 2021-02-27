import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/biolinks.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/net/request/biolinks.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/screen/module_biolinks/biolinks_list_item.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:redux/redux.dart';

class BioLinksTabView extends StatefulWidget {
  final BioLinks bioLinks;

  const BioLinksTabView({Key key, this.bioLinks}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BioLinksTabView();
}

class _BioLinksTabView extends State<BioLinksTabView> {
  bool _addLinkLoading = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        store.dispatch(BioLinksAction(BaseRequestImpl()));
      },
      onWillChange: (oldVM, newVM) {
        _onBioLinksStateChange(newVM);
      },
      distinct: true,
      builder: (context, vm) {
        return Container(
          padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text(
                      'Add New Link +',
                      style: TextStyle(
                        color: Colours.color_555764,
                        fontSize: 12,
                      ),
                    ),
                    color: Colours.white,
                    onPressed: () {
                      // add link
                      vm._addBioLinks(AddLinksRequest(0));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RaisedButton(
                    child: Text(
                      'Add Text',
                      style: TextStyle(
                        color: Colours.color_555764,
                        fontSize: 12,
                      ),
                    ),
                    color: Colours.white,
                    onPressed: () {
                      // TODO add text
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),

              Visibility(
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colours.color_EA5228),
                  ),
                ),
                visible: _addLinkLoading,
              ),
              // Links
              _createLinksWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget _createLinksWidget() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: widget.bioLinks.list
            .map((e) => BioLinksItemWidget(e, (EditLinksRequest request) {
                  // TODO update links
                }))
            .toList(),
      ),
    );
  }

  void _onBioLinksStateChange(_ViewModel vm) {
    if (vm._bioLinksState is BioLinksInitial ||
        vm._bioLinksState is BioLinksLoading) {
      // do nothings
    } else if (vm._bioLinksState is BioLinksSuccess) {
      // TODO
    } else if (vm._bioLinksState is BioLinksFailure) {
      EasyLoading.showError((vm._bioLinksState as BioLinksFailure).message);
    } else if (vm._addBioLinksState is BioLinksLoading) {
      setState(() {
        _addLinkLoading = true;
      });
    } else if (vm._addBioLinksState is BioLinksSuccess) {
      setState(() {
        _addLinkLoading = false;
      });
    } else if (vm._addBioLinksState is BioLinksFailure) {
      setState(() {
        _addLinkLoading = false;
      });
      EasyLoading.showError((vm._bioLinksState as BioLinksFailure).message);
    } else if (vm._editBioLinksState is EditBioLinksSuccess) {
      // TODO

    }
  }

  void refresh() {
    setState(() {});
  }
}

class _ViewModel {
  final BioLinksState _bioLinksState;
  final AddBioLinksState _addBioLinksState;
  final EditBioLinksState _editBioLinksState;
  final DeleteBioLinksState _deleteBioLinksState;
  final UpdateUserInfoState _updateUserInfoState;

  final Function(AddLinksRequest) _addBioLinks;
  final Function(EditLinksRequest) _editBioLinks;
  final Function(DeleteLinksRequest) _deleteBioLinks;
  final Function(UpdateUserInfoRequest) _updateUserName;

  _ViewModel(
      this._bioLinksState,
      this._addBioLinksState,
      this._editBioLinksState,
      this._deleteBioLinksState,
      this._updateUserInfoState,
      this._addBioLinks,
      this._editBioLinks,
      this._deleteBioLinks,
      this._updateUserName);

  static _ViewModel fromStore(Store<AppState> store) {
    void _addBioLinks(AddLinksRequest req) {
      store.dispatch(AddBioLinksAction(req));
    }

    void _editBioLinks(EditLinksRequest req) {
      store.dispatch(EditBioLinksAction(req));
    }

    void _deleteBioLinks(DeleteLinksRequest req) {
      store.dispatch(DeleteBioLinksAction(req));
    }

    void _updateUserInfo(UpdateUserInfoRequest req) {
      store.dispatch(UpdateUserInfoAction(req));
    }

    return _ViewModel(
        store.state.bioLinksState,
        store.state.addBioLinksState,
        store.state.editBioLinksState,
        store.state.deleteBioLinksState,
        store.state.updateUserInfoState,
        _addBioLinks,
        _editBioLinks,
        _deleteBioLinks,
        _updateUserInfo);
  }
}
