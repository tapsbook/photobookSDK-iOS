The album JSON contains a list of pages 

````
{  
   coverpages = {cover_page_json}
   pages = [  page1_json, page2_json ... ]
   numberOfPages = N
}
````

The cover page and inside page all share the similar data structure, each page contains multiple slots
````
coverpages = 
{
  slots:  [slot1_json, slot2_json, .... ]
}
````

There are two kinds of slots: image slot and text slot.
````
slot = 
{
     content =    {
         color = FFFFFFFF;
         isColor = 1;
         type = image;
     };
     backgroundColor = 00000000;
     centerX = 95400;
     centerY = 46500;
     contentHeight = 93000;
     contentOffsetX = 0;
     contentOffsetY = 0;
     contentRotation = 0;
     contentWidth = 190800;
     height = 93000;
     width = 190800;
     pageHeight = 93000;
     pageWidth = 190800;
     rotation = 0;
     zIndex = "-100";
}
````

Here 
````
      pageHeight/width: the size of the whole page, this number is used as the reference to calcuate the relative size of the slot
      centerX/Y: the center of the slot relative to the page top left
      width/height: the size of the slot
      contentWidth/Height: the size of the image content inside the slot box, user may use gesture to zoom in/out the image which result the contentW/H to increase
      contentOffsetX/Y: by default the image is centered at the slot's center, use may choose to move the image off the center to change the crop of the image.
      zIndex: the order of slot need to be respected in case there are overlapping part of the image.
      rotation: the rotation in 360 degrees.
````
Notice the w/h x/y number above are all relative to the page w/h, e.g. if when a slot has w/h=190800/93000 and the page has w/h=190800/93000, you can then calcuate the slot width is 100% of the page width. This allows you to easily scale one page layout as long as the page w/h aspect ratio remains the same.

