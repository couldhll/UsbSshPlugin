//
//  UsbSshMenuItem.h
//  UsbSshPlugin
//
//  Created by CouldHll on 14-3-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol UsbSshMenuItemDelegate <NSObject>
@optional
- (void)startButtonClick:(id)sender;
@end

@interface UsbSshMenuItem : NSMenuItem

@property (nonatomic, assign) id<UsbSshMenuItemDelegate> delegate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger port;

@property (nonatomic, strong) NSTextField *titleTextField;
@property (nonatomic, strong) NSTextField *portTextField;
@property (nonatomic, strong) NSButton *startButton;

@end
