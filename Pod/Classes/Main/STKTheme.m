/****************************************************************************
 *
 * Copyright 2015-present StylingKit Development Team. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ****************************************************************************/
//
// Created by Anton Matosov on 1/18/16.
//

#import <StylingKit/PXStylesheet.h>
#import "STKTheme.h"
#import "PXStylesheet-Private.h"

@implementation STKTheme

- (instancetype)initWithName:(NSString*)name
          stylesheetFileName:(NSString*)stylesheetFileName
                      bundle:(NSBundle*)bundle
{
    self = [super init];
    if (self)
    {
        _name = name;
        _stylesheetFileName = stylesheetFileName.length ? stylesheetFileName : @"default";
        _bundle = bundle;
        _origin = PXStylesheetOriginApplication;
    }

    return self;
}

+ (instancetype)themeWithName:(NSString*)name
           stylesheetFileName:(NSString*)stylesheetFileName
                       bundle:(NSBundle*)bundle
{
    return [[self alloc] initWithName:name
                   stylesheetFileName:stylesheetFileName
                               bundle:bundle];
}

+ (instancetype)themeWithName:(NSString*)name
                       bundle:(NSBundle*)bundle
{
    return [[self alloc] initWithName:name
                   stylesheetFileName:nil
                               bundle:bundle];
}

- (void)activate
{
    NSString* path = [self.bundle pathForResource:self.stylesheetFileName
                                           ofType:@"css"];

    if (path.length > 0)
    {
        [PXStylesheet styleSheetFromFilePath:path
                                  withOrigin:(PXStylesheetOrigin)self.origin];
    }
    else if (!self.optional)
    {
        DDLogWarn(@"Stylesheet \"%@.css\" for theme \"%@\" not found in bundle \"%@\"",
                  self.stylesheetFileName,
                  self.name,
                  self.bundle.bundlePath.lastPathComponent);
    }
}

@end
