# 订单提交和支付

在您完成订单编辑之后，Tapsbook （cleen）平台支持三种订单提交的支付系统的整合方式

  - 全部使用Tapsbook：使用Tapsbook自带的订单提交UI并整合Tapsbook电商后台和Tapsbook生产供应商
  - 混合Tapsbook和App自己的电商后台：使用App提供的的订单提交UI和自己的电商后台，然后整合Tapsbook生产供应商
  - 全部后台由App自己提供：使用App提供的的订单提交UI和自己的电商后，及App自己的生产供应商

第一种方式是由Tapsbook负责收银，然后扣除生产成本后转给App方。其优点是实现成本低，缺点是实现灵活性较差，适用于App里没有其它支付体验的应用。

第二种方式是由App负责收银，然后将生产成本转给Tapsbook。其优点是App可以灵活控制支付提交体验，但是需要实现的工作较多，适用于App里已有其它支付体验的应用。

第三种方式只提供给生产企业，目前需要额外的软件授权。所以本文主要介绍前两种方法。

### 生产准备
 - App服务商需要完成与我们的生产协议合同
 - App服务商财务账号余额至少有500元
 - App服务商已完成所选产品的测试，确认产品实物和生产流程满足其需求

### 混合Tapsbook生产后台和App自己的电商后台


在这种模式下，整个系统的交互周期如下所示。

![life_cycle](http://7xsnph.com1.z0.glb.clouddn.com/checkout-option2-cn.png)

1. app 提供用户产品选择界面，依据用户的选择，从生产服务器获得当前所选产品（sku）数据和模版
2. SDK 导入产品模版，提供面向用户的内容编辑工具
3. 订单预提交，此时用户将产品加至购物车，此时SDK负责生成可供生产的JPG并上传至Tapsbook服务器，完成后返回一个未支付的订单号
4. App提供页面获取用户地址和支付信息，将之传到App自己的服务器并调用第三方支付工具完成支付
5. 当App或其后台确认订单支付完成后，提交订单确认API告诉Tapsbook生产后台此订单已经可以生产。
6. 未被确认的预提交订单将会在3天后被取消。

这里的第1-2步在此前的SDK整合的基础篇已经涵盖。这里主要阐述第3-5步。