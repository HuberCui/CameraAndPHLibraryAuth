//
//  NSObject+YTKVO.m
//  Food
//
//  Created by cuixuebin on 2019/11/11.
//  Copyright © 2019 宋链. All rights reserved.
//

#import "NSObject+YTKVO.h"


#import <objc/runtime.h>


@implementation NSObject (YTKVO)
+(void)load{
    [self switchMethod];
}
+(void)switchMethod{
    SEL removeSel = @selector(removeObserver:forKeyPath:);
    SEL yt_removeSel = @selector(yt_removeObserver:forKeyPath:);
    Method systemRemoveMethod = class_getClassMethod([self class], removeSel);
    Method yt_RemoveMethod = class_getClassMethod([self class], yt_removeSel);
    method_exchangeImplementations(systemRemoveMethod, yt_RemoveMethod);
    
    SEL addSel = @selector(addObserver:forKeyPath:options:context:);
    SEL yt_addSel = @selector(yt_addObserver:forKeyPath:options:context:);
    Method systemAddMethod = class_getClassMethod([self class], addSel);
    Method yt_addMethod = class_getClassMethod([self class], yt_addSel);
    method_exchangeImplementations(systemAddMethod, yt_addMethod);
}

-(void)yt_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    @try {
        [self yt_removeObserver:observer forKeyPath:keyPath];
    } @catch (NSException *exception) {
        NSLog(@"监听已经移除或者其它问题1");
    } @finally {
         NSLog(@"监听已经移除或者其它问题2");
    }
   
}
- (void)yt_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    NSLog(@"%@的路径%@添加了监听者%@",NSStringFromClass([self class]),keyPath,NSStringFromClass([observer class]));
    [self yt_addObserver:observer forKeyPath:keyPath options:options context:context];
}

@end
