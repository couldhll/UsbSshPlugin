//
//  UsbSshMenuItem.m
//  UsbSshPlugin
//
//  Created by CouldHll on 14-3-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "UsbSshMenuItem.h"
#import "PortTextFieldFormatter.h"
#import "Const.h"

@implementation UsbSshMenuItem

@synthesize delegate;
@synthesize title;
@synthesize port;
@synthesize titleTextField;
@synthesize portTextField;
@synthesize startButton;

- (id)initWithTitle:(NSString *)aString action:(SEL)aSelector keyEquivalent:(NSString *)charCode
{
    if (self = [super initWithTitle:aString action:aSelector keyEquivalent:charCode])
    {
        NSView *view=[[NSView alloc] initWithFrame:CGRectMake(20, 0, 250, 20)];
        
        titleTextField=[[NSTextField alloc] initWithFrame:CGRectMake(20, 0, 120, 20)];
        [self convertTextFieldToLable:titleTextField];
        [view addSubview:titleTextField];
        
        portTextField=[[NSTextField alloc] initWithFrame:CGRectMake(130, 0, 50, 20)];
        [self convertLabelToTextField:portTextField];
        [view addSubview:portTextField];
//        PortTextFieldFormatter *formatter = [[PortTextFieldFormatter alloc] init];
//        [portTextField setFormatter:formatter];
        
        startButton=[[NSButton alloc] initWithFrame:CGRectMake(200, 0, 50, 20)];
        [startButton setTitle:MENU_BUTTON_START];
        [startButton setTarget:self];
        [startButton setAction:@selector(startButtonClick:)];
        [view addSubview:startButton];
        
        [self setView:view];
    }
    return self;
}

#pragma mark - Property

- (NSString *)title
{
    NSString *titleValue=[titleTextField stringValue];
    return titleValue;
}
- (void)setTitle:(NSString *)aTitle
{
    [titleTextField setStringValue:aTitle];
}

- (NSInteger)port
{
    NSInteger portValue=[portTextField integerValue];
    return portValue;
}
- (void)setPort:(NSInteger)aPort
{
    // port in 0~65535
    if (aPort < 0 || aPort > 65535)
    {
        aPort = 0;
    }
    
    [portTextField setIntegerValue:aPort];
}

#pragma mark - Action

- (void)startButtonClick:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(startButtonClick:)])
    {
        [delegate startButtonClick:sender];
    }
}

#pragma mark - Private Methods

- (void)convertLabelToTextField : (NSTextField *)textlabel
{
    [textlabel setBezeled:YES];
    [textlabel setDrawsBackground:YES];
    [textlabel setEditable:YES];
    [textlabel setSelectable:YES];
}

- (void)convertTextFieldToLable : (NSTextField *)textField
{
    
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
    [textField setBezeled:NO];
}

@end
