//
//  LYWaterWaveView.h
//  WaterWave
//
//  Created by liyang on 16/4/22.
//  Copyright © 2016年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 画水波的核心是正弦函数（ y = A * sin(ωx+φ) + k,其中A为振幅;ω为角速度;φ为初相,反映波的移动方向;
  k为偏距，反映波距离水平位置的高度）
 */

@interface LYWaterWaveView : UIView

@property (nonatomic, strong) UIColor *waterColor;

@property (nonatomic, assign) CGFloat tmpAmplitude;     // tmp振幅
@property (nonatomic, assign) CGFloat waveAmplitude;    // 振幅A
@property (nonatomic, assign) CGFloat waveAngularSpeed; // 角速度ω
@property (nonatomic, assign) CGFloat offsetX;          // 相位φ
@property (nonatomic, assign) CGFloat waveHeigth;       // 波的高度
@property (nonatomic, assign) CGFloat waveSpeed;        // 波速

- (void)start;

@end
