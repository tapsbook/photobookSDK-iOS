#数据统计
在您初始化sdk的时候，您可以额外配置该操作。TapsbookSDK支持两种数据收集方式。

	- 不使用TapsbookSDK提供的数据统计功能
	- 使用TapsbookSDK提供的GoogleAnalytics服务
	- 使用TapsbookSDK提供的友盟统计服务

```
/// 事件统计方式
typedef NS_ENUM(NSInteger, TBUserTrackerUsingType) {//
    TBUserTrackerUsingType_None   = 0,
    TBUserTrackerUsingType_Google = 1,
    TBUserTrackerUsingType_UMeng  = 2,
};
```
不使用数据统计功能。
```
[TBUserTrackerManager setupTBUserTrackerUsingType:TBUserTrackerUsingType_None];
```

第二种方式，使用GoogleAnalytics数据统计功能。（默认使用Google）也可以不做任何配置。
```
[TBUserTrackerManager setupTBUserTrackerUsingType:TBUserTrackerUsingType_Google];
```

第三种方式，使用友盟的数据统计方式。友盟需要开发者自己集成umeng的数据统计SDK，我们会提供给开发者一个集成友盟事件的txt文件。
```
[TBUserTrackerManager setupTBUserTrackerUsingType:TBUserTrackerUsingType_UMeng];
```


