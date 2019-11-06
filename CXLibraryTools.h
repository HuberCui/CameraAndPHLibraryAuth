//
//  CXLibraryTools.h
//  Food
//
//  Created by cuixuebin on 2019/11/6.
//  Copyright © 2019 宋链. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface CXLibraryTools : NSObject
+(void)requestPhotoAuthorization:(UIViewController *)viewController handler:(void (^)(PHAuthorizationStatus status)) handler;
+(void)requestCameraAuthorization:(UIViewController *)viewController handler:(void (^)(AVAuthorizationStatus status)) handler;
@end

NS_ASSUME_NONNULL_END
