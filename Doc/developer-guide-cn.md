## 概述

The Tapsbook (Cleen) iOS SDK 通过整合了后端的SaaS管理平台，为移动应用开发者提供了一套快速实现的照片打印产品定制和购买的解决方案。其主要功能包括

1. 通过分析照片数据，利用模版数据实现的的照片书内容快速生成
2. 功能强大的包括可变的布局，背景，文字修改在内的简单易用页面编辑
3. 利用手机本机输出节省流量的打印版内容输出，直接整合至后台生产

## 项目设置

### 运行要求

iOS 8.0 or higher

### 安装

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
	
	提示：由于照片会非常消耗内存，我们建议你除非必要，不要直接在app里用UIImage导入照片。
	
* 最后提交打印前，SDK需要依据页面布局中的照片大小来检查图片是否有足够的清晰度。 所以你需要获取照片原图的尺寸，然后利用 `setXxlSizeInPixel:` 方法设置`TBImage` 的像素大小. 如果清晰度不足时，SDK UI 会显示‘像素不足’的提示信息.

	提示：建议你在初始化TBImage时就设置`xxlSizeInPixel`，如果你没有设置这个尺寸，像素检查就不会被执行，这样会导致照片的模糊会影响用户的满意度。

* 建议照片的下载和TBImage初始化

	1. **方法1**: 提前下载所有尺寸图片，或者只下载大尺寸然后手动生成小图.
		
		* 如果用户可以等待，最简单的实现方法是等待所有照片都已经下载完后再进入SDK编辑界面。

		* 如果希望减少等待时间，你也可以只下载缩略图和显示尺寸大小的照片，只有在用户最后确定下单时再下载照片原图。这种情况下，需要实现 TBImage delegate 方法来下载大图。 （详情见下面）

	2. **Method 2**: Lazy load 只在显示页面时动态下载图片.

		* 尽管这个方法可以减少用户等待时间，这种实现方法需要较复杂的实现环节来实现完美的用户体验，总体工作量会较大，例如你可能需要使用iOS异步多线程Operations管理方法。 当TapsbookSDK需要某一张图片时，app需要实现dataSource delegate method(`tbimageRequestImage:size:priority:`). 下载完成后，调用再调用 `gotImageWithSize:`来告诉SDK下载完成.

		* 当TapsbookSDK调用dataSource方法下载照片时, SDK会依据用户的使用操作的页面来改变异步线程管理所需要的的照片下载优先级信息，这样做的目的是保证用户当前页面的照片会优先被加载。

		* 为了优化体验，TapsbookSDK提供了预加载方法。它会改变下载请求的优先级(`tbimage:size:priorityOfRequestChangeFrom:to:`). 甚至取消某个照片下载请求 (`tbimageCancelImageRequest:size:`)

		* 如果一张页面上有很多照片，这些照片会被同时被请求下载，同时下载多个文件会导致大量的内存占用，建议你创建一个下载队列最多同时不超过3个下载。

* 下载的照片会占用手机空间，过多的手机空间占用会导致用户删除应用，建议使用高效的缓存管理来适时的清理内存，或者程序内设置清理内存选项来清理下载照片的缓存空间。

## SDK 使用教程

### 普通流程

