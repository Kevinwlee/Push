//
//  CCBViewController.h
//  Push
//
//  Created by Kevin Lee on 1/13/14.
//  Copyright (c) 2014 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCHNotificationService.h"
#import "ContextHub.h"
#import "CCHContextEventManager.h"

@interface CCBViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *backgroundCount;
@property (weak, nonatomic) IBOutlet UILabel *customLabel;
@end
