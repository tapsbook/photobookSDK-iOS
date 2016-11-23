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





