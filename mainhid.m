//
//  mainhid.m
//  MIDI Navigator
//
//  Created by Stefan Werner on 12/15/06.
//  Copyright 2006 keindesign. All rights reserved.
//

#import "mainhid.h"
#import <CoreMIDI/CoreMIDI.h>
#import <IOKit/hid/IOHIDUsageTables.h>
#import "midicontroller.h"

#import <3DconnexionClient/ConnexionClientAPI.h>

MIDIClientRef gClient = 0;
MIDIEndpointRef	gMidiSource = 0;

mainhid* gMainhid;

void AddedDevice(io_connect_t connection)
{
	MIDIClientCreate(CFSTR("NaviMIDI"), NULL, NULL, &gClient);	
	MIDISourceCreate(gClient, CFSTR("SpaceNavigator"), &gMidiSource);
}
void RemovedDevice(io_connect_t connection)
{
	MIDIClientDispose(gClient);
	MIDIEndpointDispose(gMidiSource);
}
void HandleMessage(io_connect_t connection, natural_t messageType, void *messageArgument)
{ 
	ConnexionDeviceStatePtr msg; 
	
	msg = (ConnexionDeviceStatePtr)messageArgument; 
	
	switch(messageType) 
	{ 
		case kConnexionMsgDeviceState: 
			/* Device state messages are broadcast to all clients.  It is up to 
			* the client to figure out if the message is meant for them. This 
			* is done by comparing the "client" id sent in the message to our 
			* assigned id when the connection to the driver was established. 
			* 
			*/ 
			switch (msg->command) 
			{ 
				case kConnexionCmdHandleAxis: 
					[[gMainhid getController] showTx:msg->axis[0] Ty:msg->axis[1] Tz:msg->axis[2] Rx:msg->axis[3] Ry:msg->axis[4] Rz:msg->axis[5] toMidi:gMidiSource];                        
					break; 
					
					
				case kConnexionCmdHandleButtons: 
					// msg->value is the button state 
					// msg->buttons is the button ID 
					break;                   
			} 
			break; 
			
		default: 
			// other messageTypes can happen and should be ignored 
			break; 
	} 
}

@implementation mainhid

-(void)awakeFromNib
{
	OSErr err = InstallConnexionHandlers (HandleMessage, AddedDevice, RemovedDevice);
	if (err == noErr)
	{
		UInt32 signature = kConnexionClientWildcard;// 'mnav';
		UInt8 *name = (UInt8*)"MIDI Navigator";
		UInt16 mode = kConnexionClientModeTakeOver;
		UInt32 mask = kConnexionMaskAll;
		myID = RegisterConnexionClient(signature, name, mode, mask);
	}
	
	gMainhid = self;
}

-(void)dealloc
{
	if (myID)
		UnregisterConnexionClient(myID);
	CleanupConnexionHandlers();
	[super dealloc];
}

-(id)getController
{
	return mController;
}

@end
