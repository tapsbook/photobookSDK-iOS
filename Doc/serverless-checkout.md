# Private SDK Integration

For approved partners, Tapsbook SDK provides a private serverless deployment option that allows the developer to use its own private backend instead of the shared Tapsbook backend.

The diagram below shows the steps your TapsbookSDK-enabled app should perform for a complete order creation and order checkout process.

![image](https://cloud.githubusercontent.com/assets/842068/18487269/9331a440-79c2-11e6-9d46-e0afb132fc18.png)

In this private deployment option, (number here refers to the diagram above) 

1. Your TapsbookSDK enabled app will connect to your own server providing APIs to get product spec and feed that to a customized TapsbookSDK. 
2. The TapsbookSDK behaves as a black box to provide the photo book editing user experience. After user is done editing, the TapsbookSDK saves the users' photo book data to a SDK provied local DB. 
3. Invoke the checkout flow which will let TapsbookSDK generates the order output JSON and page preview data on the mobile device, you can then freely pass the order output JSON to your product server. It is necessary that your application upload the user selected photo to a cloud storage for later order JPG rendering at your server side.
4. Your product server should include eCommerce functions that handles payment processing,and optionally notify the user whether the order is successful.
5. After the payment successful acknolegement from the bank, you can safely start your own production workflow. Your backend should load the order JSON with reference to the uploaded user photos and render the final order output as page JPGs. Once this complete, feed the final output JPGs to your own printing ERP for manufacturing. It is a required step that your backend also send an order notification to Tapsbook server for billing syncrhonization. 

## Integration details
You should follow the integration steps as documented for [TBSDKAlbumManager](http://tapsbook.com/doc/Classes/TBSDKAlbumManager.html), e.g. prepare the TBImages etc, plus also perform the following additional preparation steps.

To enable this workflow, set the SDK configurator as the following
````
    NSDictionary * checkout = @{
                                kTBSendAlbumJSONDictToHostingApp : @YES,
                                kTBGeneratePageImagesToHostingApp : @YES,
                                kTBSendOrderInfoToHostingApp : @YES,
                                };
    
    [settings setObject:checkout forKey:kTBCheckoutCustomization];
````

During step 1, because your backend will manage the product SKU, your app should implement your product picker to let user pick a product (SKU) and this SKU needs also be provisioned in the TapsbookSDK's database through a customization step.  Finally you pass this SKU and other product custoimzation as an albumOption to SDK  
````
    NSDictionary * albumOption = @{
                    kTBProductPreferredTheme:   @"200",  //for square book
                    kTBPreferredProductSKU:     @"1003", //for a layflat book
                    kTBProductMaxPageCount:     @"20",   //max of 20 pages
                    kTBProductMinPageCount:     @"20",   //min of 20 pages
                    kTBPreferredUIDirection:    @"RTL"   //set this RTL or LTR
                    };
    [[TBSDKAlbumManager sharedInstance] createSDKAlbumWithImages:tbImages identifier:nil title:@"Album" tag:0 options:albumOption completionBlock:block];

````

During step 3. Implement the 3 delegate callbacks methods under [TBSDKAlbumManagerDelegate_Checkout_Enterprise]( http://tapsbook.com/doc/Protocols/TBSDKAlbumManagerDelegate_Checkout_Enterprise.html) these methods will be called by SDK to determine which album needs to be included in the JSON generation.
````
– albumManager:checkout3_isSDKAlbumInCart: required method
– albumManager:checkout3_addSDKAlbumToCart:withInfoDict:viewControllerToPresentOn: required method
– albumManager:checkout3_updateSDKAlbumInCart:withInfoDict:viewControllerToPresentOn: required method
````
once this is complete, call the following method to start the final checkout. This async method will return the a dictonary containing the data for you to manufacture the photo book. The dictionary includes a string in “album_JSON” and an array of page image thumbnails in “album_page_thumbnails”. Your app can then sends these data to your backend for final processing.
````
– checkout3_checkoutAlbumsWithIDs:completionBlock:
````

During step 5. Your backend server should load the order JSON and uploaded images to process the final print output for final production.  The JSON format sample and reference can be found below.
- [JSON sample](https://github.com/tapsbook/photobookSDK-iOS/blob/master/Doc/sample_album.json)
- [JSON reference](https://github.com/tapsbook/photobookSDK-iOS/blob/master/Doc/sample_json_info.md)

This step should also include a REST API call to Tapsbook server to notify that the order transaction has been successfuly completed and this record will be used for the billing synchronization. This is a non-blocking API call and does not stop your normal workflow.
````
[POST] https://dashboard.tapsbook.com/api/v1/orders
````
Here is the content for the POST request.
````
{
    "order_type" : "notify",
    “api_key":"YOUR_API_KEY ",
    "external_order_id":"YOUR ORDER ID",
    "currency": "USD",
    "total_price": "98.00",
    "order_date": "2016-08-02T12:20:21Z",
    "customer": {
        "address": {
            "phone": "CUSTOMER_PHONE",
            "address1": "",
            "email": "CUSTOMER_EMAIL",
            "state_id": "99",
            "country_id": "48",
        }
    }
}
````
