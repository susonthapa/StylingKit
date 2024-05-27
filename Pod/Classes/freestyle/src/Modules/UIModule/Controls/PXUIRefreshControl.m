/*
 * Copyright 2012-present Pixate, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  PXUIRefreshControl.m
//  Pixate
//
//  Created by Paul Colton on 12/12/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import "PXUIRefreshControl.h"
#import "UIView+PXStyling.h"
#import "UIView+PXStyling-Private.h"
#import "PXStylingMacros.h"

#import "PXOpacityStyler.h"
#import "PXPaintStyler.h"
#import "PXColorStyler.h"
#import "PXTransformStyler.h"
#import "PXAnimationStyler.h"

@implementation PXUIRefreshControl

+ (void)initialize
{
    if (self != PXUIRefreshControl.class)
        return;
    
    [UIView registerDynamicSubclass:self withElementName:@"refresh-control"];
}

- (NSArray *)viewStylers
{
    static __strong NSArray *stylers = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        stylers = @[
            PXTransformStyler.sharedInstance,
            PXOpacityStyler.sharedInstance,

            [[PXPaintStyler alloc] initWithCompletionBlock:^(id<PXStyleable> styleable, PXPaintStyler *styler, PXStylerContext *context) {
                if ([styleable isKindOfClass:[PXUIRefreshControl class]]) {
                    PXUIRefreshControl *view = (PXUIRefreshControl *)styleable;
                    
                    UIColor *color = (UIColor *)[context propertyValueForName:@"color"];
                    
                    if (color == nil) {
                        color = (UIColor *)[context propertyValueForName:@"-ios-tint-color"];
                    }
                    
                    if (color) {
                        [view px_setTintColor:color];
                    }
                }
            }],

            PXAnimationStyler.sharedInstance,
        ];
    });

    return stylers;
}

- (NSDictionary *)viewStylersByProperty
{
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        map = [PXStyleUtils viewStylerPropertyMapForStyleable:self];
    });

    return map;
}

PX_WRAP_1(setTintColor, color);

// Overrides

PX_LAYOUT_SUBVIEWS_OVERRIDE_RECURSIVE

@end
