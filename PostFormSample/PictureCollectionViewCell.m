//
//  PictureCollectionViewCell.m
//  PostFormSample
//
//  Created by 성기평 on 2015. 6. 5..
//  Copyright (c) 2015년 hothead. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5;
}

- (IBAction)touchClosebutton:(id)sender {
    [self.delegate pictureCollectionViewCellDiddDleteButtonPressed:self];
}
@end
