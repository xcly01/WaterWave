//
//  LYWaterWaveView.m
//  WaterWave
//
//  Created by liyang on 16/4/22.
//  Copyright © 2016年 ly. All rights reserved.
//

#import "LYWaterWaveView.h"

/*
    y = A * sin(ωx+φ)+k
 */

@interface LYWaterWaveView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) CAShapeLayer *waterWaveLayer;

@end

@implementation LYWaterWaveView

#pragma mark - lifeCycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor orangeColor];
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor orangeColor];
        [self initData];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.layer.cornerRadius  = MIN(CGRectGetWidth(self.frame)/2,
                                   CGRectGetHeight(self.frame)/2);
    self.waveAngularSpeed = M_PI / frame.size.width;

}

#pragma mark - Custom Method

- (void)initData {
    self.waveAmplitude = 30;
    self.offsetX = 0;
    self.waveHeigth = 150;
    self.waveSpeed = 0.08;
}

- (void)start {
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                       selector:@selector(getCurrentWave)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                               forMode:NSRunLoopCommonModes];
    }
}

- (void)getCurrentWave {
    
    self.offsetX += self.waveSpeed;
    
    if (self.tmpAmplitude > 5 && self.waveAmplitude < 30) {
        self.waveAmplitude += 1;
    }

    if (self.waveAmplitude > 0 ) {
        self.waveAmplitude -= 0.05;
    }
    
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGFloat y = self.bounds.size.height;
    CGPathMoveToPoint(pathRef, nil, 0, self.frame.size.height/2);
    
    for (float x = 0; x <= self.bounds.size.width; x++) {
        y = self.waveAmplitude * sin(self.waveAngularSpeed * x + self.offsetX) + self.waveHeigth;
        CGPathAddLineToPoint(pathRef, nil, x, y);
    }
    CGPathAddLineToPoint(pathRef, nil, self.frame.size.width,self.frame.size.height/2);
    CGPathAddLineToPoint(pathRef, nil, self.frame.size.width,self.frame.size.height);
    CGPathAddLineToPoint(pathRef, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(pathRef);
    
    self.waterWaveLayer.path = pathRef;
    CGPathRelease(pathRef);
}

#pragma mark - Layers

- (CAShapeLayer *)waterWaveLayer {
    if (!_waterWaveLayer) {
        _waterWaveLayer = [[CAShapeLayer alloc] init];
        _waterWaveLayer.fillColor = self.waterColor.CGColor;
        [self.layer addSublayer:self.waterWaveLayer];
    }
    return _waterWaveLayer;
}


@end
