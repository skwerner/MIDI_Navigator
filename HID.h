/*
 *  HID.h
 *  game2midi
 *
 *  Created by Stefan Werner on 12/5/06.
 *  Copyright 2006 keindesign. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>
#import "HID_Utilities_External.h"

typedef void (*IOHIDCallbackFunction)
(void * target, IOReturn result, void * refcon, void * sender);

@interface HIDElement : NSObject {
	pRecElement mElement;
	pRecDevice mDevice;
}
- (id)initWithElement:(pRecElement)element device:(pRecDevice)device;
- (int)usage;
- (int)type;
- (NSString*)usageString;
- (int)value;
-(void)setValue:(int)value;
@end

@interface HIDDevice : NSObject {
	pRecDevice mDevice;
}
- (id)initWithDevice:(pRecDevice)device;
	//- (NSString*)name;
	//- (int)type;
- (int)usage;
- (int)countType:(int)type;
- (int)buttonCount;
- (int)axisCount;
- (int)countElement;
- (NSString*)product;
- (HIDElement*)elementAtIndex:(int)index;
- (int)vendorID;
- (int)productID;
-(void)setCallback:(IOHIDCallbackFunction)callback;
@end

@interface HIDManager : NSObject {
	
}
- (id)init;
- (int)countDevices;
- (HIDDevice*)deviceAtIndex:(int)index;
@end
