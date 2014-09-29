//
//  ViewController.m
//  ReactiveTutorial
//
//  Created by Ionel Lescai on 05/09/14.
//  Copyright (c) 2014 Cynny Social Cloud. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

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
    
    self.tagColor.layer.borderColor = [UIColor blackColor].CGColor;
    self.tagColor.layer.borderWidth = 1.0;
    
    [self bind];
}

-(void)bind
{
    // what value should the sliders be ?
    RAC(((UISlider*)self.sliders[0]),value) = RACObserve(self.color, red);
    RAC(((UISlider*)self.sliders[1]),value) = RACObserve(self.color, green);
    RAC(((UISlider*)self.sliders[2]),value) = RACObserve(self.color, blue);
    
    // what value should that textfields be ?
    RAC(((UITextField*)self.textFields[0]),text) = [RACObserve(self.color, red) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%.0f",value.floatValue];
    }];
    RAC(((UITextField*)self.textFields[1]),text) = [RACObserve(self.color, green) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%.0f",value.floatValue];
    }];
    RAC(((UITextField*)self.textFields[2]),text) = [RACObserve(self.color, blue) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%.0f",value.floatValue];
    }];
    
    // what should happen when the sliders change ?
    NSMutableArray *sliderSignals   = [NSMutableArray array];
    NSMutableArray *textSignals     = [NSMutableArray array];
    
    for(int i=0;i<3;i++)
    {
        // what should happen when the sliders change ?
        [sliderSignals addObject:[[[self.sliders[i] rac_signalForControlEvents:UIControlEventValueChanged] map:^id(UISlider *slider) {
            return @(slider.value);
        }] doNext:^(id x) {
            ((UITextField*)self.textFields[i]).backgroundColor = [UIColor clearColor];
            [self.view endEditing:YES];
        }]];
     
        // what should happend when the textfields change ?
        [textSignals addObject:[[[self.textFields[i] rac_textSignal] filter:^BOOL(NSString* text) {
            return [self textIsValidSliderValue:text];
        }] map:^id(NSString* value) {
            return @(value.intValue);
        }]];
        
        //what if the text is not valid ?
        RAC(((UITextField*)self.textFields[i]),backgroundColor) = [[self.textFields[i] rac_textSignal] map:^id(NSString *text) {
            return [self textIsValidSliderValue:text] ? [UIColor clearColor] : [UIColor yellowColor];
        }];
    }
    
    // what color should the square be ?
    RAC(self.tagColor,backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.color, red),RACObserve(self.color, green),RACObserve(self.color, blue)]
                      reduce:^id(NSNumber *red,NSNumber *green,NSNumber *blue){
                          return [UIColor colorWithRed:red.floatValue/255
                                                 green:green.floatValue/255
                                                  blue:blue.floatValue/255
                                                 alpha:1.0];
    }];

    // what values should the view model have ?
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
