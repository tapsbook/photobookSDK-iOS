# 订单提交和支付

在您完成订单编辑之后，Tapsbook （cleen）平台支持三种订单提交的支付系统的整合方式

  - 全部使用Tapsbook：使用Tapsbook自带的订单提交UI并整合Tapsbook电商后台和Tapsbook生产供应商
  - 混合Tapsbook和App自己的电商后台：使用App提供的的订单提交UI和自己的电商后台，然后整合Tapsbook生产供应商
  - 全部后台由App自己提供：使用App提供的的订单提交UI和自己的电商后，及App自己的生产供应商

第一种方式是由Tapsbook负责收银，然后扣除生产成本后转给App方。其优点是实现成本低，App不需要定制电商功能的后台服务，直接使用Tapsbook后台提供的电商功能， 包括产品定价，优惠策略，订单通知等等，其缺点是实现灵活性较差，适用于App里没有其它支付体验的应用。

第二种方式是由App负责收银，然后将生产成本转给Tapsbook。其优点是App可以接入App后台已有的电商体系，可以与其他电商产品自由形成产品体系，灵活控制优惠策略和支付提交体验，但是缺点是需要实现的工作较多，适用于App里已有其它支付体验的应用。

第三种方式只提供给生产企业，目前需要额外的软件授权。所以本文主要介绍前两种方法。

### 生产准备
 - App服务商需要完成与我们的生产协议合同
 - App服务商已完成所选产品的测试，确认产品实物和生产流程满足其需求

## 全部使用Tapsbook电商后台

在这种模式下，整个系统的交互周期如下所示。

![life_cycle](http://7xsnph.com1.z0.glb.clouddn.com/checkout-option1.png)

1. app 提供用户产品选择界面，依据用户的选择，从生产服务器获得当前所选产品（sku）数据和模版
2. SDK 导入产品模版，提供面向用户的内容编辑工具
3. 用户提交作品
4. SDK 导入支付页面获取用户地址和支付信息，将之传到SDK电商后台并调用支付宝或微信支付工具完成支付，此时的支付会到拾忆科技的支付账户
5. 当App或其后台确认订单支付完成后，SDK负责生成可供生产的JPG并上传至Tapsbook服务器完成提交

为了使用这种支付整合方式，

-  将`kTBCheckoutCustomization`下面所有选项都被设为NO，或者确认移除下面所有选项。
-  设定SDK后台服务器所在的国家，如果服务于中国地区用户，请务必选用`TBSDKRegion_China`，否则支付选项将无法使用支付宝

````
     kTBSupportedRegions : @[   
          @(TBSDKRegion_China),
     ],
````
-  在产品后台里，点击定制产品 => ”加入产品“ 即可选择SDK中需要提供给用户的产品。在选中的产品里可以设定产品的价格和运费，这些价格会被SDK的支付界面所使用到。

设定完成后，整个系统即可以进行调试了。

## 混合Tapsbook生产后台和App自己的电商后台

在这种模式下，整个系统的交互周期如下所示。

![life_cycle](http://7xsnph.com1.z0.glb.clouddn.com/checkout-option2-cn.png)

1. app 提供用户产品选择界面，依据用户的选择，从生产服务器获得当前所选产品（sku）数据和模版
2. SDK 导入产品模版，提供面向用户的内容编辑工具
3. 订单预提交，此时用户将产品加至购物车，此时SDK负责生成可供生产的JPG并上传至Tapsbook服务器，完成后返回一个未支付的订单号
4. App提供页面获取用户地址和支付信息，将之传到App自己的服务器并调用第三方支付工具完成支付
5. 当App或其后台确认订单支付完成后，提交订单确认API告诉Tapsbook生产后台此订单已经可以生产。未被确认的预提交订单将会在3天后被取消。

这里的第1-2步在此前的SDK整合的基础篇已经涵盖。这里主要阐述第3-5步。

第三步： 生成可供生产的JPG并上传至Tapsbook服务器，完成后会通过回调自动执行第四步，这个回调会包含一个可被支付的订单号

1. 首先修改SDKConfigurator

		kTBCheckoutCustomization : @{                
		        kTBUseExternalCheckout : @YES
		};
		
2. 当使用上面的开关后，当用户点击下订单时，SDK即可生成每一页的JPG并上传至Tapsbook服务器，此时SDK会弹出如下的上传界面，完成上传后返回一个未支付的订单号。

![life_cycle](http://7xsnph.com1.z0.glb.clouddn.com/tapsbook-upload.png)

第四步：使用App页面获取用户地址和支付信息，利用App或其服务器调用第三方支付工具完成支付

实现 `TBSDKAlbumManager` 代理方法来调用您自己的订单提交页面。

		- (void)albumManager:(TBSDKAlbumManager *)albumManager checkoutSDKAlbum:(TBSDKAlbum *)sdkAlbum withOrderNumber:(NSString *)orderNumber viewControllerToPresentOn:(UIViewController *)viewController {

    		//show your checkout view now
    		
		CheckoutViewController *vc = [CheckoutViewController new];
		vc.orderNumber = orderNumber; //please save the orderNumber and pass it for the step 5 processing
	    	[viewController presentViewController:vc animated:YES completion:nil];
		}
	
 - `CheckoutViewController`, 是你的app的订单提交界面 这个订单界面需要整合第三方支付平台工具，比如微信或支付宝，导引用户最终完成订单的支付. 当用户完成支付后，即可完成app下单用户界面层的工作。
 - `orderNumber`, 这是第三步完成后Tapsbook后台服务器上保存的未支付订单信息。当用户在app中完成支付后，你需要发送一个关联到这个订单的确认API
	
第五步：当App或其后台确认订单支付完成后，需要提交订单确认API告诉Tapsbook生产后台此订单已经确认，并且提供追加信息（包含客户地址）。 tapsbook后台获得这个信息后，将会从您在我们的后台财务账户上扣款后，即可组织生产。

这个API的格式为 POST 

API 测试服务器 http://search.tapsbook.com/api/v1/orders

API 生产服务器 https://dashboard.shiyi.co/api/v1/orders

如下所示API需要包含的JSON数据范本，注意到这里的必须替换的三个变量

- `YOUR_ORDER_NUMBER`必须与上面的第三步获得订单号匹配。
- `YOUR_APP_KEY`必须使用这个应用所对应的APP_key。
- 'address' 里包含的客户收件地址信息，保留缺省值state_id=0，country_id=48, 不需替换

注意`order_type` 和 ｀payment_method` 保留缺省值 'confirm'，'MERCHANT_ACCOUNT' 不需替换

````
{
  "api_key": "YOUR_APP_KEY",
  "order_number": "YOUR_ORDER_NUMBER",
  "order_type": "CONFIRM",
  "payment_method" : "MERCHANT_ACCOUNT",
  "customer": {
    "address": {
      "phone": "寄送联系电话",
      "state": "寄送省",
      "city": "寄送城市",
      "address1": "地址第一行",
      "address2": "地址第一行",
      "zipcode": "邮编",
      "firstname": "",
      "lastname": "客户名字",
      "email": "客户邮件",
      "state_id": "0",
      "country_id": "48"
    }
  }
}

````
### 订单生产后的通知

当订单生产完成后，生产厂家将会录入快递的快递单号。当Tapsbook 后台获得这个快运单号后，可以以邮件或短信的方式将快递单号发送通知给用户。

