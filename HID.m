/*
 *  HID.cpp
 *  game2midi
 *
 *  Created by Stefan Werner on 12/5/06.
 *  Copyright 2006 keindesign. All rights reserved.
 *
 */

#import "HID.h"
#import <IOKit/hid/IOHIDUsageTables.h>
#import "HID_Utilities_External.h"

@implementation HIDManager

-(id)init
{
	HIDBuildDeviceList(0,0);
	return self;
}
	
-(int)countDevices
{
	return HIDCountDevices();
}

-(HIDDevice*)deviceAtIndex:(int)index;
{
	int count = 0;
	pRecDevice dev = HIDGetFirstDevice();
	
	while (dev) {
		if (count == index)
			return [[HIDDevice alloc] initWithDevice:dev];
		count++;
		dev = HIDGetNextDevice(dev);
	}
	
	return nil;
}

@end

@implementation HIDDevice

-(id)initWithDevice:(pRecDevice)device
{
	mDevice = device;
	return self;
}

-(int)usage
{
	return mDevice->usage;
}

-(int)vendorID
{
	return mDevice->vendorID;
}

-(int)productID
{
	return mDevice->productID;
}

-(NSString*)product
{
	return [NSString stringWithCString:mDevice->product];
}

-(int)countElement
{
	return HIDCountDeviceElements(mDevice, kHIDElementTypeIO);
}

-(int)countType:(int)type
{
	int count = 0;
	
	pRecElement el = HIDGetFirstDeviceElement (mDevice, kHIDElementTypeAll);
	while (el) {
		if (el->type==type)
			count++;
		el = HIDGetNextDeviceElement(el, kHIDElementTypeAll);
	}
	return count;
}

-(int)buttonCount
{
	return [self countType:kIOHIDElementTypeInput_Button];
}
-(int)axisCount
{
	return [self countType:kIOHIDElementTypeInput_Misc];
}

-(HIDElement*)elementAtIndex:(int)index
{
	int count = 0;
	
	pRecElement el = HIDGetFirstDeviceElement (mDevice, kHIDElementTypeAll);
	while (el) {
		if (count++ == index)
			return  [[HIDElement alloc] initWithElement:el device:mDevice];;
		el = HIDGetNextDeviceElement(el, kHIDElementTypeAll);
	}
	
	return nil;
}

-(void)setCallback:(IOHIDCallbackFunction)callback
{
	HIDQueueDevice(mDevice);
	HIDSetQueueCallback(mDevice, callback);
}

@end

@implementation HIDElement
- (id)initWithElement:(pRecElement)element device:(pRecDevice) device;
{
	mElement = element;
	mDevice = device;
	return self;
}
- (int)usage
{
	return mElement->usage;
}

-(int)type
{
	return mElement->type;
}

- (NSString*)usageString
{
	char name[256];
	HIDGetUsageName(mElement->usagePage, mElement->usage, name);
	return [NSString stringWithCString:name];
}

- (int)value
{
	return HIDGetElementValue(mDevice, mElement);
}

-(void)setValue:(int)value
{
	IOHIDEventStruct onEvent;
	onEvent.type = kIOHIDElementTypeOutput;
	onEvent.elementCookie = mElement->cookie;
	onEvent.value = value;
	onEvent.longValueSize = 0;
	onEvent.longValue = NULL;
	HIDSetElementValue(mDevice, mElement, &onEvent);
}
@end
