//
//  MemberPayTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberPayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;

+ (MemberPayTableViewCell *)shareMemberPayTableViewCell;
- (void)passwordTextFieldResignFirstResponder;

@end
