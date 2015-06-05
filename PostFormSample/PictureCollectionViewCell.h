//
//  PictureCollectionViewCell.h
//  PostFormSample
//
//  Created by 성기평 on 2015. 6. 5..
//  Copyright (c) 2015년 hothead. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PictureCollectionViewCell;
@protocol PictureCollectionViewCellDelegate
- (void)pictureCollectionViewCellDiddDleteButtonPressed:(PictureCollectionViewCell*)cell;
@end

@interface PictureCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) id<PictureCollectionViewCellDelegate> delegate;
- (IBAction)touchClosebutton:(id)sender;

@end
