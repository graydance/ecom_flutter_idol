// 引入 eventBus 包文件
import 'package:event_bus/event_bus.dart';
import 'package:idol/event/supply_refresh.dart';

// 创建EventBus
EventBus eventBus = EventBus();

// event 监听
class SupplyRefresh {
  // 想要接收的数据时什么类型的，就定义相同类型的变量
  SupplyRefreshEvent supplyRefresh;
  SupplyRefresh(this.supplyRefresh);
}

class MyShopRefresh {}
