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

-(instancetype)initWithViewModel:(Color *)color
{
    // TODO: learn how to initialize a view controller when using storyboards :)
    self = [super init];
    self.color = color;
    return self;
}

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
    NSMutableArray *sliderSignals = [NSMutableArray array];
    
    for (int i = 0; i<3; i++) {
        
        UISlider *slider = self.sliders[i];
        UITextField *textField = self.textFields[i];
        slider.value = self.color[i].intValue;
        
        RACSignal *sliderValue = [[[[slider rac_signalForControlEvents:UIControlEventValueChanged] map:^id(UISlider *slider) {
            return @(slider.value);
        }] startWith:@(slider.value)] doNext:^(id x) {
            textField.backgroundColor = [UIColor clearColor];
        }];
        
        [sliderSignals addObject:sliderValue];
        
        RAC(textField,text) = [sliderValue map:^id(NSNumber *value) {
            return [NSString stringWithFormat:@"%.0f",value.floatValue];
        }];
        
        RACSignal *textSignal = textField.rac_textSignal;
        
        RAC(textField,backgroundColor) = [textSignal map:^id(NSString *text) {
            return [self textIsValidSliderValue:text] ? [UIColor clearColor] : [UIColor yellowColor];
        }];
        
        RAC(slider,value) = [[textSignal filter:^BOOL(NSString *text) {
            return [self textIsValidSliderValue:text];
        }] map:^id(NSString *text) {
            return @(text.integerValue);
        }];
        
    }
    
    RAC(self.tagColor,backgroundColor) = [[RACSignal combineLatest:sliderSignals reduce:^id(NSNumber *red,NSNumber *green,NSNumber *blue){
        return [UIColor colorWithRed:red.floatValue/255
                               green:green.floatValue/255
                                blue:blue.floatValue/255
                               alpha:1.0];
    }] doNext:^(id x) {
        [self.view endEditing:YES];
    }];
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
