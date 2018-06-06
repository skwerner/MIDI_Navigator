#import "midicontroller.h"

@implementation midicontroller

- (IBAction)rxCCchanged:(id)sender
{
}

- (IBAction)ryCCchanged:(id)sender
{
}

- (IBAction)rzCCchanged:(id)sender
{
}

- (IBAction)txCCchanged:(id)sender
{
}

- (IBAction)tyCCchanged:(id)sender
{
}

- (IBAction)tzCCchanged:(id)sender
{
}

static void sensFunc(int* x, float* xf, float gamma, float mult, long mode)
{
	if (mode == 0) {
		if (*x > 0)
			*xf += 5.f*powf(*x/50.f * mult, gamma);
		else
			*xf -= 5.f*powf(-(*x)/50.f * mult, gamma);
		
		*x = floorf(*xf);
	} else {
		*x = (*x) / 30.f * mult;
	}
	if (*x < -63)
		*x = -63;
	else if (*x > 63)
		*x = 63;
	*xf -= floorf(*xf);
}

- (void)showTx:(int)tx Ty:(int)ty Tz:(int)tz Rx:(int)rx Ry:(int)ry Rz:(int)rz  toMidi:(MIDIEndpointRef)ep
{
	ry = -ry;
	ty = -ty;
	
	if (tx != 0 || ty != 0 || tz != 0 || rx != 0 || ry != 0 || rz != 0)
	{
		#define factor 150.f
		[txValue setFloatValue:((float)tx)/factor];
		[tyValue setFloatValue:((float)ty)/factor];
		[tzValue setFloatValue:((float)tz)/factor];
		[rxValue setFloatValue:((float)rx)/factor];
		[ryValue setFloatValue:((float)ry)/factor];
		[rzvalue setFloatValue:((float)rz)/factor];
		
		Byte midibuf[1024];
		Byte mididata[3];
		
		MIDIPacketList *plist = (MIDIPacketList*)midibuf;
		MIDIPacket *p = MIDIPacketListInit(plist);
		
		static float txf = 0.f;
		static float tyf = 0.f;
		static float tzf = 0.f;
		static float rxf = 0.f;
		static float ryf = 0.f;
		static float rzf = 0.f;
		
		sensFunc(&tx, &txf, 3.f, [txSens floatValue], [txMode indexOfSelectedItem]);
		sensFunc(&ty, &tyf, 3.f, [tySens floatValue], [tyMode indexOfSelectedItem]);
		sensFunc(&tz, &tzf, 3.f, [tzSens floatValue], [tzMode indexOfSelectedItem]);
		sensFunc(&rx, &rxf, 3.f, [rxSens floatValue], [rxMode indexOfSelectedItem]);
		sensFunc(&ry, &ryf, 3.f, [rySens floatValue], [ryMode indexOfSelectedItem]);
		sensFunc(&rz, &rzf, 3.f, [rzSens floatValue], [rzMode indexOfSelectedItem]);

		mididata[0] = 0xb0 + [channel indexOfSelectedItem];
		if (tx != 0)
		{
			mididata[1] = [txCC intValue];
			mididata[2] =  64 + tx;
			p = MIDIPacketListAdd(plist, 256, p, 0, 3, mididata);
		}

		if (ty != 0)
		{
			mididata[1] = [tyCC intValue];
			mididata[2] =  64 + ty;
			p = MIDIPacketListAdd(plist, 256, p, 0, 3, mididata);
		}
		
		if (tz != 0)
		{
			mididata[1] = [tzCC intValue];
			mididata[2] =  64 + tz;
			p = MIDIPacketListAdd(plist, 256, p, 0, 3, mididata);
		}
		
		if (rx != 0)
		{
			mididata[1] = [rxCC intValue];
			mididata[2] =  64 + rx;
			p = MIDIPacketListAdd(plist, 256, p, 0, 3, mididata);
		}
		
		if (ry != 0)
		{
			mididata[1] = [ryCC intValue];
			mididata[2] =  64 + ry;
			p = MIDIPacketListAdd(plist, 256, p, 0, 3, mididata);
		}
		
		if (rz != 0)
		{
			mididata[1] = [rzCC intValue];
			mididata[2] =  64 + rz;
			MIDIPacketListAdd(plist, 256, p, 0, 3, mididata);
		}
		
		MIDIReceived(ep, plist);
	}
}

@end
