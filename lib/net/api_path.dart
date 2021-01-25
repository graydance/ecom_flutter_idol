class ApiPath{
  // 注册登录
  static final String login = '/user/pub/login';
  // 供应商详情
  static final String userDetail = '/user/detail';
  // 当前用户详情
  static final String myInfo = '/user/myinfo';
  // 编辑店铺
  static final String editStore = '/idol/edit_store';
  // 检测用户名或商店名是否存在
  static final String checkName = '/idol/check_name';
  // Dashboard
  static final String home = '/idol/home';
  // Dashboard->提现信息
  static final String withdrawInfo = '/idol/withdrawInfo';
  // Dashboard->提现
  static final String withdraw = '/idol/withdraw';
  // Dashboard->任务完成领取奖励
  static final String completeRewards = '/idol/complete_rewards';
  // Supply
  static final String following = '/idol/following';
  // Supply->Following|ForYou->Add to my Store.
  static final String addStore = '/idol/add_store';
  // Store->UserDetail(left|right goods)
  static final String goodsList = '/user/pub/good_list';
  // Upload
  static final String upload = '/api/upload';
}