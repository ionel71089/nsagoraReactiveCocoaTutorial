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
        UISlider *slider = self.sliders[i];
        UILabel *label = self.labels[i];
        
        RACSignal *sliderValueChanged = [slider rac_signalForControlEvents:UIControlEventValueChanged];
        
        RACSignal *sliderValue = [sliderValueChanged map:^id(UISlider *slider) {
            return @(slider.value);
        }];
        
        [sliderValue subscribeNext:^(NSNumber *value) {
            label.text = [NSString stringWithFormat:@"%.0f",value.floatValue];
        }];
        
        [sliderSignals addObject:sliderValue];
    }

    [[RACSignal combineLatest:sliderSignals] subscribeNext:^(RACTuple *values) {

        UIColor *color = [UIColor colorWithRed:((NSNumber*)values[0]).floatValue/255
                                         green:((NSNumber*)values[1]).floatValue/255
                                          blue:((NSNumber*)values[2]).floatValue/255
                                         alpha:1.0];
        self.tagColor.backgroundColor = color;
        
    }];

}

@end