1. 调整SDK设置。建议第一次开发者跳过这一步，除了AppKey之外，保留缺省设置可以满足绝大多数初次开发的需求。
	
	1. 采用 `TBSDKConfiguratorProtocol`创建一个新的Configurator, implement the protocol methods that you want to have a different behavior, here's a sample implementation:
	
			- (NSDictionary *)basicSettings {
			    NSDictionary *basicSettings = @{
			                                     kTBSDKBasics : @{
			                                             kTBAppName : [NSNull null],                      // (Required) Your app name, this name will show up in app UI messages
			                                             kTBAppKey : [NSNull null],                       // (Required)
			                                             kTBAppSecret : [NSNull null],                    // (Required)
			                                             
			                                             kTBSupportedRegions : @[             // (Optional) TBSDKRegions, customize the SDK to support multiple ship to regions (countries)
			                                                     // TBSDKRegions
			                                                     @(TBSDKRegion_UnitedStates)
			                                                     ],
			                                             
			                                             kTBMerchantKeys : @{                 // (Required) Your app keys that you setup from http://dashboard.tapsbook.com, Append a string prefix "test_[ACTUAL_KEY]" will connect to the test server
			                                                     // Region : merchantKey
			                                                     kTBMerchantKeyDefault : [NSNull null],   // (Optional) The default key
			                                                     },
			                                             kTBStripeKeys : @{                   // (Required) Stripe uses this key to create a charge token to make the charge on the tapsbook eCommerce server.
			                                                     // Region : stripeKey
			                                                     kTBStripeKeyDefault : [NSNull null],     // (Optional) The default key
			                                                     },
			                                             },
			                                     
			                                     kTBAppLogoPaths : @{                         // (Optional) Your app logo that will be printed on the back cover, assuming the back cover has a design include the app logo
			                                             kTBImageSizeS : [NSNull null],
			                                             kTBImageSizeL : [NSNull null],
			                                             kTBImageSizeXXL : [NSNull null],
			                                             },
			                                     
			                                     kTBAWSS3 : @{
			                                             kTBAWSS3AppKey : [NSNull null],                  // (Optional) Your AWS s3 cloud storage account, SDK will upload the rendered images to the AWS s3 location, you may need to set your own clean up policy to remove these images routinely
			                                             kTBAWSS3AppSecret : [NSNull null],               // (Optional) Your AWS s3 cloud storage account secret
			                                             kTBAWSS3BucketName : [NSNull null],              // (Optional) AWS uses bucket name to organize your uploaded images, your images will be uploaded to this URL pattern
			                                             },
			                                     
			                                     kTBBookGeneration : @{                       // (Optional)
			                                             kTBTemplateDatabaseName : @"TBTemplate_Test_01.sqlite", // (Optional) The name of the template database
			                                             kTBDefaultThemeID : @{
			                                                     @(TBProductType_Photobook) : @1,
			                                                     
			                                                     },
			                                             kTBUseSameBackgroundImageOnTheSameSpread : @{    // (Optional) Retrun YES is you want SDK's page generation use the same background image on the same spread
			                                                     @(TBProductType_Photobook) : @NO,
			                                                     @(TBProductType_Canvas) : @NO,
			                                                     @(TBProductType_Calendar) : @NO,
			                                                     @(TBProductType_Card) : @NO,
			                                                     },
			                                             kTBMaxNumberofImagesPerPage : @{                 // (Optional)
			                                                     @(TBProductType_Photobook) : @4,
			                                                     @(TBProductType_Canvas) : @4,
			                                                     @(TBProductType_Calendar) : @4,
			                                                     @(TBProductType_Card) : @4,
			                                                     },
			                                             kTBMinNumberofImagesPerPage : @{                 // (Optional)
			                                                     @(TBProductType_Photobook) : @1,
			                                                     @(TBProductType_Canvas) : @1,
			                                                     @(TBProductType_Calendar) : @1,
			                                                     @(TBProductType_Card) : @1,
			                                                     },
			                                             kTBMaxNumberofImagesPerSpread : @{               // (Optional)
			                                                     @(TBProductType_Photobook) : @4,
			                                                     @(TBProductType_Canvas) : @4,
			                                                     @(TBProductType_Calendar) : @4,
			                                                     @(TBProductType_Card) : @4,
			                                                     },
			                                             kTBMinNumberofImagesPerSpread : @{               // (Optional)
			                                                     @(TBProductType_Photobook) : @2,
			                                                     @(TBProductType_Canvas) : @1,
			                                                     @(TBProductType_Calendar) : @1,
			                                                     @(TBProductType_Card) : @1,
			                                                     },
			                                             kTBAllowAddOrRemovePage : @{                     // (Optional)
			                                                     @(TBProductType_Photobook) : @YES,
			                                                     @(TBProductType_Canvas) : @NO,
			                                                     @(TBProductType_Calendar) : @NO,
			                                                     @(TBProductType_Card) : @NO,
			                                                     },
			                                             },
			                                     
			                                     kTBBehaviorCustomization : @{
			                                             kTBRemindUserToOrderWhenClosingBooks : @NO,      // (Optional) Whether to remind a user they will lose their work in progress if they close.
			                                             kTBEnableAddingText : @NO,                       // (Optional)
			                                             kTBShowOptionsOfBuildingPagesManuallyOrAutomatically : @{  // (Optional)
			                                                     @(TBProductType_Photobook) : @NO,
			                                                     @(TBProductType_Canvas) : @NO,
			                                                     @(TBProductType_Calendar) : @NO,
			                                                     @(TBProductType_Card) : @NO,
			                                                     },
			                                             kTBUseEmptyTemplateForPageWithNoContent : @NO,   // (Optional)
			                                             kTBLoadProductFromServerWhenPreparingLocalAlbum : @YES,    // (Optional) load prodcut from server, currently should be always be YES
			                                             },
			                                     
			                                     kTBCheckoutCustomization : @{                    // (Optional)
			                                             kTBNoCover : @{                                  // (Optional) YES if you don't need a cover or the cover is not customizable
			                                                     @(TBProductType_Photobook) : @NO,
			                                                     @(TBProductType_Canvas) : @YES,
			                                                     @(TBProductType_Calendar) : @YES,
			                                                     @(TBProductType_Card) : @YES,
			                                                     },
			                                             kTBSendAlbumJSONDictToHostingApp : @NO,  // (Optional) YES when you want to generate page image on your own.
			                                             kTBGeneratePageImagesInDebugMode : @NO,  // (Optional) Helps you debug when kTBSendAlbumJSONDictToHostingApp is YES
			                                             kTBSendOrderInfoToHostingApp     : @NO,  // (Optional) YES when you want to use your checkout method
			                                             },
			                                     };
			    
			    return basicSettings;
			}
		
	2. 在`AppDelegate.m`中使用这个设置 `application:didFinishLaunchingWithOptions:`:
	
			// In your appDelegate.m
			
			[TBSDKConfiguration initializeWithConfiguratorClassName:@"EGTBSDKConfiguritor"];
			
	3. Register notification types, TaspbookSDK may send local notifications to tell users keep the application activate while uploading.
	
			UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    		[[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
		
2. Setup `TBSDKAlbumManager` before creating/accessing a album.

		[TBSDKAlbumManager sharedInstance].imageDataSource = self;
		[TBSDKAlbumManager sharedInstance].delegate = self;

3. Create some `TBImage`:
	
		TBImage *tbImage = [[TBImage alloc] initWithIdentifier:identifier];
		
	If the image is already avaliable in file system:
		
		[tbImage setImagePath:path size:size];
		
	If you've got the size of the printing-size image:
		
		[tbImage setXxlSizeInPixel:xxlSize];
			
3. Create new `TBSDKAlbum` with images:
	
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
	
	You should not create TBSDKAlbum yourself, only TBSDKAlbum instance returned from TapsbookSDK can work properly.
		
4. Add images to `TBSDKAlbum`
		
		[[TBSDKAlbumManager sharedInstance] addImages:images toSDKAlbum:album completionBlock:nil];

	here `images` is an arry of `TBImage`.
	
	TaspbookSDK will recognize duplicate images by the `identifier`

5. Open or print a `TBSDKAlbum`
	
		BOOL success = [[TBSDKAlbumManager sharedInstance] openSDKAlbum:album presentOnViewController:viewController shouldPrintDirectly:shouldPrintDirectly];
		
	The `navigationController` you passed to TapsbookSDK should be a full screen `UINavigationController`. ViewController of TapsbookSDK will be pushed on this navigationController.
	
6. Update your sdkAlbum list view/table view/collection view (optional)

* A callback when user finish editing a sdkAlbum, and press the back button to get back to your viewController from SDK's viewController. You can refresh a specific tableView/collectionView cell because some properties of the sdkAlbum might be modified.
	
		- (void)albumManager:(TBSDKAlbumManager *)albumManager didFinishEditingSDKAlbum:(TBSDKAlbum *)sdkAlbum {
		
		}
	
6. Implement xxl size image preloading methods, (This is necessary if you choose to use **Method 1.5**)

		- (void)albumManager:(TBSDKAlbumManager *)albumManager
		preloadXXLSizeImages:(NSArray *)tbImages
          		  ofSDKAlbum:(TBSDKAlbum *)sdkAlbum
          	   progressBlock:(void (^)(NSInteger currentIdx, NSInteger total, float currentProgress))progressBlock
          	 completionBlock:(void (^)(NSInteger successCount, NSInteger total, NSError *error))completionBlock {
		    
		    // Create some download tasks to download all the xxl-size images
		    // Set the path of xxl-size and xxlSizeInPixel to the TBImage instance 
		    // If you can get the downloading progresses, pass the progress to the progressBlock. 
		    // If you can't get the downloading progresses, just pass 1 to currentProgress when you've finished downloading a image.
		    // Call completionBlock when all the downloading tasks are finished.
		    // If some error happen and you cannot download all the images, call completionBlock with the success count and the error you want to show to your user.
		}		
		
		
		// Optional, sdk will also tell you to stop the downloading tasks if the user give up downloading.
		
		- (void)albumManager:(TBSDKAlbumManager *)albumManager cancelPreloadingXXLSizeImages:(NSArray *)tbImages ofSDKAlbum:(TBSDKAlbum *)sdkAlbum {
		    
		}
		
7. Implement TBImageDataSource methods, (This is necessary only if you choose to use **Method 2**)
	
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
		
		
### If you can't set `xxlSizeInPixel` at the beginning

1. set `xxlSizeInPixel` for a TBImage before you call `[TBImage gotImageWithSize:]` as shown below:

		- (void)tbimageRequestImage:(TBImage *)tbimage size:(TBImageSize)size priority:(TBPriority)priority {
		
			[SomeImageDownloadingQueue downloadImage:tbImage size:size priority:priority completion:^{
				[tbImage setXxlSizeInPixel:xxlSize];
				[tbImage gotImageWithSize:size];
			}];
		}
	
### Other TBSDKAlbum operations

1. To get all albums of a tag

		[[TBSDKAlbumManager sharedInstance] allSDKAlbumsOfTag:tag completionBlock:^(BOOL success, NSArray *sdkAlbums, NSError *error) {
	        if (success) {
	            // handle success
	        }
	        else {
	            // handle error
	        }
	    }];
	    
9. To rename a album
	
		[[TBSDKAlbumManager sharedInstance] renameSDKAlbum:album title:title];
	
10. To remove a album
		
		[[TBSDKAlbumManager sharedInstance] removeSDKAlbum:album];
		
		
## Usage (Extra)

1. Add images to a existing album while editing album in SDK

	In TapsbookSDK's Page editing view, there is a optional add photo button on the photo list view. When you implement the delegate method below, this button will show up.
	
		- (UIViewController *)photoSelectionViewControllerInstanceForAlbumManager:(TBSDKAlbumManager *)albumManager withSDKAlbum:(TBSDKAlbum *)sdkAlbum existingTBImages:(NSArray *)existingTBImages completionBlock:(void (^)(NSArray *newImages))completionBlock 
		
	Tapsbook will call this method to get a `UIViewController` and present it. The work flow of this view controller is designed by you. In general, you will provide some images to your user, mark existing images as selected and cannot be deselected(optional, SDK will ignore duplicated images automatically). Your user may choose some new images and tap a done button, then you should convert these new images to a array of `TBImage`s and call `completionBlock(newImages)` on main thread to pass new images to TapsbookSDK. After that, these new images can be added to the album book. 
	
## Usage (Checkout/Store)

1. Configuration; In your class that adopts `TBSDKConfiguratorProtocol`, in `basicSettings` method, set `kTBSendOrderInfoToHostingApp` `kTBSendAlbumJSONDictToHostingApp`: `@YES`:


		kTBCheckoutCustomization : @{                
		        kTBSendAlbumJSONDictToHostingApp : @YES,  // (Optional) YES when you want to generate page image on your own.
		        kTBGeneratePageImagesInDebugMode : @NO,  // (Optional) Helps you debug when kTBSendAlbumJSONDictToHostingApp is YES
		        kTBSendOrderInfoToHostingApp     : @YES,  // (Optional) YES when you want to use your checkout method
		        },
		};
		
2. Implement `TBSDKAlbumManager` delegate method:

		- (void)albumManager:(TBSDKAlbumManager *)albumManager printAndCheckoutSDKAlbum:(TBSDKAlbum *)sdkAlbum withInfoDict:(NSDictionary *)infoDict viewControllerToPresentOn:(UIViewController *)viewController {
		    CheckoutViewController *vc = [CheckoutViewController new];
		    vc.albumInfo = infoDict;
		    [viewController presentViewController:vc animated:YES completion:nil];
		}
	
	The `CheckoutViewController`, is a custom UIViewController where you can have your own checkout flow
	The `infoDict` contains album info



## DEPRECATED
	
7. Provide your product info (If you return YES in `useExternalPrintProductInfo`):

		- (void)albumManager:(TBSDKAlbumManager *)albumManager loadPrintInfosForSDKAlbum:(TBSDKAlbum *)sdkAlbum standardSize:(CGSize)size completionBlock:(void (^)(NSArray *printInfos))completionBlock {
		    
		    // 1. Load your print info asynchronously
		    // 2. Convert your product info to TBPrintInfo
		    // 3. Pass an array of TBPrintInfos to the completionBlock
		}
		
	Here, TBPrintInfo should have these value being set:
	
	* outputType
	* name
	* previewPath or previewURL
	* productID
	* price
	* stdPagePrintSize

7. Handle checkout (If you return YES in `userExternalCheckout`):

		- (void)albumManager:(TBSDKAlbumManager *)albumManager didCheckoutSDKAlbum:(TBSDKAlbum *)sdkAlbum withCheckoutInfo:(NSDictionary *)checkoutInfo {
		    [albumManager popAllTBSDKViewControllersAnimated:YES];
		    
		    NSInteger numberOfPages = [checkoutInfo[kTBSDKCheckoutInfoNumberOfPages] integerValue];
		    NSInteger productID = [checkoutInfo[kTBSDKCheckoutInfoProductID] integerValue]; // The product ID tells what kind of product it is.
		    
		    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		        for (NSUInteger i = 0; i < numberOfPages; i++) {
		            @autoreleasepool {
		            	// identifierAndImage is an array @[identifier, image]
		                NSArray *identifierAndImage = [albumManager identifierAndImageForPageOfSDKAlbum:sdkAlbum pageIndex:i];
		                
		                
		                // Upload page images and show your own order window
		                [image rpWriteToFile:[NSString stringWithFormat:@"/Users/ultragtx/Desktop/print_%@_%d.jpg", sdkAlbum.title, i] withCompressQuality:1];
		            }
		        }
		    });
		}
		
	The print info dictionary contains the following entities:
	
	* `kTBSDKCheckoutInfoNumberOfPages`, number of pages that the album contains
	* `kTBSDKPrintInfoProductID`, the product ID, you can know what kind of cover the album use
	
	</br>
	You can get the identifier and image(UIImage *) by calling `[albumManager identifierAndImageForPageOfSDKAlbum:sdkAlbum pageIndex:i]`, here `identifier` is a NSString that can tell you wether the page is modified or not, if the `identifier` is different from the one you get previous, then the page has benn updated and you will need to re-upload the page. If the two identifiers are same, you don't need to upload the same page twice.
	
	**Note**: You should limit the number of page images being loaded (by calling `identifierAndImageForPageOfSDKAlbum:pageIndex:`) at the same time to avoid using too much memory.

	
##Known Issues

1. If a xxl-size image is corrupt or incomplete, user can only find this problem in SDK's print preview, and SDK hasn't provied a delegate method to redownload this image. User can only solve this by removing this image from page. This issue will be solved in the future. For now, you'd better check the MD5 of the image to make sure it's not corrupted.
