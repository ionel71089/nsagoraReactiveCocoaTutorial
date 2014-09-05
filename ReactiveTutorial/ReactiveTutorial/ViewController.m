//
//  ViewController.m
//  ReactiveTutorial
//
//  Created by Ionel Lescai on 05/09/14.
//  Copyright (c) 2014 Cynny Social Cloud. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *tagColor;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@property NSMutableArray *colors;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tagColor.layer.borderColor = [UIColor blackColor].CGColor;
    self.tagColor.layer.borderWidth = 1.0;
    
    self.colors = [@[@(0.5),@(0.5),@(0.5)] mutableCopy];
    [self setTagColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChanged:(UISlider*)slider
{
    self.colors[slider.tag] = @(slider.value);
    ((UILabel*)self.labels[slider.tag]).text = [NSString stringWithFormat:@"%.2f",slider.value];
    [self setTagColor];
}

-(void)setTagColor
{
    CGFloat red = [self.colors[0] floatValue];
    CGFloat green = [self.colors[1] floatValue];
    CGFloat blue = [self.colors[2] floatValue];
    CGFloat alpha = 1.0;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    self.tagColor.backgroundColor = color;
}

@end
