# Order Checkout & Payment Options

Once you are done with the base integration of SDK with your app, you need to take care of the checkout and payment integrations. Tapsbook 
（cleen）support the following 3 options.

  - Tapsbook-all-the-way：Use Tapsbook built-in checkout UI, eCommerce backend and Tapsbook manufacturers
  - Hybrid of App UI and Tapsbook backend：Use your app's checkout UI, your eCommerce backend and Tapsbook manufacturers
  - All-out-with-my-own：Use Tapsbook SDK editor, all else from your app: checkout UI, eCommerce backend and your manufacturers

All these three options allow you to set your own product price and choose your payment gateway. They vary on the degree of flexibility if 
you are willing to take the trade off the additional development.

Option 1 is your fast path to get things done, it is better suited for an app that can doesn't have eCommerce features or doesn't require full customization or integration 
with their own eCommerce backend.(promotion, shipping etc)

Option 2 offers the ultimate flexibility that allows you to use your app checkout UI and eCommerce but uses Tapsbook fulfillment network 
for product manufacturing. It is better suited for an app that already has eCommerce features or with a strong engineering team.

Option 3 let you use your own manufacturer, and offers the ultimate cross-platform interoperability, this option requires extensive 
integration effort and requires special license. 

This article focuses mainly on the first two options.

### Before you start
 - App Developer need to sign the Production Agreement
 - App Developer has completed the product test and is satisfied with the product quality

### Hybrid of App UI and Tapsbook backend

