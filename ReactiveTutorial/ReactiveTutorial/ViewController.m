//
//  ViewController.m
//  ReactiveTutorial
//
//  Created by Ionel Lescai on 05/09/14.
//  Copyright (c) 2014 Cynny Social Cloud. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *tagColor;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@property Color *color;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.color = [Color randomColor];
    self.tagColor.layer.borderWidth = 1.0;
    
    [self bind];
}

-(void)bind
{
    NSMutableArray *sliderSignals   = [NSMutableArray array];
    NSMutableArray *textSignals     = [NSMutableArray array];
    
    for(int i=0;i<3;i++)
    {
        RAC(((UISlider*)self.sliders[i]),value) = self.color[i];
     
        RAC(((UITextField*)self.textFields[i]),text) = [self.color[i] map:^id(NSNumber *value) {
            return [NSString stringWithFormat:@"%.0f",value.floatValue];
        }];
        
        [sliderSignals addObject:[[[self.sliders[i] rac_signalForControlEvents:UIControlEventValueChanged] map:^id(UISlider *slider) {
            return @(slider.value);
        }] doNext:^(id x) {
            ((UITextField*)self.textFields[i]).backgroundColor = [UIColor clearColor];
            [self.view endEditing:YES];
        }]];
        
        [textSignals addObject:[[[self.textFields[i] rac_textSignal] filter:^BOOL(NSString* text) {
            return [self textIsValidSliderValue:text];
        }] map:^id(NSString* value) {
            return @(value.intValue);
        }]];
        
        RAC(((UITextField*)self.textFields[i]),backgroundColor) = [[self.textFields[i] rac_textSignal] map:^id(NSString *text) {
            return [self textIsValidSliderValue:text] ? [UIColor clearColor] : [UIColor yellowColor];
        }];
    }
    
    RAC(self.tagColor,backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.color, red),RACObserve(self.color, green),RACObserve(self.color, blue)]
                      reduce:^id(NSNumber *red,NSNumber *green,NSNumber *blue){
                          return [UIColor colorWithRed:red.floatValue/255
                                                 green:green.floatValue/255
                                                  blue:blue.floatValue/255
                                                 alpha:1.0];
    }];
    
    RAC(self.color,red)     = [RACSignal merge:@[sliderSignals[0],textSignals[0]]];
    RAC(self.color,green)   = [RACSignal merge:@[sliderSignals[1],textSignals[1]]];
    RAC(self.color,blue)    = [RACSignal merge:@[sliderSignals[2],textSignals[2]]];
}

-(BOOL)textIsValidSliderValue:(NSString*)text
{
    NSScanner *scan = [NSScanner scannerWithString: text];
    int holder;
    return [scan scanInt: &holder] && [scan isAtEnd] && (0 <= holder && holder <= 255);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
