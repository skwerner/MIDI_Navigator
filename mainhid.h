//
//  mainhid.h
//  MIDI Navigator
//
//  Created by Stefan Werner on 12/15/06.
//  Copyright 2006 keindesign. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "midicontroller.h"
#import <CoreMIDI/CoreMIDI.h>

@interface mainhid : NSObject {
	IBOutlet id mController;
	UInt16 myID;
}
-(void)awakeFromNib;
-(void)dealloc;
-(id)getController;
@end
