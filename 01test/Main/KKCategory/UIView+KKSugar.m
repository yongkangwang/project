//
//  UIView+KKSugar.m
//  yunbaolive
//
//  Created by Peter on 2021/1/28.
//  Copyright © 2021 cat. All rights reserved.
//

#import "UIView+KKSugar.h"
#import <Photos/Photos.h>

@implementation UIView (KKSugar)




/**
 *  给视图添加虚线边框
 *
 *  @param lineWidth  线宽
 *  @param lineMargin 每条虚线之间的间距
 *  @param lineLength 每条虚线的长度
 *  @param lineColor 每条虚线的颜色
 */
- (void)xl_addDottedLineBorderWithLineWidth:(CGFloat)lineWidth lineMargin:(CGFloat)lineMargin lineLength:(CGFloat)lineLength lineColor:(UIColor *)lineColor;
{
    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = lineColor.CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    border.frame = self.bounds;
    
    border.lineWidth = lineWidth;
    
    border.lineCap = @"round";
    
    border.lineDashPattern = @[@(lineLength), @(lineMargin)];
    
    [self.layer addSublayer:border];
}


//简单lable
+ (UILabel *)kkLabelWithText:(NSString *)text textColor:(UIColor *)color textFont:(UIFont *)font andTextAlignment:(NSTextAlignment )alignment
{
    UILabel *kkLabel = [[UILabel alloc]init];
    kkLabel.text = text;
    kkLabel.textColor = color;
    kkLabel.font = font;
    kkLabel.textAlignment = alignment;
    return kkLabel;
}

#pragma mark- 添加毛玻璃
+ (UIVisualEffectView *)kkaddBlurEffectToView:(UIView *)toView effectWithStyle:(UIBlurEffectStyle)style{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView  *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    visualEffectView.frame = toView.bounds;
    visualEffectView.alpha = 1;
    return visualEffectView;
}



+ (UIImage *)kk_getImageViewWithView:(UIView *)view{
//    UIGraphicsBeginImageContextWithOptions(view.size, TRUE, [[UIScreen mainScreen] scale]);

//    先指定图像的大小
//    UIGraphicsBeginImageContext(view.frame.size);这个方法会导致截图模糊
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);//原图

//    在指定的区域绘制图像
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
//    获取图像上下文
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
//    关闭图像上下文
    UIGraphicsEndImageContext();
return image;
}

+ (void)kk_writeImageToAlbum:(UIImage *)image
{
    NSMutableArray *imageIds = [NSMutableArray array];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            //记录本地标识，等待完成后取到相册中的图片对象
            [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//            NSLog(@"success = %d, error = %@", success, error);
            
            if (success)
            {
//                [MBProgressHUD kkshowMessage:@"保存成功"];
                //成功后取相册中的图片对象
                __block PHAsset *imageAsset = nil;
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    imageAsset = obj;
                    *stop = YES;
                    
                }];
                
                if (imageAsset)
                {
                    //加载图片数据
                    [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
                          options:nil
                          resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                                    
                        NSLog(@"imageData = %@", imageData);
                                                                    
                          }];
                }
            }
            
        }];
}

@end
