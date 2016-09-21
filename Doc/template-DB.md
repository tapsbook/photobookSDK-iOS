# SDK Template DB Document

Hey, we are glad you are here. Customizing the Tapsbook SDK's template DB is probably the most advanced customization, yet the most rewarding experience, on your journey using the Tapsbook SDK. After completing this step, you will be able to fully control your product type and style that you can offer to your customers.

## 1. Concept

Tapsbook uses its own template engine to combine page template metadata and user-generated images, text, and embellishment to render finished book pages. The template metadata is stored in an SQlite DB that comes with the SDK binary. Enterprise Account Developers can also customize their own template to be loaded into their final app (you are here means you are an enterprise account developer). To finish the tasks in this doc, we suggest use a tool such as SQLiteStudio(Mac) to view the SQLite data.

1.1 The page template metadata is organized as a tree structure where The top level node is **theme** which represents page styles. Theme = Function of (aspect ratio type, page color tone). When you want to expose multiple themes to your customers, you can present a theme selection UI to your customer. The default theme loaded in the current SDK is theme_id=200 and it is a square book type. The available std_ratio_type value current in the default DB has the following
````
TBStdPageRatio_11x8_5 = 1,
TBStdPageRatio_10_5x8 = 2,
TBStdPageRatio_5x4    = 3,
TBStdPageRatio_1x1    = 4,
TBStdPageRatio_22x30  = 5,
TBStdPageRatio_30x22  = 6,
TBStdPageRatio_4x3    = 7,
TBStdPageRatio_3x4    = 8,
TBStdPageRatio_8_5x11 = 9,
TBStdPageRatio_8x10_5 = 10,
````

If you have customized book size other than these predefined aspect ratios, you need to create a new std_ratio_type ID and refer to this ID anywhere else when std_ratio_type is used. and yes, you only need to have one aspect ratio for the simplified aspect ratio, i.e. 3x2 and 15x10 should share one std_ratio_type, for example
````
TBStdPageRatio_3x2    = 9,
````
1.2 Each Theme includes multiple page layouts. Page layout dictate how many photos to be arranged on the page, and whether a page is a standard page or a spread page (a spread page is two standard pages combined into one sheet).

1.3 Each page layouts include multiple slots, where a slot can be one of the three types: photo slot, text slot and embellishment slot. These slots all have generic properties such as their positions on the page, the content placement relative to the slot etc.

1.4 Just like a typical Object Oriented programming paradigm where class needs to be instantiated to an instance, the theme needs to be instantiated to a real product before it can be used by the SDK. As designed, one product must have a specific std_ratio_type, but one std_ratio_type may have multiple themes matching it. In TapsbookSDK, we use PrintInfo object to track prodcuts, each printInfo needs to have a SKU, ID. and it is linked to Theme via std_ratio_type. 

At the run time, when user chooses to auto-generate all book pages, the engine first loads the ProductInfo and all templates data from the local sqlite database and intelligently match the appropriate page template based on the photo selections 

## 2. Importing your Template data to SDK Template
Now comes the fun part to get your hands dirty. we suggest you use the attached sample Data and convert script first to get familiar with the concept, then you are free to import your own template.

2.1 Convert your page template Data. Use the convert.rb script that converts your data to the SQL data import script. Before you run this script, you must update the script config options inside the ruby script. The output SQL will include THEME, PRINT_INFO, PAGE_LAYOUTS, PAGE_BACKGROUNDS and SLOTS data in SQL format.
````
ruby convert.rb > myTemplate.sql
````

2.2 Add product specific book cover layouts. By default, layouts created by step 2.1 are for page layouts only. If you directly use that data as is, your book will not have a cover. The cover page layout is like regular page layouts, but it needs to be created separately. This is because different product type tends to have have different cover specification (e.g. soft cover and hard cover will have very different cover size), you need to have a designated cover layout, mapping to the different Product type (print_info). Assume you have a product (print_info_id=8), tthe fastest approach to set its cover layout is to pick an existing spread page layout and set its print_info_id = 8.  
````
INSERT INTO 'page_layouts' ('id','theme_id','std_ratio_type','width','height','thumb_path','is_spread', 'print_info_id') VALUES (2505,202,9,63750,82500,'Tapsbook/Layouts/8.5x11/layout_2505.png',0, 8);
````

2.3 Import the generated sql scripts to your existing Template sqlite. You now should have a new template database ready for SDK consumption.

````
cat myTemplate.sql | sqlite3 TemplateDB.sqlite
````

## 3. Load the new SDK template to your app

Once you have an updated SQLite, you need to make your SDK-enabled app to load your template. To do that, save the update SQLite to TapsbookSDK_Binary/TapsbookSDK.bundle folder. It is recommended that you check  the SDKconfiguration.m which should have the right DB file name
````
kTBTemplateDatabaseName : @"YOUR_sqlite_file",
````
Tip:  When you have an app upgrade that features a new SQLite template update, and your client is doing an upgrade to its existing app install, iOS will not overwrite the SQLite if the SQLite file name is the same. So we recommend you add a version number to your SQLite file name and update the SDKconfiguration.m to sync with the new name every time you introduce changes to your template DB.

You are almost done! Now at the app runtime, you can present a product menu that let the user choose which product (SKU) to use, you can specify that SKU selection as albumOption. You should also specify a Theme ID that matches the selected product std_ratio_type 

````
NSDictionary * albumOption = @{                                           
  kTBPreferredProductSKU:     @"1003", //sku=1003 is a layflat square book
  kTBProductPreferredTheme:   @"200",  //200 is for square book   
  //other options....                                             
}                                                                 
[[TBSDKAlbumManager sharedInstance] createSDKAlbumWithImages:tbImages identifier:nil title:@"Album" tag:0 options:albumOption completionBlock:^(BOOL success, TBSDKAlbum *sdkAlbum, NSError *error) {
...
````
To try the SKU switch in action, you can change the albumOption to the following to load a 11x8.5 sized book to the SDK. 
````
kTBPreferredProductSKU:     @"998",  //sku=998 is a layflat square book
kTBProductPreferredTheme:   @"201",  //200 is for square book
````

## That's it!
Thank you for reading this doc. If you have any problem when creating and loading your own template, please feel free to reach us support@tapsbook.com
