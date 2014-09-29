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
        
        RACSignal *signal = [slider rac_signalForControlEvents:UIControlEventValueChanged];
        
        [signal subscribeNext:^(UISlider *slider) {
            label.text = [NSString stringWithFormat:@"%.0f",slider.value];
        }];
        
        [sliderSignals addObject:signal];
    }

    [[RACSignal combineLatest:sliderSignals] subscribeNext:^(RACTuple *sliders) {
        
        NSMutableArray *values = [NSMutableArray array];
        for (UISlider *slider in sliders) {
            [values addObject:@(slider.value)];
        }
        
        CGFloat red     = [values[0] floatValue];
        CGFloat green   = [values[1] floatValue];
        CGFloat blue    = [values[2] floatValue];
        CGFloat alpha   = 1.0;
        
        UIColor *color = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
        self.tagColor.backgroundColor = color;
        
    }];

}

@end
