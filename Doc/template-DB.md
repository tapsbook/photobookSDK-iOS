# SDK Template DB Document

Hey, we are glad you are here. Customizing the Tapsbook SDK's template DB is the biggest hack, yet the most rewarding experience, on your journey using the Tapsbook SDK. After completing this step, you will be able to fully control your product type and style that you can offer to your customers.

## 1. Concept

Tapsbook uses its own template engine to combine page template metadata and user-generated images, text, and embellishment to render finished book pages. The template metadata is stored in an SQlite DB that comes with the SDK binary. Enterprise Account Developers can also customize their own template to be loaded into their final app (you are here means you are an enterprise account developer)

The page template metadata is organized as a tree structure where The top level node is theme which represents multiple page styles. Theme = Function of (aspect ratio type, page color tone). When you want to expose multiple themes to your customers, you can present a theme selection UI to your customer. The default theme loaded in the current SDK is theme_id=200 and it is a square book type. The std_ratio_type value current in the default DB has the following
````
TBStdPageRatio_11x8_5 = 1,
TBStdPageRatio_10_5x8 = 2,
TBStdPageRatio_5x4    = 3,
TBStdPageRatio_1x1    = 4,
````

If you have customized book size other than these predefined aspect ratios, you need to create a new std_ratio_type ID and refer to this ID anywhere else when std_ratio_type is used. and yes, you only need to have one aspect ratio for the simplified aspect ratio, i.e. 3x2 and 15x10 should share one std_ratio_type, for example
````
TBStdPageRatio_3x2    = 5,
````
2. Each Theme includes multiple page layouts. Page layout dictate how many photos to be arranged on the page, and whether a page is a standard page or a spread page (a spread page is two standard pages combined into one sheet).

3. Each page layouts include multiple slots, where a slot can be one of the three types: photo slot, text slot and embellishment slot. These slots all have generic properties such as their positions on the page, the content placement relative to the slot etc.

At the run time, when user chooses to auto-generate all book pages, the engine first loads all templates data from the default local sqlite database and intelligently match the appropriate page template based on the photo selections 

## 2. Importing your Template data to SDK Template
So, now comes the fun part. we suggest you use the attached sample Data and convert script first to get familiar with the concept, then you are free to build your own template.

1. Convert your page template Data. Use the convert.rb script that converts your data to the SQL data import script. Before you run this script, you may want to update the script config options inside the ruby script. The output SQL will include THEME, PAGE_LAYOUTS and SLOTS data.

ruby convert.rb > myTemplate.sql

2. Add new product data to your existing Template sqlite. product info is identified as SKU (server_id). You must define the product property for each SKU, the SDK current requires all product info also stored in the template DB. The following SQL script is an example of one SKU product definition.
````
INSERT INTO print_infos (server_id, provider_name, product_type, name, description, preview_path, std_ratio_type, std_width, std_height, min_pages_count, max_pages_count, file_name, min_ppi, max_ppi) VALUES ($SKU_NUMBER, '$COMPANY_NAME', 1, '$PRODUCT_NAME', '$PRODUCT_DESC', '', $std_ratio_type, $PAGE_W, $PAGE_H, $MIN_PAGE, $MAX_PAGE,  '', 180, 300);
````
where
server_id: SKU (server side defined)
product_type: 1 (photo book) 
std_ratio_type must use a predefined ratio_type value (see section 1.1)
MIN_PAGE, MAX_PAGE is number of pages this product supports (user can add or remove pages, and these two numbers will be used as the limit),
MIN_PPI, MAX_PPI: min image pixel density of the source photo needed, SDK dynamically compute the image resolution when user scales the image.

3. Add product specific book cover layouts. by default, layouts created by step 1 are for page layouts only. You need to create new cover layout, which is 1:1 mapped to print_info as you introduced at step 2.2, because each product will have different cover design. The fastest approach to add a cover C1 to an product (ID=100, SKU=1001) is to 1) select an existing layout, clone it and its slots, and 2) assign this layout's print_info_id  a value (100) refers to the product.       

Import the generated sql scripts to your existing Template sqlite. You now should have a new template database ready for SDK.

## 3. Load the new SDK template to your app

Once you save the changes to the SQLite, you need to force your SDK-enabled app to load your template. To do that, save the update SQLite to TapsbookSDK.bundle folder, if you renamed your template DB, you must also update the SDKconfiguration.m as the following
````
kTBTemplateDatabaseName : @"YOUR_sqlite_file",
````
Tip:  When you have an app upgrade that features a new SQLite template update, and your client is doing an upgrade to its existing app install, iOS will not overwrite the SQLite if the SQLite file name is the same. So we recommend you add a version number to your SQLite file name and update the SDKconfiguration.m every time you have a new template DB.

You are almost done! Now at the app runtime, you can present a product menu that let the user choose which product (SKU) to use, you can specify that SKU selection as albumOption. You should also specify a Theme ID that matches the selected product std_ratio_type (in theory, one std_ratio_type may have multiple themes matching it)

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