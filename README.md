# WaterWave

此demo展示了一个通过手机的感应从而使水波进行波动。

第一步：画水波
	画水波的核心是正弦函数（ y = A * sin(ωx+φ) + k,其中A为振幅;ω为角速度;φ为初相,反映波的移动方向;k为偏距，反映波距离水平位置
的高度）
    我们是在UIView的layer层来创建动画，所以，我们要创建一个layer负责波的展示，然后利用正弦函数来画正弦曲线；其次，我们利用
CADisplayLink来让φ进行改变，这样就形成了一个可以移动的正弦曲线。

第二步：获取手机的传感数据
    应用iOS的CoreMotion.framework库，CoreMotion可以让开发者从各个内置传感器那里获取未经修改的传感数据，并观测或响应设备各种运
动和角度变化。这些传感器包括陀螺仪、加速器和磁力仪(罗盘)。

CMMotionManager（CoreMotionManager类能够使用到设备的所有移动数据(motiondata)，CoreMotion框架提供了两种对motion数据的操作方式，一个是"pull"，另一个是"push"，其中"pull"方式能够以CoreMotionManager的只读方式获取当前任何传感器状态或是组合数据。"push"方式则是以块或者闭包的形式收集到你想要得到的数据并且会在特定周期内得到实时的更新。）来进行数据的检测。
    
在这里我们直接使用CMDeviceMotion类型来获取加速器和陀螺仪的复合数据（它包括CMAttitude、CMRotationRate、CMAcceleration、
userAcceleration）。假如手机平放在桌面上，他们的x、y、z轴分别是这样的情况：x轴贯穿于手机的屏幕左右方向并且跟桌面平行，y轴垂直于x轴并且跟桌面平行，z轴同时垂直于x、y轴。

CMAttitude：包含roll,yaw,pitch；在航空中，pitch, yaw, roll是这样的：
pitch是围绕X轴旋转，也叫做俯仰角
yaw是围绕Y轴旋转，也叫偏航角
roll是围绕Z轴旋转，也叫翻滚角

CMRotationRate：包含X、Y和Z轴，分别表示在x、y和z轴旋转多少弧度/秒，并且遵守右手规则。

CMAcceleration和userAcceleration，（文档中这么解释：Returns the acceleration that the user is giving to the device. Note that the total acceleration of the device is equal to gravity plus userAcceleration.）

1.首先，我们初始化CMMotionManager
 CMMotionManager *motionManager = [[CMMotionManager alloc] init];
 
2.判断是设备是否可以使用，然后进行检测，并进行改变水波。
    
    if (motionManager.deviceMotionAvailable) {
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
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

