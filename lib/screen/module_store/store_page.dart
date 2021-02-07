import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/user.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/screen/module_store/store_goods_category_tab_view.dart';
import 'package:idol/screen/module_store/store_goods_list_tab_view.dart';
import 'package:idol/store/actions/store.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/loading.dart';
import 'package:redux/redux.dart';

class StorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StorePageState();
  }
}

class _StorePageState extends State<StorePage>
    with AutomaticKeepAliveClientMixin<StorePage>,TickerProviderStateMixin<StorePage>  {

  TabController _tabController;
  int _currentTabIndex = 0;
  var _leftTabIcon = R.image.ic_tab_product_selected();
  var _rightTabIcon = R.image.ic_tab_category_unselected();

  double _expandedHeight() {
    Size size = MediaQuery.of(context).size;
    return size.height *
        (320 / 812); // + MediaQuery.of(context).viewPadding.top
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if(_tabController.index != _currentTabIndex){
          _currentTabIndex = _tabController.index;
          setState(() {
            if(_tabController.index == 0){
              _leftTabIcon = R.image.ic_tab_product_selected();
              _rightTabIcon = R.image.ic_tab_category_unselected();
            }else{
              _leftTabIcon = R.image.ic_tab_product_unselected();
              _rightTabIcon = R.image.ic_tab_category_selected();
            }
          });
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
            .dispatch(MyInfoAction(BaseRequestImpl()));
      },
      builder: (context, vm) {
        return Scaffold(
          body: _buildStorePage(vm),
        );
      },
    );
  }

  Widget _buildStorePage(_ViewModel vm) {
    return vm._myInfoState is MyInfoInitial || vm._myInfoState is MyInfoLoading
        ? IdolLoadingWidget()
        : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    floating: false,
                    pinned: false,
                    expandedHeight: _expandedHeight(),
                    flexibleSpace: FlexibleSpaceBar(
                        title: Text("",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            )),
                        background: _buildFlexibleSpaceWidget(vm)),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Colours.color_1E2539,
                        tabs: [
                          Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 10),
                            child: Image(
                              image: _leftTabIcon,
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 10),
                            child: Image(
                              image: _rightTabIcon,
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
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
                    GoodsListTabView(),
                    GoodsCategoryTabView(),
                  ].toList(),
                ),
              ),
          );
  }

  Widget _buildFlexibleSpaceWidget(_ViewModel vm) {
    User myInfo;
    if (vm._myInfoState is MyInfoSuccess) {
      myInfo = (vm._myInfoState as MyInfoSuccess).myInfo;
    }
    return Container(
      child: Container(
        padding: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          color: Colours.white,
          image: DecorationImage(
            image: myInfo != null && myInfo.storePicture != null
                ? NetworkImage(myInfo.storePicture)
                : R.image.bg_header(),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(myInfo == null
                                    ? Global.getUser(context).portrait
                                    : myInfo.portrait)),
                            border:
                                Border.all(color: Colours.white, width: 1.0),
                            color: Colours.color_F8F8F8,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              myInfo == null
                                  ? Global.getUser(context).storeName == null
                                      ? '-'
                                      : Global.getUser(context).storeName
                                  : myInfo.storeName == null
                                      ? '-'
                                      : myInfo.storeName,
                              style:
                                  TextStyle(fontSize: 16, color: Colours.white),
                            ),
                            Text(
                              myInfo == null
                                  ? Global.getUser(context).userName == null
                                      ? '-'
                                      : Global.getUser(context).userName
                                  : myInfo.userName == null
                                      ? '-'
                                      : myInfo.userName,
                              style:
                                  TextStyle(fontSize: 14, color: Colours.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colours.white,
                      size: 18,
                    ),
                    onPressed: () => IdolRoute.startSettings(context),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        myInfo == null
                            ? Global.getUser(context).products.toString()
                            : myInfo.products.toString(),
                        style: TextStyle(fontSize: 16, color: Colours.white),
                      ),
                      Text(
                        'Products',
                        style: TextStyle(fontSize: 12, color: Colours.white),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  Column(
                    children: [
                      Text(
                        myInfo == null
                            ? Global.getUser(context).followers.toString()
                            : myInfo.followers.toString(),
                        style: TextStyle(fontSize: 16, color: Colours.white),
                      ),
                      Text(
                        'Followers',
                        style: TextStyle(fontSize: 12, color: Colours.white),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  Column(
                    children: [
                      Text(
                        myInfo == null
                            ? Global.getUser(context).followings.toString()
                            : myInfo.followings.toString(),
                        style: TextStyle(fontSize: 16, color: Colours.white),
                      ),
                      Text(
                        'Following',
                        style: TextStyle(fontSize: 12, color: Colours.white),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                myInfo == null
                    ? Global.getUser(context).aboutMe == null
                        ? '-'
                        : Global.getUser(context).aboutMe
                    : myInfo.aboutMe == null
                        ? '-'
                        : myInfo.aboutMe,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colours.white,
                ),
                strutStyle:
                    StrutStyle(forceStrutHeight: true, height: 0.2, leading: 1),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 5,
              ),
              // Tags
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                spacing: 6.0,
                runSpacing: 6.0,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: _buildTagsFromAboutMe(myInfo == null
                    ? Global.getUser(context).aboutMe == null
                        ? '-'
                        : Global.getUser(context).aboutMe
                    : myInfo.aboutMe == null
                        ? '-'
                        : myInfo.aboutMe),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      child: Text(
                        'Edit Store',
                        style: TextStyle(
                            fontSize: 14, color: Colours.color_0F1015),
                      ),
                      color: Colours.white,
                      textColor: Colours.color_0F1015,
                      onPressed: () {
                        IdolRoute.startStoreEditStore(context).then((value) {
                          if (value != null && value is Command) {
                            if (value == Command.refreshMyInfo) {
                              Future.delayed(Duration(seconds: 2))
                                  .then((value) {
                                StoreProvider.of<AppState>(context)
                                    .dispatch(MyInfoAction(BaseRequestImpl()));
                              });
                            }
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text(
                        'Statistics',
                        style: TextStyle(fontSize: 14, color: Colours.white),
                      ),
                      color: Colours.color_EA5228,
                      textColor: Colours.white,
                      // TODO Statistics
                      onPressed: () => IdolRoute.startStoreEditStore(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTagsFromAboutMe(String aboutMe) {
    if (aboutMe == null || aboutMe.isEmpty || !aboutMe.contains('#')) {
      return [];
    } else {
      List<Widget> tagWidgets = [];
      // TODO 正则表达式获取tags转为Text
      // Text('', style: TextStyle(fontSize: 12, color: Colours.color_48B6EF),),
      return tagWidgets;
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colours.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}

class _ViewModel {
  final MyInfoState _myInfoState;

  _ViewModel(this._myInfoState);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.myInfoState);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _myInfoState == other._myInfoState;

  @override
  int get hashCode => _myInfoState.hashCode;
}
