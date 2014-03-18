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
@property (nonatomic, strong) UsbSshMenuItem *menuItem;
@property (nonatomic, strong) NSMutableDictionary *tasks;

@end

@implementation UsbSshPlugin

+ (void)pluginDidLoad:(NSBundle *)plugin
{
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
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
        
        // Create menu items, initialize UI, etc.
        NSMenuItem *parentMenuItem = [[NSApp mainMenu] itemWithTitle:@"Debug"];
        if (parentMenuItem)
        {
            [[parentMenuItem submenu] addItem:[NSMenuItem separatorItem]];

            self.menuItem = [[UsbSshMenuItem alloc] init];
            [self.menuItem setPort:DEFAULT_PORT];
            [self.menuItem setDelegate:self];
            
            [[parentMenuItem submenu] addItem:self.menuItem];
        }
        
        self.tasks=[NSMutableDictionary dictionary];
    }
    return self;
}

- (void)start:(NSInteger)port
{
    NSString *portString=[NSString stringWithFormat:@"%ld",(long)port];
    
    // start usb ssh
    NSString *cmd = [self.bundle pathForResource:@"usbmuxd-1.0.8/python-client/tcprelay" ofType:@"py"];
    NSTask *task=[self.tasks objectForKey:portString];
    if (task==nil)
    {
        task=[[NSTask alloc] init];
        [task setLaunchPath:@"/usr/bin/python"];
        [task setArguments:@[cmd,@"-t",[NSString stringWithFormat:@"22:%@", portString]]];
        [task launch];
        
        [self.tasks setObject:task forKey:portString];
        
        // menu
        [self.menuItem addStopMenuItemWithPort:port];
        
        // alert
        NSString *show=[NSString stringWithFormat:@"Please run \"ssh root@localhost -p%ld\" in terminal.", (long)port];
        NSAlert *alert = [NSAlert alertWithMessageText:show defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
    }
}

- (void)stop:(NSInteger)port
{
    NSString *portString=[NSString stringWithFormat:@"%ld",(long)port];
    
    // stop usb ssh
    NSTask *task=[self.tasks objectForKey:portString];
    [task interrupt];
    [task terminate];
    
    [self.tasks removeObjectForKey:portString];
    
    // menu
    [self.menuItem removeStopMenuItemWithPort:port];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // stop all tasks
    for(NSString *portString in [self.tasks allKeys])
    {
        NSInteger port=[portString integerValue];
        [self stop:port];
    }
}

#pragma mark - UsbSshMenuItemDelegate

- (void)startButtonClick:(id)sender port:(NSInteger)port
{
    [self start:port];
}

- (void)stopButtonClick:(id)sender port:(NSInteger)port
{
    [self stop:port];
}

@end
