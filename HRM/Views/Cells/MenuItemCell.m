//
//  MenuItemCell.m
//  heartrate
//
//  Created by Jonathan Grana on 11/28/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "MenuItemCell.h"

#import "UIColor+HeartRate.h"
#import "UIView+Utility.h"

@implementation MenuItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.imageView.tintColor = selected ? [UIColor heartRateRed] : [UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    self.imageView.tintColor = highlighted ? [UIColor heartRateRed] : [UIColor whiteColor];
}

@end
