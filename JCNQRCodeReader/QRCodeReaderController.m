//
//  QRCodeReader.m
//  appleScan
//
//  Created by Byron on 14/12/25.
//  Copyright (c) 2014年 byron. All rights reserved.
//
#import "QRCodeReaderController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeView.h"
@interface QRCodeReaderController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) QRCodeView *cameraView;

@property (strong, nonatomic) AVCaptureDevice            *defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *defaultDeviceInput;

@property (strong, nonatomic) AVCaptureMetadataOutput    *metadataOutput;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIButton *flashBtn;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, assign) BOOL flashIsOn;
@end

@implementation QRCodeReaderController

- (instancetype)init
{
    if (self == [super init]) {
        self.view.backgroundColor = [UIColor blackColor];

        [self setupAVComponents];
        [self configureDefaultComponents];
        [self setupUIComponents];
       
        [_cameraView.layer insertSublayer:self.previewLayer atIndex:0];
        
        _stopScan = YES;
        _lastScanImage = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startScanning];
    _flashIsOn = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopScanning];
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _previewLayer.frame = self.view.bounds;
}
- (void)setupAVComponents
{
    self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (_defaultDevice) {
        self.defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice error:nil];
        self.metadataOutput     = [[AVCaptureMetadataOutput alloc] init];
        self.session            = [[AVCaptureSession alloc] init];
        self.previewLayer       = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    if (!_defaultDevice) {
        NSLog(@"没有摄像头");
        return;
    }

}

 
- (void)configureDefaultComponents
{
    [_session addOutput:_metadataOutput];
    [_session addInput:_defaultDeviceInput];
    
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
        [_metadataOutput setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode ]];
    }
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_previewLayer setFrame:self.view.bounds];

}

- (void)setupUIComponents
{
    self.cameraView  = [[QRCodeView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    _cameraView.clipsToBounds                             = YES;
    [self.view addSubview:_cameraView];

    self.flashBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 80, 30, 30)];
    [_flashBtn setBackgroundImage:[UIImage imageNamed:@"icon_torch.png"] forState:UIControlStateNormal];
    [_flashBtn addTarget:self action:@selector(flashBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashBtn];

    self.cameraView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}
- (void)flashBtnOnClick
{
    
    if (_flashIsOn) {
        [self closeFlashlight];
    }else  [self openFlashlight];
    _flashIsOn = !_flashIsOn;
}
-(void)openFlashlight
{
    if (_defaultDevice.torchMode == AVCaptureTorchModeOff) {

        [_defaultDevice lockForConfiguration:nil];
        
        [_defaultDevice setTorchMode:AVCaptureTorchModeOn];
        
        [_defaultDevice unlockForConfiguration];
        
    }
}

-(void)closeFlashlight
{
    if (_defaultDevice.torchMode == AVCaptureTorchModeOn) {
        
        [_defaultDevice lockForConfiguration:nil];
        
        [_defaultDevice setTorchMode:AVCaptureTorchModeOff];
        
        [_defaultDevice unlockForConfiguration];
        
    }

}

- (void)startScanning;
{
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
}

- (void)stopScanning;
{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if (self.isStopScan) [self.session stopRunning];
    
    if (!self.isLastScanImage) [self.previewLayer removeFromSuperlayer];

    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];

        if ([self.delegate respondsToSelector:@selector(QRCodeReaderController:didScanResult:)]) {
            [self.delegate QRCodeReaderController:self didScanResult:obj.stringValue];
        }

    }
    
    
}


@end
