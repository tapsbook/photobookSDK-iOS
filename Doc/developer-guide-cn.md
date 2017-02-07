## 概述

The Tapsbook (Cleen) iOS SDK 通过整合了部署于全球的生产制造能力和强大的SaaS订单管理平台，为移动应用开发者提供了一套快速实现包括照片书，月历，手机壳在内的的照片打印产品定制和购买的解决方案。其主要功能包括

1. 通过分析照片数据，利用模版实现的的照片书内容快速生成
2. 功能强大的包括可变的布局，背景，文字修改在内的简单易用页面编辑
3. 利用手机本机输出节省流量的打印版内容输出，直接整合至后台生产

## 项目设置

### 运行要求

iOS 8.0 or higher

### 安装

导入Tapsbook pod, 然后执行  'Pod install' 会自动下载Tapsbook SDK及所需的其它软件库

		pod 'Tapsbook'

	
## TapsbookSDK 数据结构

* 相册和 TBSDKAlbum:

	 使用了SDK后，你的app需要提供照片给TapsbookSDK. TBSDKAlbum 是体现相册的基类. 你需要使用SDK提供的方法来创建新的TBSDKAlbum，创建后你可以利用SDK的API来对它进行增删改查的操作。

* 页面:

	一个相册中会含有多个页面, 页面会使用内置的的模版数据来确定页面内照片和文字的布局。你的app运行中不需要直接对页面进行操作，所以没有对应页面的基类。

	
* Standard Page （基本页）和 Spread Page （跨页）

	 跨页 spread page 是用户界面上显示的左右两个基本页的集合.

* 图片和 TBImage:

	页面中会放置多张照片. TBImage 是体现照片的基类。你的app需要建立新的TBImage对象来封装需要SDK处理的照片，下面会有详细的使用介绍。

	
## TapsbookSDK 使用流程

