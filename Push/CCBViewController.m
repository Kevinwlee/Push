//
//  CCBViewController.m
//  Push
//
//  Created by Kevin Lee on 1/13/14.
//  Copyright (c) 2014 ChaiONE. All rights reserved.
//

#import "CCBViewController.h"

@interface CCBViewController ()
@property (weak, nonatomic) IBOutlet UITextField *customData;
@property (weak, nonatomic) IBOutlet UITextField *messageField;

@end

@implementation CCBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCount) name:@"count_updated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"data_updated" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContextLifeCycleEvent:) name:CCHContextEventManagerDidCancelEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContextLifeCycleEvent:) name:CCHContextEventManagerDidDetectEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContextLifeCycleEvent:) name:CCHContextEventManagerWillPostEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContextLifeCycleEvent:) name:CCHContextEventManagerDidPostEvent object:nil];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)handleContextLifeCycleEvent:(NSNotification *)notification {
    NSLog(@"NOTIFICATION: /n %@ %@", notification.name, notification.object);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshCount];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshCount {
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:@"counter"];
    self.backgroundCount.text = [NSString stringWithFormat:@"%ld", (long)count];
}

- (void)refreshData {
    NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"custom_data"];
    self.customLabel.text = data;
}

- (IBAction)pushMeTapped:(id)sender {
    NSDictionary *userInfo = @{ @"alert":self.messageField.text};
    
    [[CCHNotificationService sharedService] sendAPNSNotificationToAliases:@[[ContextHub deviceId]] userInfo:userInfo withCompletion:^(NSError *error) {
        NSLog(@"Error %@", error);
    }];
}

- (IBAction)pushDataTapped:(id)sender {

    NSDictionary *userInfo = @{@"custom":self.customData.text, @"alert":@"Data was pushed!"};
    
    [[CCHNotificationService sharedService] sendAPNSNotificationToAliases:@[[ContextHub deviceId]] userInfo:userInfo withCompletion:^(NSError *error) {
        NSLog(@"Error %@", error);
    }];
}

- (IBAction)pushMeNoisyTapped:(id)sender {
    
    NSDictionary *userInfo = @{@"sound":@"techno.aif", @"custom":self.customData.text, @"alert":@"CAN YOU HEAR ME NOW?", @"badge":@"1000"};
    
    [[CCHNotificationService sharedService] sendAPNSNotificationToAliases:@[[ContextHub deviceId]] userInfo:userInfo withCompletion:^(NSError *error) {
        NSLog(@"Error %@", error);
    }];
}

- (IBAction)pushMeSilentTapped:(id)sender {
    NSDictionary *userInfo = @{@"content-available":@"1", @"sound":@"", @"custom":self.customData.text, @"alert":@""};

    [[CCHNotificationService sharedService] sendAPNSNotificationToAliases:@[[ContextHub deviceId]] userInfo:userInfo withCompletion:^(NSError *error) {
        NSLog(@"Error %@", error);
    }];
}

- (IBAction)resetBadgeCount:(id)sender {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
@end
