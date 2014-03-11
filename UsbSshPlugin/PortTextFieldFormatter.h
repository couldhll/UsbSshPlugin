//
//  PortTextFieldFormatter.h
//  UsbSshPlugin
//
//  Created by CouldHll on 14-3-10.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PortTextFieldFormatter : NSFormatter

@property (nonatomic, assign) NSInteger minLength;
@property (nonatomic, assign) NSInteger maxLength;

@end