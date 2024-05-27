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
//  PXUISearchBar.m
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Paul Colton on 10/11/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import "PXUISearchBar.h"

#import "UIView+PXStyling.h"
#import "UIView+PXStyling-Private.h"
#import "PXStylingMacros.h"

#import "PXOpacityStyler.h"
#import "PXLayoutStyler.h"
#import "PXTransformStyler.h"
#import "PXFillStyler.h"
#import "PXBoxShadowStyler.h"
#import "PXTextContentStyler.h"
#import "PXGenericStyler.h"
#import "PXAnimationStyler.h"
#import "PXTextShadowStyler.h"
#import "PXUtils.h"

@implementation PXUISearchBar

+ (void)initialize
{
    if (self != PXUISearchBar.class)
        return;
    
    [UIView registerDynamicSubclass:self withElementName:@"search-bar"];
}

- (NSArray *)viewStylers
{
    static __strong NSArray *stylers = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        stylers = @[
            PXTransformStyler.sharedInstance,
            PXLayoutStyler.sharedInstance,

            [[PXOpacityStyler alloc] initWithCompletionBlock:^(id<PXStyleable> styleable, PXOpacityStyler *styler, PXStylerContext *context) {
                if ([styleable isKindOfClass:[PXUISearchBar class]]) {
                    PXUISearchBar *view = (PXUISearchBar *)styleable;
                    [view px_setTranslucent:(context.opacity < 1.0) ? YES : NO];
                }
            }],

            PXFillStyler.sharedInstance,
            PXBoxShadowStyler.sharedInstance,

            [[PXTextShadowStyler alloc] initWithCompletionBlock:^(id<PXStyleable> styleable, PXTextShadowStyler *styler, PXStylerContext *context) {
                if ([styleable isKindOfClass:[PXUISearchBar class]]) {
                    PXUISearchBar *view = (PXUISearchBar *)styleable;
                    PXShadow *shadow = context.textShadow;
                    NSMutableDictionary *currentTextAttributes = [NSMutableDictionary dictionaryWithDictionary:[view scopeBarButtonTitleTextAttributesForState:UIControlStateNormal]];

                    NSShadow *nsShadow = [[NSShadow alloc] init];
                    nsShadow.shadowColor = shadow.color;
                    nsShadow.shadowOffset = CGSizeMake(shadow.horizontalOffset, shadow.verticalOffset);
                    nsShadow.shadowBlurRadius = shadow.blurDistance;

                    currentTextAttributes[NSShadowAttributeName] = nsShadow;

                    [view px_setScopeBarButtonTitleTextAttributes:currentTextAttributes forState:UIControlStateNormal];
                }
            }],

            [[PXTextContentStyler alloc] initWithCompletionBlock:^(id<PXStyleable> styleable, PXTextContentStyler *styler, PXStylerContext *context) {
                if ([styleable isKindOfClass:[PXUISearchBar class]]) {
                    PXUISearchBar *view = (PXUISearchBar *)styleable;
                    [view px_setText:context.text];
                }
            }],

            [[PXGenericStyler alloc] initWithHandlers: @{
                @"-ios-tint-color" : ^(PXDeclaration *declaration, PXStylerContext *context) {
                    if ([context.styleable isKindOfClass:[PXUISearchBar class]]) {
                        PXUISearchBar *view = (PXUISearchBar *)context.styleable;
                        UIColor *color = declaration.colorValue;
                        [view px_setTintColor:color];
                    }
                },

                @"color" : ^(PXDeclaration *declaration, PXStylerContext *context) {
                    if ([context.styleable isKindOfClass:[PXUISearchBar class]]) {
                        PXUISearchBar *view = (PXUISearchBar *)context.styleable;
                        UIColor *color = declaration.colorValue;
                        [view px_setTintColor:color];
                    }
                },

                @"bar-style" : ^(PXDeclaration *declaration, PXStylerContext *context) {
                    if ([context.styleable isKindOfClass:[PXUISearchBar class]]) {
                        PXUISearchBar *view = (PXUISearchBar *)context.styleable;
                        NSString *style = (declaration.stringValue).lowercaseString;

                        if ([style isEqualToString:@"black"]) {
                            [view px_setBarStyle:UIBarStyleBlack];
                        } else { // Default to UIBarStyleDefault
                            [view px_setBarStyle:UIBarStyleDefault];
                        }
                    }
                },
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

- (void)updateStyleWithRuleSet:(PXRuleSet *)ruleSet context:(PXStylerContext *)context
{
    // Background color setting
    if([PXUtils isIOS7OrGreater])
    {
        if (context.color)
        {
            [self px_setBarTintColor: context.color];
        }
        else if (context.usesImage)
        {
            [self px_setBarTintColor: [UIColor colorWithPatternImage:context.backgroundImage]];
        }
    }
    else
    {
        if (context.color)
        {
            [self px_setTintColor: context.color];
        }
        else if (context.usesImage)
        {
            [self px_setTintColor: [UIColor colorWithPatternImage:context.backgroundImage]];
        }
    }
}

PX_PXWRAP_1(setText, text);

PX_WRAP_1(setBarTintColor, color);
PX_WRAP_1(setTintColor, color);
PX_WRAP_1b(setTranslucent, flag);
PX_WRAP_1v(setBarStyle, UIBarStyle, style);
PX_WRAP_2v(setScopeBarButtonTitleTextAttributes, attrs, forState, UIControlState, state);

PX_LAYOUT_SUBVIEWS_OVERRIDE

@end
