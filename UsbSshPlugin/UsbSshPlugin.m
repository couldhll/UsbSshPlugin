//
//  UsbSshPlugin.m
//  UsbSshPlugin
//
//  Created by CouldHll on 14-3-10.
//    Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "UsbSshPlugin.h"
#import "UsbSshMenuItem.h"
#import "Const.h"

static UsbSshPlugin *sharedPlugin;

@interface UsbSshPlugin() <UsbSshMenuItemDelegate>

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSTask *task;
@property (nonatomic, strong) UsbSshMenuItem *menuItem;

@end

@implementation UsbSshPlugin

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSLog(@"UsbSshPlugin pluginDidLoad.");
    
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init])
    {
        NSLog(@"UsbSshPlugin initWithBundle.");
        
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
        
        // Create menu items, initialize UI, etc.
        NSMenuItem *parentMenuItem = [[NSApp mainMenu] itemWithTitle:@"Debug"];
        if (parentMenuItem) {
            NSLog(@"UsbSshPlugin parentMenuItem.");
            [[parentMenuItem submenu] addItem:[NSMenuItem separatorItem]];
//            self.menuItem = [[NSMenuItem alloc] initWithTitle:@"aaaaaa" action:nil keyEquivalent:nil];
            self.menuItem = [[UsbSshMenuItem alloc] init];
            [self.menuItem setTitle:MENU_LABEL_TITLE];
            [self.menuItem setPort:DEFAULT_PORT];
            [self.menuItem setDelegate:self];
            [[parentMenuItem submenu] addItem:self.menuItem];
        }
    }
    return self;
}

- (void)start:(NSInteger)port
{
    NSLog(@"UsbSshPlugin start.");
    
    // start usb ssh
    NSString *cmd = [self.bundle pathForResource:@"usbmuxd-1.0.8/python-client/tcprelay" ofType:@"py"];
    NSTask*task=[[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/python"];
    [task setArguments:@[cmd,@"-t",[NSString stringWithFormat:@"22:%ld", (long)port]]];
    self.task=task;
    [self.task launch];
    
    // alert
    NSString *show=[NSString stringWithFormat:@"Please run \"ssh root@localhost -p%ld\" in terminal.", (long)port];
    NSAlert *alert = [NSAlert alertWithMessageText:show defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [alert runModal];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UsbSshMenuItemDelegate

- (void)startButtonClick:(id)sender
{
    [self start:self.menuItem.port];
}

@end
