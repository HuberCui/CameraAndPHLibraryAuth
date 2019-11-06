//
//  CXLibraryTools.m
//  Food
//
//  Created by cuixuebin on 2019/11/6.
//  Copyright © 2019 宋链. All rights reserved.
//

#import "CXLibraryTools.h"

@implementation CXLibraryTools
#pragma mark 相机相册权限管理
+(void)requestPhotoAuthorization:(UIViewController *)viewController handler:(void (^)(PHAuthorizationStatus status)) handler{
    
    if ([PHPhotoLibrary respondsToSelector:@selector(authorizationStatus)]) {
         PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            
        if (status == PHAuthorizationStatusAuthorized){

            if(handler){
                handler(status);
            }
        // 获取所有资源的集合，并按资源的创建时间排序
            NSLog(@"同意访问相册");
            

        }else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
            if(handler){
                handler(status);
            }
            
                NSLog(@"用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关");
                
                 [self showNoAuthorizedAlertWithViewController:viewController];
        }else {
            
        //第一次进来请求权限并回调-异步
           [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (handler) handler(status);
                     if (status != PHAuthorizationStatusAuthorized) {
                         [CXLibraryTools showNoAuthorizedAlertWithViewController:viewController];
                     }else {
                         
                         NSLog(@"回调同意访问相册");
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"HXPhotoRequestAuthorizationCompletion" object:nil];
                     }
                 });
             }];
    }
  }
}

+(void)showNoAuthorizedAlertWithViewController:(UIViewController *)viewController {
  
    
    [CXLibraryTools cx_showAlert:viewController title:@"无法访问相册" message:@"请在设置-隐私-相册中允许访问相册" buttonTitle1:@"取消" buttonTitle2:@"设置" button1Handler:nil button2Handler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
}

+(void)requestCameraAuthorization:(UIViewController *)viewController handler:(void (^)(AVAuthorizationStatus status)) handler{
    if([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
       AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusAuthorized){

                   if(handler){
                       handler(status);
                   }
               // 获取所有资源的集合，并按资源的创建时间排序
                   NSLog(@"同意使用相机");
                   

       }else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
                   if(handler){
                       handler(status);
                   }
                   
                       NSLog(@"用户拒绝当前应用使用相机,我们需要提醒用户打开使用开关");
                       
                        [CXLibraryTools cx_showAlert:viewController title:@"无法使用相机" message:@"请在设置-隐私-相机中允许访问相机" buttonTitle1:@"取消" buttonTitle2:@"设置" button1Handler:nil button2Handler:^{
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                       }];
               
        
    }else{
       
        //第一次进来请求权限并回调-异步
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            //回调同意
            if (handler && granted) {
                 NSLog(@"同意使用相机");
                handler(AVAuthorizationStatusAuthorized);
            }
            
            if (!granted) {
                
                handler(AVAuthorizationStatusDenied);
                [CXLibraryTools cx_showAlert:viewController title:@"无法使用相机" message:@"请在设置-隐私-相机中允许访问相机" buttonTitle1:@"取消" buttonTitle2:@"设置" button1Handler:nil button2Handler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
            }
        }];
    }
  }
}

+(void)cx_showAlert:(UIViewController *)vc title:(NSString *)title message:(NSString *)message buttonTitle1:(NSString *)buttonTitle1 buttonTitle2:(NSString *)buttonTitle2 button1Handler:(dispatch_block_t)button1handler button2Handler:(dispatch_block_t)button2handler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                message:message
                                                                         preferredStyle:UIAlertControllerStyleAlert];
       
       if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
           UIPopoverPresentationController *pop = [alertController popoverPresentationController];
           pop.permittedArrowDirections = UIPopoverArrowDirectionAny;
           pop.sourceView = vc.view;
           pop.sourceRect = vc.view.bounds;
       }
       
       if (buttonTitle1) {
           UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:buttonTitle1
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    if (button1handler) button1handler();
                                                                }];
           [alertController addAction:cancelAction];
       }
       if (buttonTitle2) {
           UIAlertAction *okAction = [UIAlertAction actionWithTitle:buttonTitle2
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                if (button2handler) button2handler();
                                                            }];
           [alertController addAction:okAction];
       }
       [vc presentViewController:alertController animated:YES completion:nil];
}
@end