![GenreralMechanism](http://7xsnph.com1.z0.glb.clouddn.com/sdk-guide-overview.png)

* 你的app传入一组照片到TapsbookSDK, TapsbookSDK 会自动导入制定模版，生成相册并保存相册。

* 考虑到不同应用使用不同的照片存储方法和照片权限管理，TapsbookSDK依赖于应用去下载照片 TapsbookSDK只会保存少量的TBImage的元数据，而不会保存照片文件本身。

* 使用SDK内置的提交用户界面，或者使用app本身的提交界面完成订单的生成。SDK会负责生成打印商所需要的所有打印原材料，并传输相关数据到SaaS管理后台准备和生产供应商对接。

* 如果你的App需要实现已有照片书列表，SDK提供了本地的API可以列举已经生成好的TBAlbum。

## TBImage 使用

* TapsbookSDK 需要使用本地缓存后的照片以保证页面的流畅和快速的浏览体验。SDK使用自建的TBImage对象来封装照片的元数据，以便于照片书内容的自动生成。 TBImage提供了datasource方法可以支持lazy load来减少移动端对流量的使用。
	
* TBImage需要app提前预生成每一张照片的多个尺寸的文件。显示尺寸 (`TBImageSize_l`) 800px会被用于页面编辑, 缩略图尺寸 (`TBImageSize_s`) 会被用于照片选取工具条. 原始图片尺寸 (`TBImageSize_xxl`) 会被用于打印

* 通常的使用场景是用户通过照片选择UI先挑选照片，然后将这些照片做成照片书。如果app里用户所选的的照片来自于云端，你需要提前下载照片到app的一个缓存目录下面，并生成不同大小的版本， 然后将缓存下的照片路径保存到TBImage(使用`setImagePath:size:`).SDK将会依据TBImage里保存的路径来读取照片。
	
	提示：由于照片会非常消耗内存，我们不建议直接在app里用UIImage导入照片后直接传给SDK。
	
* 最后提交打印前，SDK需要依据页面布局中的照片大小来检查图片是否有足够的清晰度。 所以你需要获取照片原图的尺寸，然后利用 `setXxlSizeInPixel:` 方法设置`TBImage` 的像素大小. 如果清晰度不足时，SDK UI 会显示‘像素不足’的提示信息.

	提示：建议你在初始化TBImage时就设置`xxlSizeInPixel`，如果你没有设置这个尺寸，像素检查就不会被执行，这样会导致照片的模糊会进而影响用户对产品的满意度。

* 建议照片的下载和TBImage初始化

	1. **方法1**: 提前下载所有尺寸图片，或者只下载大尺寸然后手动生成小图.
		
		* 如果用户可以等待，最简单的实现方法是等待所有照片都已经下载完后再进入SDK编辑界面。

		* 如果希望减少等待时间，你也可以只下载缩略图和显示尺寸大小的照片，只有在用户最后确定下单时再下载照片原图。这种情况下，需要实现 TBImage delegate 方法来下载大图。 （详情见下面）

	2. **方法2**: Lazy load 只在显示页面时动态下载图片.

		* 尽管这个方法可以减少用户等待时间，这种实现方法需要较复杂的实现环节来实现完美的用户体验，总体工作量会较大，例如你可能需要使用iOS异步多线程Operations管理方法。 当TapsbookSDK需要某一张图片时，app需要实现dataSource delegate method(`tbimageRequestImage:size:priority:`). 下载完成后，调用再调用 `gotImageWithSize:`来告诉SDK下载完成.

		* 当TapsbookSDK调用dataSource方法下载照片时, SDK会依据用户的使用操作的页面来改变异步线程管理所需要的的照片下载优先级信息，这样做的目的是保证用户当前页面的照片会优先被加载。

		* 为了优化体验，TapsbookSDK提供了预加载方法。它会改变下载请求的优先级(`tbimage:size:priorityOfRequestChangeFrom:to:`). 甚至取消某个照片下载请求 (`tbimageCancelImageRequest:size:`)

		* 如果一张页面上有很多照片，这些照片会被同时被请求下载，同时下载多个文件会导致大量的内存占用，建议你创建一个下载队列最多同时不超过3个下载。

* 下载的照片会占用手机空间，过多的手机空间占用会导致用户删除应用，建议使用高效的缓存管理来适时的清理内存，或者程序内设置清理内存选项来清理下载照片的缓存空间。

## SDK 使用教程

### 普通流程

1. 配置SDKConfigurator
	1. 复制SDK缺省设置到一个新的TBSDKConfigurator.m。填入kTBAppKey。除此之外建议初次开发者保留缺省设置
		
	2. 在`AppDelegate.m`中使用这个设置 `application:didFinishLaunchingWithOptions:`:
			
			[TBSDKConfiguration initializeWithConfiguratorClassName:@"EGTBSDKConfiguritor"];
			
	3. 注册如下系统通知以便让SDK给用户发出通知。由于图片上传会需要1-2分钟等待时间，用户如果退出应用，SDK会发出通知提醒用户。
	
			UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    		[[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
		
2. 设定 `TBSDKAlbumManager` 的代理和datasource

		[TBSDKAlbumManager sharedInstance].imageDataSource = self;
		[TBSDKAlbumManager sharedInstance].delegate = self;

3. 如果你希望让用户手动选择照片，你需要实现或使用第三方的photo picker供用户选择照片，然后将用户所选的照片现有照片打包为 `TBImage`:
	
		TBImage *tbImage = [[TBImage alloc] initWithIdentifier:identifier];
		
	下载图片后，将在应用内能直接访问的照片路径设置好:
		
		[tbImage setImagePath:path size:size];
		
	设置打印照片原图尺寸:
		
		[tbImage setXxlSizeInPixel:xxlSize];
			
3. 用这些所选的图片创建新的照片产品:
	
		[[TBSDKAlbumManager sharedInstance] createSDKAlbumWithImages:images identifier:identifier title:title tag:tag completionBlock:^(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error) {
	        if (success) {
	            // Handle success
	        }
	        else {
	            // Handle error
	        }
    	}];

	here:
	* `images` can be nil, or an arry of `TBImage`.
	* `identifier` can be nil or an uniq string to help you recognize your album
	* `tag` is another property to help you recognize your album, pass `0` if you don't need that value 
	
	注意这是唯一可以创建TBSDKAlbum的方法，一旦创建好之后，SDK提供API供App查询已有的照片产品。
		
4. 也可以将这些照片加入一个已有的TBSDKAlbum中
		
		[[TBSDKAlbumManager sharedInstance] addImages:images toSDKAlbum:album completionBlock:nil];
		
	TaspbookSDK  会自动依据照片 `identifier`来判定照片是否以前已经被使用过。

5. 打开`TBSDKAlbum`进行编辑或打印
	
		BOOL success = [[TBSDKAlbumManager sharedInstance] openSDKAlbum:album presentOnViewController:viewController shouldPrintDirectly:shouldPrintDirectly];
		
	这里需要你的 `navigationController` 必须是一个全屏的`UINavigationController`. TapsbookSDK ViewController将会被推至这个 navigationController.
	
6. 如果你还有一个用户创作的SDKAlbum列表，你需要在用户编辑完之后利用TBSDKAlbum的数据更新产品的状态 （比如封面等）。如果你不需要次列表，可以跳过本节
	
		- (void)albumManager:(TBSDKAlbumManager *)albumManager didFinishEditingSDKAlbum:(TBSDKAlbum *)sdkAlbum {
		}
	
6. 如果一开始没有下载照片的原图照片，SDK会在用户提交打印时弹出一个进度条高速用户app正在下载原图。app需要实现如下原图的代理下载方法

		- (void)albumManager:(TBSDKAlbumManager *)albumManager
		preloadXXLSizeImages:(NSArray *)tbImages
          		  ofSDKAlbum:(TBSDKAlbum *)sdkAlbum
          	   progressBlock:(void (^)(NSInteger currentIdx, NSInteger total, float currentProgress))progressBlock
          	 completionBlock:(void (^)(NSInteger successCount, NSInteger total, NSError *error))completionBlock {
		}		

	如果需要给用户选项取消下载，实现如下代理方法

		- (void)albumManager:(TBSDKAlbumManager *)albumManager cancelPreloadingXXLSizeImages:(NSArray *)tbImages ofSDKAlbum:(TBSDKAlbum *)sdkAlbum {
		    
		}
		
	如果一开始不知道照片原图的大小，而在后来才下载。这时需要设置 `xxlSizeInPixel` 

		- (void)tbimageRequestImage:(TBImage *)tbimage size:(TBImageSize)size priority:(TBPriority)priority {
		
			[SomeImageDownloadingQueue downloadImage:tbImage size:size priority:priority completion:^{
				[tbImage setXxlSizeInPixel:xxlSize];
				[tbImage gotImageWithSize:size];
			}];
		}
	


		
7. 如果照片初始化时采用了Lazy load 只在显示页面时动态下载图片，需要实现如下 TBImageDataSource methods
	
		- (void)tbimageRequestImage:(TBImage *)tbimage size:(TBImageSize)size priority:(TBPriority)priority {
		
			[SomeImageDownloadingQueue downloadImage:tbImage size:size priority:priority completion:^{
				[tbImage gotImageWithSize:size];
			}];
		}
		
		- (void)tbimageCancelImageRequest:(TBImage *)tbimage size:(TBImageSize)size {
			// Cancel a image downloading operation
		}
	
		- (void)tbimage:(TBImage *)tbImage size:(TBImageSize)size priorityOfRequestChangeFrom:(TBPriority)oldPriority to:(TBPriority)newPriority {
			// handle priority change of image request
		}
		
		- (BOOL)tbImage:(TBImage *)tbImage isPathInvalid:(NSString *)path ofSize:(TBImageSize)size {
			if (NOT_VALID) {
				return YES;
			}
		
		    return NO;
		}
		
8. 支持让用户在以前做好的产品中加入更多照片

	在TapsbookSDK编辑页面中，如果需要支持加入新照片，你需要实现以下代理方法弹出app自己提供的的照片选取界面。
	
		- (UIViewController *)photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager withSDKAlbum:(TBSDKAlbum *)sdkAlbum existingTBImages:(NSArray *)existingTBImages completionBlock:(void (^)(NSArray *newImages))completionBlock 
		
	注意这个界面中你需要标注出用户此前就被选中那些照片，existingTBImages 是一个TBImages数组，当用户结束选择后，你需要重复上面的TBImage初始化的过程。
		

	
### 关于订单提交和支付，详情参见关于它的专文

### 手动配置Tapsbook SDK到客户app
1. 复制 SDK 文件
	
	复制 `TapsbookSDK.framework` and `TapsbookSDK.bundle` 到你的项目中.
	
	![FinderImageForSDK](http://7xsnph.com1.z0.glb.clouddn.com/sdk-guide-copyfilesforsdk.png)
	
2. 连接苹果官方 libiraries
	
	检查Xcode里项目的 "build phase" => "Link Binary With Libraries"  点选以下框架
	
		TapsbookSDK.framework
		libsqlite3.0.dylib
		libz.dylib
		UIKit.framework
		Accelerate.framework
		AdSupport.framework
		CoreData.framework
		SystemConfiguration.framework
		ImageIO.framework
		MessageUI.framework
		Social.framework
		Photos.framework
	
3. 启用SDK资源包
	
	检查Xcode里项目的 "build phase" => "Copy Bundle Resources", 在项目中加入 `TapsbookSDK.bundle` 
	
	![XcodeImageForCopyBundleResources](http://7xsnph.com1.z0.glb.clouddn.com/sdk-guide-copybundle.png)
	
4. 加 `-ObjC` 到 "Build Settings" > "Other Linker Flags"

5. 导入第三方软件库

	TapsbookSDK需要如下的第三方开源软件。建议你使用CocoaPods来管理这些依赖软件库，这样的话，只需加入如下列表到Podfile， 然后执行  'Pod install' 开始下载这些软件库
	
		pod 'AGGeometryKit', '~> 1.2'
		pod 'SDWebImage', '~> 3.7'
		pod 'SlackTextViewController', '~> 1.7'
		pod 'FXLabel', '~> 1.5'
		pod 'FastImageCache', '~> 1.3'
		pod 'SCLAlertView-Objective-C', '~> 0.7'
		pod 'FormatterKit', '~> 1.8'
		pod 'Stripe', '~> 6.0'
		pod 'AsyncDisplayKit', '~> 1.9.92'
		pod 'smc-runtime', '~> 6.3'
		pod 'AHEasing', '~> 1.2'
		pod 'TLLayoutTransitioning', '~> 1.0'
		pod 'CocoaLumberjack', '~> 2.2'
		pod 'pop', '~> 1.0'
		pod 'DZNSegmentedControl', '~> 1.3'
		pod 'KVOController', '~> 1.0'
		pod 'Reachability', '~> 3.2'
		pod 'BlocksKit', '~> 2.2'
		pod 'TTTAttributedLabel', '~> 1.13'
		pod 'FXBlurView', '~> 1.6'
		pod "AFNetworking", "~> 2.0"
		pod 'Qiniu', '~> 7.0'
		pod 'MZFormSheetController', '~> 3.1'
		pod 'MZFormSheetPresentationController', '~> 2.1'
		pod 'FMDB', '~> 2.5'
		pod 'MBProgressHUD', '~> 0.9'
		pod 'TTTRandomizedEnumerator', '~> 0.0'
		pod 'libextobjc', '~>0.4.1'
		pod 'AFAmazonS3Manager', '~> 3.2'
		pod 'Masonry', '~> 0.6'
		pod 'UICKeyChainStore', '~> 2.1'
		pod 'FBSDKCoreKit'
		pod 'FBSDKLoginKit'
		pod 'FBSDKShareKit'
		pod 'LMDropdownView'
		pod 'leveldb'
		pod 'objective-zip'
		pod 'ShareSDK3'
		pod 'MOBFoundation'
	
	一般来说，使用更新版的这些第三方库不会导致任何编译问题，但是万一您在试用中有任何冲突，请联系我们。


