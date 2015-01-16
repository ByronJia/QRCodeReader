//
//  QRCodeReader.h
//  appleScan
//
//  Created by Byron on 14/12/25.
//  Copyright (c) 2014年 byron. All rights reserved.
//
#import <UIKit/UIKit.h>
@class QRCodeReaderController;
@protocol QRCodeReaderControllerDelegate <NSObject>

- (void)QRCodeReaderController:(QRCodeReaderController *)readerController didScanResult:(NSString *)result;

@end
@interface QRCodeReaderController : UIViewController

@property (nonatomic, weak) id<QRCodeReaderControllerDelegate> delegate;

/**
 *  扫描完成,关闭扫描
 */
@property (nonatomic, assign,getter=isStopScan) BOOL stopScan;


/**
 *  扫描完成,界面定格在二维码上
 */
@property (nonatomic, assign,getter=isLastScanImage) BOOL lastScanImage;
@end
