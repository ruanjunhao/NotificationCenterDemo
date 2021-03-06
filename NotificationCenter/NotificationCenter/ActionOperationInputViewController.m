//
//  ActionOperationInputViewController.m
//  NotificationCenter
//
//  Created by LiangHao on 2016/9/23.
//  Copyright © 2016年 PhantomSmart. All rights reserved.
//

#import "ActionOperationInputViewController.h"

@interface ActionOperationInputViewController ()

@end

@implementation ActionOperationInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNotificationDes:@"这是一个新的本地通知，带两个Title，分别为title和subtitle。同时带一个辅助图像。下拉该通知，放大图像。有一个点击按钮，点击会进入App。有一个文本输入。创建5秒后触发。建议回到桌面。"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CreateNotificationAction
- (void)createNotification:(UIButton *)sender {
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Apple";
    content.subtitle = @"Apple Developer";
    content.body = @"下拉放大图片";
    
    NSString* imageFilePath = [[NSBundle mainBundle] pathForResource:@"accessory_icon"
                                                              ofType:@"png"];
    if (imageFilePath) {
        NSError* error = nil;
        
        UNNotificationAttachment *imageAttachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageAttachment"
                                                                                                   URL:[NSURL fileURLWithPath:imageFilePath]
                                                                                               options:nil
                                                                                                 error:&error];
        if (imageAttachment) {
            //  这里设置的是Array，但是只会取lastObject
            content.attachments = @[imageAttachment];
            
        }
    }
    
    NSMutableArray* actionMutableArray = [[NSMutableArray alloc] initWithCapacity:1];
    UNNotificationAction* actionC = [UNNotificationAction actionWithIdentifier:@"IdentifierJoinAppC"
                                                                         title:@"进入应用C"
                                                                       options: UNNotificationActionOptionForeground];
    UNTextInputNotificationAction* actionD = [UNTextInputNotificationAction actionWithIdentifier:@"IdentifierJoinAppD"
                                                                                           title:@"文本输入D"
                                                                                         options:UNNotificationActionOptionForeground textInputButtonTitle:@"Send"
                                                                            textInputPlaceholder:@"Say something."];
    [actionMutableArray addObjectsFromArray:@[actionC, actionD]];
    
    if ([actionMutableArray count] > 1) {
        UNNotificationCategory* categoryNotification = [UNNotificationCategory categoryWithIdentifier:@"categoryOperationInput"
                                                                                              actions:actionMutableArray
                                                                                    intentIdentifiers:@[]
                                                                                              options:UNNotificationCategoryOptionCustomDismissAction];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:categoryNotification]];
        content.categoryIdentifier = @"categoryOperationInput";
    }
    
    
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5
                                                                                                    repeats:NO];
    NSString* requestIdentifer = @"Request";
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:requestIdentifer
                                                                          content:content
                                                                          trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request
                                                           withCompletionHandler:^(NSError * _Nullable error) {
                                                               NSLog(@"Error%@", error);
                                                           }];
}
@end
