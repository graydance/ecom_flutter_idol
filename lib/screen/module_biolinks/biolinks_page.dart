import 'package:flutter/material.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/net/request/biolinks.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/screen/module_biolinks/biolinks_store_tab_view.dart';
import 'package:idol/screen/module_biolinks/biolinks_tab_view.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/button.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/widgets/loading.dart';
import 'package:idol/widgets/sliver_appbar_delegate.dart';
import 'package:redux/redux.dart';

class BioLinksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BioLinksPageState();
}

class _BioLinksPageState extends State<BioLinksPage>
    with
        AutomaticKeepAliveClientMixin<BioLinksPage>,
        SingleTickerProviderStateMixin<BioLinksPage> {
  final GlobalKey<EditButtonState> editButtonKey = GlobalKey();
  final GlobalKey _flexibleSpaceBarKey = GlobalKey();
  Size _sizeFlexibleSpaceBar;
  TabController _tabController;
  int _currentTabIndex = 0;
  bool _copyVisible = true;

  getSizeAndPosition() {
    RenderBox _cardBox = _flexibleSpaceBarKey.currentContext.findRenderObject();
    _sizeFlexibleSpaceBar = _cardBox.size;
  }

  // 将头部控件设置为透明，通过短暂渲染显示获取到其他高度后再赋值
  Widget _copyFlexibleSpaceWidget() {
    return Opacity(
      key: _flexibleSpaceBarKey,
      opacity: 0.0,
      child: _buildFlexibleSpaceWidget(null),
    );
  }

  double _getMarginTopHeight() {
    return MediaQuery.of(context).padding.top + kToolbarHeight;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());
    Future.delayed(Duration(microseconds: 1)).then((value) {
      setState(() {});
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _currentTabIndex) {
        _currentTabIndex = _tabController.index;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      distinct: true,
      onInit: (store) {
        StoreProvider.of<AppState>(context)
            .dispatch(BioLinksAction(BaseRequestImpl()));
      },
      onWillChange: (oldVM, newVM) {
        _onStateChanged();
      },
      builder: (context, vm) {
        return Scaffold(
          body: _buildBodyWidget(vm),
        );
      },
    );
  }

  void _onStateChanged() {
    // TODO
  }

  Widget _buildBodyWidget(_ViewModel vm) {
    if (vm._bioLinksState is BioLinksInitial) {
      return Center(
        child: Stack(
          children: [
            _copyFlexibleSpaceWidget(),
            IdolLoadingWidget(),
          ],
        ),
      );
    } else {
      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              actions: [
                EditButton(key: editButtonKey),
              ],
              elevation: 0,
              title: Text('Manage BioLinks',
                  style: TextStyle(
                    color: Colours.color_29292B,
                    fontSize: 16.0,
                  )),
              centerTitle: false,
              titleSpacing: 0,
              floating: true,
              pinned: true,
              snap: false,
              // 如何动态计算该高度，详情参考[https://github.com/flutter/flutter/issues/18345]
              expandedHeight: _sizeFlexibleSpaceBar.height,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildFlexibleSpaceWidget(vm),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colours.color_1E2539,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: Text(
                        'Links',
                        style: TextStyle(
                            color: _tabController.index == 0
                                ? Colours.color_555764
                                : Colours.color_70555764,
                            fontSize: 16,
                            fontWeight: _tabController.index == 0
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: Text(
                        'Store Preview',
                        style: TextStyle(
                            color: _tabController.index == 0
                                ? Colours.color_70555764
                                : Colours.color_555764,
                            fontSize: 16,
                            fontWeight: _tabController.index == 0
                                ? FontWeight.normal
                                : FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          child: TabBarView(
            controller: _tabController,
            children: [
              BioLinksTabView(),
              BioLinksStoreTabView(),
            ].toList(),
          ),
        ),
      );
    }
  }

  Widget _buildFlexibleSpaceWidget(_ViewModel vm) {
    return Container(
      color: Colours.white,
      child: Column(
        children: [
          Container(
            color: Colours.color_F8F8F8,
            child: Row(
              children: [
                TextField(),
                Offstage(
                  offstage: _copyVisible,
                  child: RaisedButton(
                    child: Text('Copy',
                        style: TextStyle(color: Colours.white, fontSize: 11)),
                    onPressed: () {
                      // TODO Copy link
                    },
                    color: Colours.color_48B6EF,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(Global.getUser(context).portrait),
            ),
          ),
          Text(
            '@${Global.getUser(context).userName}',
            style: TextStyle(color: Colours.color_555764, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ViewModel {
  final BioLinksState _bioLinksState;
  final Function(AddLinksRequest) _addBioLinks;
  final Function(EditLinksRequest) _editBioLinks;
  final Function(DeleteLinksRequest) _deleteBioLinks;
  final Function(UpdateUserInfoRequest) _updateUserName;

  _ViewModel(this._bioLinksState, this._addBioLinks, this._editBioLinks,
      this._deleteBioLinks, this._updateUserName);

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

    return _ViewModel(store.state.bioLinksState, _addBioLinks, _editBioLinks,
        _deleteBioLinks, _updateUserInfo);
  }
}
