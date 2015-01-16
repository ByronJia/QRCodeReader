//
//  ViewController.m
//  JCNQRCodeReaderDemo
//
//  Created by Byron on 15/1/16.
//  Copyright (c) 2015年 byron. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeReaderController.h"
@interface ViewController ()<QRCodeReaderControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    QRCodeReaderController *qr = [QRCodeReaderController new];
    qr.delegate = self;
    qr.stopScan = YES;
    qr.lastScanImage = YES;
    [self.navigationController pushViewController:qr animated:YES];
}

- (void)QRCodeReaderController:(QRCodeReaderController *)readerController didScanResult:(NSString *)result
{
    NSLog(@"%@",result);
    
}
@end
