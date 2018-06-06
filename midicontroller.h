/* midicontroller */

#import <Cocoa/Cocoa.h>
#import <mainhid.h>
#import <CoreMIDI/CoreMIDI.h>

@interface midicontroller : NSObject
{
	IBOutlet id channel;
    IBOutlet id rxCC;
    IBOutlet id rxSens;
    IBOutlet id rxValue;
	IBOutlet id rxMode;
    IBOutlet id ryCC;
    IBOutlet id rySens;
    IBOutlet id ryValue;
	IBOutlet id ryMode;
    IBOutlet id rzCC;
    IBOutlet id rzSens;
    IBOutlet id rzvalue;
	IBOutlet id rzMode;
    IBOutlet id txCC;
    IBOutlet id txSens;
    IBOutlet id txValue;
	IBOutlet id txMode;
    IBOutlet id tyCC;
    IBOutlet id tySens;
    IBOutlet id tyValue;
	IBOutlet id tyMode;
    IBOutlet id tzCC;
    IBOutlet id tzSens;
    IBOutlet id tzValue;
	IBOutlet id tzMode;
}
- (IBAction)rxCCchanged:(id)sender;
- (IBAction)ryCCchanged:(id)sender;
- (IBAction)rzCCchanged:(id)sender;
- (IBAction)txCCchanged:(id)sender;
- (IBAction)tyCCchanged:(id)sender;
- (IBAction)tzCCchanged:(id)sender;
- (void)showTx:(int)tx Ty:(int)ty Tz:(int)tz Rx:(int)rx Ry:(int)ry Rz:(int)rz  toMidi:(MIDIEndpointRef)ep;

@end
