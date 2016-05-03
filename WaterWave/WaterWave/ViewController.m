//
//  ViewController.m
//  WaterWave
//
//  Created by liyang on 16/4/22.
//  Copyright © 2016年 ly. All rights reserved.
//

#import "ViewController.h"
#import "LYWaterWaveView.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController () 

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, weak) IBOutlet LYWaterWaveView *waterView;

@end

@implementation ViewController

- (void)rotationActivity {
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    __weak ViewController *weakSelf = self;
    
    if (self.motionManager.deviceMotionAvailable) {
        [weakSelf.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                    withHandler:^(CMDeviceMotion * _Nullable motion, 
                                                                  NSError * _Nullable error)
        {
            /*
                根据反正切函数求出旋转的角度
             */
            double rotation = atan2(motion.gravity.x, motion.gravity.y) - M_PI;
            
            /*
                限制旋转的角度不超过45°
             */
            if (motion.gravity.y <= 0 &&
                ((rotation < -(2*M_PI-M_PI_4)) ||
                (rotation <= 0 && rotation > -M_PI_4))) {
                [UIView animateWithDuration:1 animations:^{
                    weakSelf.waterView.transform = CGAffineTransformMakeRotation(rotation);
                }];
            }
            else if (motion.gravity.y > 0 )
            {
                [UIView animateWithDuration:1 animations:^{
                    weakSelf.waterView.transform = CGAffineTransformMakeRotation(0);
                }];
            }
            
            /*
                根据在x轴旋转的角速度来控制波的振幅的变化
             */
            if (motion.rotationRate.x > 0.7) {
                self.waterView.tmpAmplitude = 20*motion.rotationRate.x;
            } else {
                self.waterView.tmpAmplitude = 0;
            }
            
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.waterView.waterColor = [UIColor cyanColor];
    [self.waterView start];
    
    [self rotationActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
