//
//  PortTextFieldFormatter.m
//  UsbSshPlugin
//
//  Created by CouldHll on 14-3-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "PortTextFieldFormatter.h"

@implementation PortTextFieldFormatter

@synthesize minLength;
@synthesize maxLength;

- (id)init {
    
    if(self = [super init]){
        minLength = 0;
        maxLength = 5;
    }
    
    return self;
}

- (NSString *)stringForObjectValue:(id)object {
    return (NSString *)object;
}

- (BOOL)getObjectValue:(id *)object forString:(NSString *)string errorDescription:(NSString **)error {
    *object = string;
    return YES;
}

- (BOOL) isPartialStringValid: (NSString **) partialStringPtr
        proposedSelectedRange: (NSRangePointer) proposedSelRangePtr
               originalString: (NSString *) origString
        originalSelectedRange: (NSRange) origSelRange
             errorDescription: (NSString **) error
{
    NSCharacterSet *nonDigits;
    NSRange newStuff;
    NSString *newStuffString;
    
    nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    newStuff = NSMakeRange(origSelRange.location,proposedSelRangePtr->location- origSelRange.location);
    newStuffString = [*partialStringPtr substringWithRange: newStuff];
    
    if ([newStuffString rangeOfCharacterFromSet: nonDigits
                                        options: NSLiteralSearch].location != NSNotFound)
    {
        *error = @"input is not a num.";
        return NO;
    }
    
    if ([*partialStringPtr length] > maxLength)
    {
        return NO;
    }
    
    if (![*partialStringPtr isEqual:[*partialStringPtr uppercaseString]])
    {
        *partialStringPtr = [*partialStringPtr uppercaseString];
        return NO;
    }
    
    return YES;

}

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)attributes {
    return nil;
}

@end