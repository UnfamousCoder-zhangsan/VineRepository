

#import "JWButton.h"

@implementation JWButton
@synthesize inputView, inputAccessoryView;

- (BOOL) canBecomeFirstResponder {
    return YES;
}


@end
