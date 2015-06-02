//
//  ViewController.m
//  PostFormSample
//
//  Created by 성기평 on 2015. 6. 1..
//  Copyright (c) 2015년 hothead. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (weak, nonatomic) UITextView *textViewContent;
@property (assign, nonatomic) CGFloat initialTextViewHeight;
@property (weak, nonatomic) NSLayoutConstraint *constraintContainerHeight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _initialTextViewHeight = 30.0f;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    [self.containerScrollView setBackgroundColor:[UIColor redColor]];
    self.containerScrollView.contentSize = CGSizeMake(screenWidth, screenHeight*2);
    
    UITextView *textView = [[UITextView alloc] init];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.delegate = self;
    textView.scrollEnabled = NO;
    textView.backgroundColor = [UIColor yellowColor];
    
    CGFloat margin = 16;
    NSDictionary *viewDic = @{@"textView":textView};
    NSDictionary *metrics = @{@"textViewMargin":@(margin), @"textViewWidth":@(screenWidth - 2 * margin), @"textViewDefaultHeight":@30};
    
    CGFloat height = 30.0f;
    [self.containerScrollView addSubview:textView];
    self.textViewContent = textView;
    
    NSLayoutConstraint *constraintContainerHeight
    = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    [self.textViewContent addConstraint:constraintContainerHeight];
    self.constraintContainerHeight = constraintContainerHeight;
    
    [self.containerScrollView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[textView]" options:0 metrics:metrics views:viewDic]];
    [self.containerScrollView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[textView(textViewWidth)]-16-|" options:0 metrics:metrics views:viewDic]];
}

-(IBAction)touchAppendButton:(id)sender
{
    UIView *upperView = self.containerScrollView.subviews.firstObject;
    
    if (upperView) {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view setBackgroundColor:[UIColor blackColor]];
        [self.containerScrollView addSubview:view];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        NSDictionary *viewDic = @{@"me":view, @"upperView":upperView};
        NSDictionary *metrics = @{@"width":@(screenWidth - 32)};
        
        
        [self.containerScrollView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:[upperView]-16-[me(30)]" options:0 metrics:nil views:viewDic]];
        [self.containerScrollView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[me(width)]-16-|" options:0 metrics:metrics views:viewDic]];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length == 0) {
        return YES;
    }
    if ([text isEqualToString:@"\n"]) {
        self.textViewContent.text = [self.textViewContent.text stringByAppendingString:text];
        [self p_resizeTextView];
        NSLog(@"enter deteced");
        return NO;
    } else {
        self.textViewContent.text = [self.textViewContent.text stringByAppendingString:text];
        [self p_resizeTextView];
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self p_resizeTextView];
    NSLog(@"didChanged");
    [self scrollToCaretInTextView:self.textViewContent animated:NO];
}

- (void)p_resizeTextView
{
    CGFloat height;
    if (self.textViewContent.text.length == 0) {
        height = self.initialTextViewHeight;
    } else {
        const CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
        [self glw_sizeThatFitsByFixedWidth:mainScreenWidth - 32 withTextView:self.textViewContent];
        height = self.textViewContent.frame.size.height;
    }
    self.textViewContent.frame = CGRectMake(self.textViewContent.frame.origin.x, self.textViewContent.frame.origin.y, self.textViewContent.frame.size.width, height);
    self.containerScrollView.contentSize = CGSizeMake(self.containerScrollView.contentSize.width, height);
    [self.constraintContainerHeight setConstant:height];
    
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated {
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

- (void)glw_sizeThatFitsByFixedWidth:(CGFloat)fixedWidth withTextView:(UITextView *)textView
{
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    
    const CGFloat MAX_HEIGHT = [UIScreen mainScreen].bounds.size.height - 16;
//    if (newSize.height > MAX_HEIGHT / 2) {
//        textView.contentSize = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    } else {
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        textView.frame = newFrame;
//    }
    
}

@end
