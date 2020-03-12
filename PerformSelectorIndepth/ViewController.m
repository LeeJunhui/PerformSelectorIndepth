//
//  ViewController.m
//  PerformSelectorIndepth
//
//  Created by leejunhui on 2020/3/12.
//  Copyright © 2020 leejunhui. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/NSRunLoop.h>
@interface ViewController ()
- (IBAction)cancelTask;

@end

@implementation ViewController
#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // NSObject 相关的api
//    [self jh_performSelector];
//    [self jh_performSelectorWithObj];
//    [self jh_performSelectorWithObj1AndObj2];
    
    // NSRunLoop 相关的api
//    [self jh_performSelectorwithObjectafterDelay];
//    [self jh_performSelectorwithObjectafterDelayInModes];
//    [self jh_performSelectorTargetArgumentOrderModes];
    
    // NSThread 相关的api
//    [self jh_performSelectorOnThreadWithObjectWaitUntilDone];
//    [self jh_performSelectorOnMainThreadwithObjectwaitUntilDone];
    [self jh_performSelectorOnBackground];
}

#pragma mark - NSObject 相关
/**
 performSelector: 方法，底层直接走的是消息发送 ((id(*)(id, SEL))objc_msgSend)(self, sel)
 */
- (void)jh_performSelector
{
    /**
     + (id)performSelector:(SEL)sel {
         if (!sel) [self doesNotRecognizeSelector:sel];
         return ((id(*)(id, SEL))objc_msgSend)((id)self, sel);
     }
     */
     [self performSelector:@selector(task)];
}

/**
 performSelector:withObject: 方法，底层走的也是消息发送 ((id(*)(id, SEL, id))objc_msgSend)(self, sel, obj)
 */
- (void)jh_performSelectorWithObj
{
    [self performSelector:@selector(taskWithParam:) withObject:@{@"param": @"leejunhui"}];
}

/**
 底层走的也是消息发送 ((id(*)(id, SEL, id, id))objc_msgSend)(self, sel, obj1, obj2)
 */
- (void)jh_performSelectorWithObj1AndObj2
{
    [self performSelector:@selector(taskWithParam1:param2:) withObject:@{@"param1": @"lee"} withObject:@{@"param2": @"junhui"}];
}

#pragma mark - RunLoop 相关
- (void)jh_performSelectorwithObjectafterDelay
{
    /**
     This method sets up a timer to perform the aSelector message on the current thread’s run loop. The timer is configured to run in the default mode (NSDefaultRunLoopMode). When the timer fires, the thread attempts to dequeue the message from the run loop and perform the selector. It succeeds if the run loop is running and in the default mode; otherwise, the timer waits until the run loop is in the default mode.
     这个方法会在当前线程所对应的 runloop 中设置一个定时器来执行传入的 SEL。定时器需要在 NSDefaultRunLoopMode 模式下才会被触发。当定时器启动后，线程会尝试从 runloop 中取出 SEL 然后执行。
     如果 runloop 已经启动并且处于 NSDefaultRunLoopMode 的话，SEL 执行成功。否则，直到 runloop 处于 NSDefaultRunLoopMode 前，timer 都会一直等待
     */
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self performSelector:@selector(taskWithParam:) withObject:@{@"param": @"leejunhui"} afterDelay:1.f];
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
    
//    [self performSelector:@selector(taskWithParam:) withObject:@{@"param": @"leejunhui"} afterDelay:1.f];
}

- (void)jh_performSelectorwithObjectafterDelayInModes
{
    // 只有当 scrollView 发生滚动时，才会触发timer
//    [self performSelector:@selector(taskWithParam:) withObject:@{@"param": @"leejunhui"} afterDelay:1.f inModes:@[UITrackingRunLoopMode]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self performSelector:@selector(taskWithParam:) withObject:@{@"param": @"leejunhui"} afterDelay:5.f inModes:@[NSRunLoopCommonModes]];
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
    
//    [self performSelector:@selector(taskWithParam:) withObject:@{@"param": @"leejunhui"} afterDelay:5.f inModes:@[NSRunLoopCommonModes]];
}

- (void)jh_performSelectorTargetArgumentOrderModes
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop performSelector:@selector(runloopTask5) target:self argument:nil order:5 modes:@[NSRunLoopCommonModes]];
        [runloop performSelector:@selector(runloopTask1) target:self argument:nil order:1 modes:@[NSRunLoopCommonModes]];
        [runloop performSelector:@selector(runloopTask3) target:self argument:nil order:3 modes:@[NSRunLoopCommonModes]];
        [runloop performSelector:@selector(runloopTask2) target:self argument:nil order:2 modes:@[NSRunLoopCommonModes]];
        [runloop performSelector:@selector(runloopTask4) target:self argument:nil order:4 modes:@[NSRunLoopCommonModes]];
    });
}

- (void)runloopTask1
{
    NSLog(@"runloop 任务1");
}

- (void)runloopTask2
{
    NSLog(@"runloop 任务2");
}

- (void)runloopTask3
{
    NSLog(@"runloop 任务3");
}

- (void)runloopTask4
{
    NSLog(@"runloop 任务4");
}

- (void)runloopTask5
{
    NSLog(@"runloop 任务5");
}

#pragma mark - 多线程相关
- (void)jh_performSelectorOnThreadWithObjectWaitUntilDone
{
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"子线程 - %@", [NSThread currentThread]);
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    [thread start];
    
    NSLog(@"%s", __func__);
    
    NSLog(@"start----");
    
    [self performSelector:@selector(threadTask:) onThread:thread withObject:@{@"param": @"leejunhui"} waitUntilDone:NO];
    
    [self performSelector:@selector(threadTask:) onThread:thread withObject:@{@"param": @"leejunhui"} waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
    
    NSLog(@"end-----");
}

- (void)jh_performSelectorOnMainThreadwithObjectwaitUntilDone
{
    [self performSelectorOnMainThread:@selector(threadTask:) withObject:@{@"param": @"leejunhui"} waitUntilDone:NO];
//    [self performSelectorOnMainThread:@selector(threadTask:) withObject:@{@"param": @"leejunhui"} waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
}

- (void)jh_performSelectorOnBackground
{
    [self performSelectorInBackground:@selector(threadTask:) withObject:@{@"param": @"leejunhui"}];
}

#pragma mark - event response
- (void)threadTask:(NSDictionary *)param
{
    NSLog(@"%s", __func__);
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)task
{
    NSLog(@"%s", __func__);
}

- (void)taskWithParam:(NSDictionary *)param
{
    NSLog(@"%s", __func__);
    NSLog(@"%@", param);
}

- (void)taskWithParam1:(NSDictionary *)param1 param2:(NSDictionary *)param2
{
    NSLog(@"%s", __func__);
    NSLog(@"%@", param1);
    NSLog(@"%@", param2);
}


- (IBAction)cancelTask {
    NSLog(@"%s", __func__);
    [ViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(taskWithParam:) object:@{@"param": @"leejunhui"}];
    
    [ViewController cancelPreviousPerformRequestsWithTarget:self];
}
@end
