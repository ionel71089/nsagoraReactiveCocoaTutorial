//
//  ViewController.m
//  ReactiveTutorial
//
//  Created by Ionel Lescai on 05/09/14.
//  Copyright (c) 2014 Cynny Social Cloud. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *tagColor;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tagColor.layer.borderColor = [UIColor blackColor].CGColor;
    self.tagColor.layer.borderWidth = 1.0;
    
    [self bind];
}

-(void)bind
{
    NSMutableArray *sliderSignals = [NSMutableArray array];
    
    for (int i = 0; i<3; i++) {
        
        RACSignal *sliderValue = [[self.sliders[i] rac_signalForControlEvents:UIControlEventValueChanged] map:^id(UISlider *slider) {
            return @(slider.value);
        }];
        
        RAC(((UILabel*)self.labels[i]),text) = [sliderValue map:^id(NSNumber *value) {
            return [NSString stringWithFormat:@"%.0f",value.floatValue];
        }];
        
        [sliderSignals addObject:sliderValue];
        
    }
    
    RAC(self.tagColor,backgroundColor) = [RACSignal combineLatest:sliderSignals reduce:^id(NSNumber *red,NSNumber *green,NSNumber *blue){
        return [UIColor colorWithRed:red.floatValue/255
                               green:green.floatValue/255
                                blue:blue.floatValue/255
                               alpha:1.0];
    }];

}

@end
