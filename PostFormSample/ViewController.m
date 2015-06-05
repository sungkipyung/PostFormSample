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

@property (weak, nonatomic) UITextView *textView;
@property (assign, nonatomic) CGFloat initialTextViewHeight;
@property (weak, nonatomic) NSLayoutConstraint *constraintTextViewHeight;

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) NSLayoutConstraint *constraintCollectionViewHeight;

@property (weak, nonatomic) UIScrollView *labelView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    [self.containerScrollView setBackgroundColor:[UIColor redColor]];
    self.containerScrollView.contentSize = CGSizeMake(screenWidth, screenHeight*2);
    
    // textView
    UITextView *textView = [[UITextView alloc] init];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.delegate = self;
    textView.scrollEnabled = NO;
    textView.backgroundColor = [UIColor yellowColor];
    
    
    // collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor blackColor];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // labelView
    UIScrollView *labelView = [[UIScrollView alloc] init];
    labelView.translatesAutoresizingMaskIntoConstraints = NO;
    labelView.backgroundColor = [UIColor greenColor];
    
    [self.containerScrollView addSubview:collectionView];self.collectionView = collectionView;
    [self.containerScrollView addSubview:textView];self.textView = textView;
    [self.containerScrollView addSubview:labelView];self.labelView = labelView;
    
    // layout
    CGFloat margin = 16;
    NSDictionary *viewDic = @{@"textView":textView, @"collectionView":collectionView, @"labelView":labelView};
    NSDictionary *metrics = @{@"margin":@(margin), @"width":@(screenWidth - 2 * margin)};
    
    _initialTextViewHeight = 30.0f;
    NSLayoutConstraint *constraintTextViewHeight
    = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_initialTextViewHeight];
    
    [self.textView addConstraint:constraintTextViewHeight];
    self.constraintTextViewHeight = constraintTextViewHeight;
    
    [self.containerScrollView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[textView]" options:0 metrics:metrics views:viewDic]];
    [self.containerScrollView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[textView(width)]-margin-|" options:0 metrics:metrics views:viewDic]];
    
    NSLayoutConstraint *constraintCollectionViewHeight
    = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
    [self.collectionView addConstraint:constraintCollectionViewHeight];
    self.constraintCollectionViewHeight = constraintCollectionViewHeight;
    
    [self.containerScrollView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[textView]-0-[collectionView]" options:0 metrics:metrics views:viewDic]];
    [self.containerScrollView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[collectionView(width)]-margin-|" options:0 metrics:metrics views:viewDic]];
    
//    NSLayoutConstraint *constraintLabelViewHeight
//    = [NSLayoutConstraint constraintWithItem:labelView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:14];
//    [self.collectionView addConstraint:constraintLabelViewHeight];
    
    [self.containerScrollView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[collectionView]-0-[labelView(14)]" options:0 metrics:metrics views:viewDic]];
    [self.containerScrollView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[labelView(width)]-margin-|" options:0 metrics:metrics views:viewDic]];
    
    [self p_hideCollectionView];
}

- (void)p_hideCollectionView
{
    self.constraintCollectionViewHeight.constant = 0.1;
    self.collectionView.hidden = YES;
}

- (void)p_showCollectionView
{
    self.constraintCollectionViewHeight.constant = 100;
    self.collectionView.hidden = NO;
}


- (IBAction)touchAppendButton:(id)sender
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
        self.textView.text = [self.textView.text stringByAppendingString:text];
        [self p_resizeTextView];
        NSLog(@"enter deteced");
        return NO;
    } else {
        self.textView.text = [self.textView.text stringByAppendingString:text];
        [self p_resizeTextView];
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self p_resizeTextView];
    NSLog(@"didChanged");
    [self scrollToCaretInTextView:self.textView animated:NO];
}

- (void)p_resizeTextView
{
    CGFloat height;
    if (self.textView.text.length == 0) {
        height = self.initialTextViewHeight;
    } else {
        const CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
        [self glw_sizeThatFitsByFixedWidth:mainScreenWidth - 32 withTextView:self.textView];
        height = self.textView.frame.size.height;
    }
    self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, height);
    self.containerScrollView.contentSize = CGSizeMake(self.containerScrollView.contentSize.width, height);
    [self.constraintTextViewHeight setConstant:height];
    
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated {
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}
- (IBAction)toggleCollectionView:(id)sender {
    if (self.collectionView.hidden) {
        [self p_showCollectionView];
    } else {
        [self p_hideCollectionView];
    }
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