See the life cycle view of this option。
![life_cycle](http://7xsnph.com1.z0.glb.clouddn.com/tapsbook-checkout.png)

1. App offers product selection for user to pick the product type
2. SDK loads product template and customize the editor
3. User completes the work and save the order to server
4. App presents checkout UI to collect shipping address and payments
5. Confirm the order is complete after payment is received.


Now let's look at step 3-5 in more details.

Step 3. After user completes the editing and click the "order" button, the SDK will save the order to server，and then execute step 4 via the callback in step 4.

First, update SDKConfigurator to use External Checkout

		kTBCheckoutCustomization : @{                
		        kTBUseExternalCheckout : @YES
		};
		
Once enabled, when user click Order button on the SDK editor UI, SDK will start rendering print quality image as JPGs for each book pages, then uploads these JPGs to Tapsbook server, once completed, this editing is saved on the server and having a pre-order number for pending confirmation. The screen below shows the uploading progress view

![life_cycle](http://7xsnph.com1.z0.glb.clouddn.com/tapsbook-upload.png)

Step 4. App presents checkout UI to collect shipping address and payments, here you presents your UI wizard to walk through the user for the checkout process

Implement `TBSDKAlbumManager` delegate method to launch your checkout flow. This method will be invoked automatically as a callback after the product data is saved at the server

		- (void)albumManager:(TBSDKAlbumManager *)albumManager checkoutSDKAlbum:(TBSDKAlbum *)sdkAlbum withOrderNumber:(NSString *)orderNumber viewControllerToPresentOn:(UIViewController *)viewController {

    		//show your checkout view now
    		//please save the orderNumber
		CheckoutViewController *vc = [CheckoutViewController new];
	    	[viewController presentViewController:vc animated:YES completion:nil];
		}
	
 - `CheckoutViewController`, is your checkout UI, a typical checkout flow includes a form collecting shipping address and payment options, for app with existing eCommerce options, you can just reuse your existing views. Typically you will use payment gateway such as Stripe or Paypal to collect payment.
 - `orderNumber`, is a pre-order number that you can later refer to in order to confirm in the next step

Step 5. Confirm the order is complete after payment is received. After payment is cleared, update the order with address and 
confirm the order release for production. Order not confirmed within 3 days will be deleted.

In order to confirm the order, you need to POST the following JSON data to the server

Test Server: https://search.tapsbook.com/api/v1/orders

Prod Server: https://dashboard.tapsbook.com/api/v1/orders

notice you need to provide the API_KEY and order's PREORDER_NUMBER as obtained from step 4 above.

````
{
  "api_key": "YOUR_KEY",
  "order_type": "CONFIRM",
  "order_number": "PREORDER_NUMBER",
  "payment_method" : "MERCHANT_ACCOUNT",  
  "customer": {
    "address": {
      "phone": "PHONE",
      "state": "STATE",
      "city": "CITY",
      "address1": "ADDRESS",
      "address2": "ADDRESS line 2",
      "zipcode": "ZIP",
      "firstname": "",
      "lastname": "FULL NAME",
      "email": "EMAIL",
      "state_id": "0",
      "country_id": "48",
    }
  }
}

````

## Post order notifications

Once the order is confirmed at the Tapsbook manufacturing system:

1. If you chose option 1, customer will recieve an confirmation email or SMS (custimizable by the app developer). If you chose option 2, you can opt-in for webhook call
2. After the order production is complete and order shipping info (tracking number) is avaiable, there will be a notification sent similar to above.
3. You can query the product status via our status tracking APIs


## Other details
The diagram below shows the steps the SDK perform for the usual checkout after the product is created and ready for checkout.
 
 ![image](https://cloud.githubusercontent.com/assets/842068/12008562/dbd3d6de-ac11-11e5-8da3-4079a4b7d4e0.png)
 
 Specifically, TBSDKAlbumManager performs the following steps
 
  1. Load the full size TBImage and renders the high resolution book pages for print
 
  2. Upload the rendered high resolution images to AWS S3 Cloud Storage
 
  3. Present the built-in iOS native shopping cart view and checkout views to collect payment info. The product info and the payment info is then sent to Tapsbook server.
 
  At the backend, the Tapsbook server uses the 3rd party payment handler (Stripe or Paypal) to charge the customer and credit the proceeds to your account. Once completed, the tapsbook server will send the order to its manufacturing partner for production.
 
 The SDK renders the print ready high resolution page images according to the manufacturer printing standard (bleeding margins, spine width etc). During the rendering phase of each page, it loads the full size version of each image using an auto-released pool.  TBSDKAlbumManager will trigger its delegate method [TBSDKAlbumManagerDelegate albumManager:preloadXXLSizeImages:ofSDKAlbum: progressBlock:completionBlock] to ask your app to provide the full size images if they were not imported during the preparation phase.
 
 The rendered images will be uploaded to Cloud Storage and run MD5 check to ensure its integrity. You will need to provide your own AWS S3 storage account for storing the rendered book page images. These images will be retrieved by the photo book manufacturer at the manufacturing time.
 
 The Checkout workflow currently supports Stripe APIs for worldwide customer payment and Alipay APIs for China customer payment. The TBSDKAlbumManager does not store customer credit card number, and it only sends the data to tapsBook backend server for making the charge.  Once the charge is verified, the order will be submitted to manufacturers for production.
 
 **To check out a book using your own eCommerce **

 The diagram below shows the steps the SDK performs and the 3rd party checkout integration point. The red arrow highlights the steps you must implement.
 
 ![image](https://cloud.githubusercontent.com/assets/842068/12011734/d2a4f4ee-aca7-11e5-95b5-e9777acc8c69.png)

 Specifically, TBSDKAlbumManager performs the following steps
 
 1. Same as the SDK-checkout case, it loads the full size TBImage and renders the high resolution book pages for print and then uploads the pages to AWS S3. The order data is then sent to the Tapsbook server.
 
 2. Instead of showing SDK shopping cart view and checkout views to collect payment info, the SDK gives you a callback for you to present your own checkout views. The callback will includes an order number as the key to link to order data referred in step 1.
 
 Your app must implement the following:
 
 1. Implement your own checkout views, including address collection, shopping cart view and payment information views. 
 
 2. Once you collect the data, send to your server to process the payment and compelte the order on your eCommerce server. Once completed the order and get the payment, your server should communicate to Tapsbook server to "claim" the order identified by the order number. 
 
 3. Once claimed, the server will reply with the full book data in JSON or XML for you to send to your manufacturing process. You should only claim an order after it is paid, as it will be billed to your merchant account for billing purpose.
 
 To use this option, To use this option you must set YES to [TBSDKConfiguratorProtocol shouldSendJSONDictToHostingAppWhenCheckout] in your app's configuration, and then  implement the delegate [TBSDKAlbumManagerDelegate_Checkout_Enterprise albumManager:checkoutSDKAlbum:withInfoDict:viewControllerToPresentOn:] to present your checkout viewControllers.





