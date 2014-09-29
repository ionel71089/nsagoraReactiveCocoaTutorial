//
//  Color.h
//  ReactiveTutorial
//
//  Created by Ionel Lescai on 29/09/14.
//  Copyright (c) 2014 Cynny Social Cloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Color : NSObject

@property NSNumber *red;
@property NSNumber *green;
@property NSNumber *blue;

+(Color*)shadeOfGray;
+(Color*)randomColor;
+(Color*)rozBomBon;

-(NSNumber*)objectAtIndexedSubscript:(NSUInteger)idx;

@end
