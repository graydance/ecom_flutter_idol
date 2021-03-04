class ApiPath {
  // 检测email是否在白名单
  static final String whiteList = '/idol/pub/white_list';
  // 注册登录
  static final String login = '/user/pub/login';
  // 更新密码
  static final String updatePassword = '/idol/update_password';
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
  // BestSales
  static final String bestSales = '/idol/best_sales';
  // SalesHistory
  static final String salesHistory = '/idol/daylong_sales';
  // Dashboard->提现信息
  static final String withdrawInfo = '/idol/withdrawInfo';
  // Dashboard->提现
  static final String withdraw = '/idol/withdraw';
  // Dashboard->任务完成领取奖励
  static final String completeRewards = '/idol/complete_rewards';
  // Supply Goods List
  static final String supplyGoodsList = '/idol/following';
  // Supply Follow | UnFollow
  static final String follow = '/idol/follow';
  // Goods Detail
  static final String goodsDetail = '/idol/goods_detail';
  // Supplier info
  static final String supplierInfo = '/idol/supplier_detail';
  // Supplier goods list
  static final String supplierGoodsList = '/idol/supplier_goods';
  // Supply->Following|ForYou->Add to my Store.
  static final String addStore = '/idol/add_store';
  // Store->UserDetail(left|right goods)
  static final String storeGoodsList = '/user/pub/good_list';
  // Delete goods
  static final String deleteGoods = '/idol/delete_goods';
  // Upload
  static final String upload = '/api/upload';
  // BioLinks
  static final String bioLinks = '/idol/links';
  // 添加BioLinks
  static final String addBioLinks = '/idol/add_links';
  // 删除BioLinks
  static final String deleteBioLinks = '/idol/delete_links';
  // 编辑BioLinks
  static final String editBioLinks = '/idol/edit_links';
  // 更新userName
  static final String updateUserInfo = '/idol/edit_info';
  // 更新配置
  static final String updateGlobalConfig = '/idol/pub/config';
}
