//
//  QRCodeView.m
//  appleScan
//
//  Created by Byron on 14/12/25.
//  Copyright (c) 2014年 byron. All rights reserved.
//
#import "QRCodeView.h"
@interface QRCodeView ()

@property (nonatomic, assign) CGRect offsetRect;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation QRCodeView

- (void)addBorder
{
    UIImageView *border = [[UIImageView alloc]initWithFrame:_offsetRect];
    border.image = [UIImage imageNamed:@"image_scan_window.png"];
    [self addSubview:border];
    
}
-(void)startAnimationView
{
    UIImageView *line = [[UIImageView alloc] initWithFrame: CGRectMake(_offsetRect.origin.x, _offsetRect.origin.y, _offsetRect.size.width, 2)];
    line.image = [UIImage imageNamed:@"scan.png"];
    [self addSubview:line];
    line.tag = 100000;
    [UIView animateWithDuration:2.5f delay:0 options:UIViewAnimationOptionRepeat animations:^{
        line.frame = CGRectMake(_offsetRect.origin.x, _offsetRect.origin.y+_offsetRect.size.height-2, _offsetRect.size.width, 2);
    } completion:^(BOOL finished) {
        line.frame = CGRectMake(_offsetRect.origin.x, _offsetRect.origin.y, _offsetRect.size.width, 2);
    }];
}

- (void)addCoverView
{
    CGRect cover1Rect = CGRectMake(0, 0, self.bounds.size.width, CGRectGetMinY(_offsetRect));
    UIView *cover1 = [[UIView alloc]initWithFrame:cover1Rect];
    cover1.backgroundColor = [UIColor blackColor];
    cover1.alpha = 0.6;
    [self addSubview:cover1];
    
    CGRect cover2Rect = CGRectMake(0, CGRectGetMinY(_offsetRect), CGRectGetMinX(_offsetRect), CGRectGetHeight(_offsetRect));
    UIView *cover2 = [[UIView alloc]initWithFrame:cover2Rect];
    cover2.backgroundColor = [UIColor blackColor];
    cover2.alpha = 0.6;
    [self addSubview:cover2];
    
    CGRect cover3Rect = CGRectMake(CGRectGetMaxX(_offsetRect), CGRectGetMinY(_offsetRect), CGRectGetMinX(_offsetRect), CGRectGetHeight(_offsetRect));
    UIView *cover3 = [[UIView alloc]initWithFrame:cover3Rect];
    cover3.backgroundColor = [UIColor blackColor];
    cover3.alpha = 0.6;
    [self addSubview:cover3];
    
    CGRect cover4Rect = CGRectMake(0, CGRectGetMaxY(_offsetRect), self.bounds.size.width,self.bounds.size.height - CGRectGetMaxY(_offsetRect));
    UIView *cover4 = [[UIView alloc]initWithFrame:cover4Rect];
    cover4.backgroundColor = [UIColor blackColor];
    cover4.alpha = 0.6;
    [self addSubview:cover4];
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_offsetRect)+20 , [UIScreen mainScreen].bounds.size.width, 50)];
    _tipLabel.text = @"请将二维码置于方框内";
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.textColor = [UIColor whiteColor];
    [self addSubview:_tipLabel];
}
- (void)drawRect:(CGRect)rect
{
    CGRect innerRect = CGRectInset(rect, 30, 30);
    
    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
    if (innerRect.size.width != minSize) {
        innerRect.origin.x   += (innerRect.size.width - minSize) / 2;
        innerRect.size.width = minSize;
    }
    else if (innerRect.size.height != minSize) {
        innerRect.origin.y    += (innerRect.size.height - minSize) / 2;
        innerRect.size.height = minSize;
    }
    
    CGRect offsetRect = CGRectOffset(innerRect, 0, 15);
    
    _offsetRect = offsetRect;
    
    [self addBorder];
    [self addCoverView];
    [self startAnimationView];
}

@end
