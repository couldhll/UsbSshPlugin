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
@synthesize port;
@synthesize titleTextField;
@synthesize portTextField;
@synthesize startButton;
@synthesize stopSubMenu;

- (id)initWithTitle:(NSString *)aString action:(SEL)aSelector keyEquivalent:(NSString *)charCode
{
    if (self = [super initWithTitle:aString action:aSelector keyEquivalent:charCode])
    {
        // start item
        NSMenuItem *startMenuItem=[[NSMenuItem alloc] init];
        NSView *view=[[NSView alloc] initWithFrame:CGRectMake(20, 0, 180, 20)];
        titleTextField=[[NSTextField alloc] initWithFrame:CGRectMake(20, 0, 50, 20)];
        [titleTextField setStringValue:MENU_MAIN_START_LABEL_TITLE];
        [self convertTextFieldToLable:titleTextField];
        [view addSubview:titleTextField];
        portTextField=[[NSTextField alloc] initWithFrame:CGRectMake(60, 0, 50, 20)];
        [self convertLabelToTextField:portTextField];
        [view addSubview:portTextField];
//        PortTextFieldFormatter *formatter = [[PortTextFieldFormatter alloc] init];
//        [portTextField setFormatter:formatter];
        startButton=[[NSButton alloc] initWithFrame:CGRectMake(120, 0, 50, 20)];
        [startButton setTitle:MENU_MAIN_START_BUTTON_TITLE];
        [startButton setTarget:self];
        [startButton setAction:@selector(startButtonClick:)];
        [view addSubview:startButton];
        [startMenuItem setView:view];
        
        // stop item
        NSMenuItem *stopMenuItem=[[NSMenuItem alloc] init];
        [stopMenuItem setTitle:MENU_MAIN_STOP_TITLE];
        stopSubMenu=[[NSMenu alloc] init];
        [stopMenuItem setSubmenu:stopSubMenu];
        
        // main item
        NSMenu *subMenu=[[NSMenu alloc] init];
        [subMenu addItem:startMenuItem];
        [subMenu addItem:stopMenuItem];
        [self setSubmenu:subMenu];
        [self setTitle:MENU_MAIN_TITLE];
    }
    return self;
}

#pragma mark - Property

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
    
    NSString *portString=[NSString stringWithFormat:@"%ld",(long)aPort];
    [portTextField setStringValue:portString];
//    [portTextField setIntegerValue:aPort];
}

#pragma mark - Action

- (void)startButtonClick:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(startButtonClick:port:)])
    {
        [delegate startButtonClick:sender port:[self port]];
    }
}

- (void)stopButtonClick:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(stopButtonClick:port:)])
    {
        NSMenuItem *clickMenuItem=sender;
        [delegate stopButtonClick:sender port:[[clickMenuItem title] integerValue]];
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

#pragma mark - Public Methods

- (void)addStopMenuItemWithPort:(NSInteger)aPort
{
    NSString *portString=[NSString stringWithFormat:@"%ld",(long)aPort];
    
    NSMenuItem *stopMenuItem=[[NSMenuItem alloc] initWithTitle:portString action:@selector(stopButtonClick:) keyEquivalent:portString];
    [stopMenuItem setTarget:self];
    [stopSubMenu addItem:stopMenuItem];
}

- (void)removeStopMenuItemWithPort:(NSInteger)aPort
{
    NSString *portString=[NSString stringWithFormat:@"%ld",(long)aPort];
    NSLog(@"port:%ld",aPort);
    NSInteger removeMenuItemIndex=[stopSubMenu indexOfItemWithTitle:portString];
    NSLog(@"removeMenuItemIndex:%ld",removeMenuItemIndex);
    [stopSubMenu removeItemAtIndex:removeMenuItemIndex];
}


@end
