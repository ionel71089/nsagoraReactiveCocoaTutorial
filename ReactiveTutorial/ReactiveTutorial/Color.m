//
//  Color.m
//  ReactiveTutorial
//
//  Created by Ionel Lescai on 29/09/14.
//  Copyright (c) 2014 Cynny Social Cloud. All rights reserved.
//

#import "Color.h"

@implementation Color

-(instancetype)init
{
    self        = [super init];
    self.red    = @(0);
    self.green  = @(0);
    self.blue   = @(0);
    return self;
}

+(Color *)shadeOfGray
{
    Color *color = [Color new];
    
    color.red   = @(128);
    color.green = @(128);
    color.blue  = @(128);
    
    return color;
}

+(Color*)randomColor
{
    Color *color = [Color new];
    
    color.red   = @(arc4random_uniform(255));
    color.green = @(arc4random_uniform(255));
    color.blue  = @(arc4random_uniform(255));
    
    return color;
}

+(Color *)rozBomBon
{
    Color *color = [Color new];
    
    color.red   = @(242);
    color.green = @(119);
    color.blue  = @(176);
    
    return color;
}

-(NSNumber*)objectAtIndexedSubscript:(NSUInteger)idx;
{
    assert(0 <= idx < 3);
    
    switch (idx)
    {
        case 0:
            return self.red;
            
        case 1:
            return self.green;
            
        case 2:
            return self.blue;
    }
    
    return nil;
}

@end
