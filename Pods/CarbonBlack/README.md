# Getting Started

#### Podfile

```ruby
platform :ios, '7.0'
pod 'CarbonBlack', :git => 'https://github.com/chaione/carbon-black-ios', :branch=>'master'
```

#### Registration
```objective-c
- (BOOL)application:(UIApplication *)application 
			didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //Register your client and your app
    [CarbonBlack registerWithAppId:@"823b8648-2ff8-451d-a653-748d4fff9128"];

    return YES;
}
```

#### Adding Custom Data To events
```objective-c

#pragma mark - CCBContextEventManagerDataSource

- (NSDictionary *)contextEventMangaer:(CCBContextEventManager *)eventManager payloadForEvent:(NSDictionary *)event {   
    return @{@"first_name":@"Kevin", @"last_name":@"Lee"};
}

```
#### Cancel an event
```objective-c

#pragma mark - CCBContextEventManagerDelegate

- (BOOL)contextEventManager:(CCBContextEventManager *)eventManager shouldPostEvent:(NSDictionary *)event {
	if(event[@"key"] == @"notImportant") {
		return NO;
	} else {
		return YES;
	}
}

```

#### Working with events
```objective-c
#pragma mark  - CCBContextEventManagerDelegate

- (void)contextEventManager:(CCBContextEventManager *)eventManager willPostEvent:(NSDictionary *)event {
    NSLog(@"Carbon WILL Post Event %@", event);
}

- (void)contextEventManager:(CCBContextEventManager *)eventManager didPostEvent:(NSDictionary *)event {
    NSLog(@"Carbon DID Post Event %@", event);
}
```

#### Background updates
Context changes will trigger background pushes to your app.  If you pass the background notification to CarbonBlack, CarbonBlack will update the contextual situation on the device while in the background.
You must have background pushes enabled in your project, and you must configure your push certificates on ContextHub.
```objective-c
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
 		[carbonBlack application:application didReceiveRemoteNotification:userInfo completion:^(UIBackgroundFetchResult) {
    	completionHandler(completion);
    }];
}

```

## Resources and Samples
- Context Demo: [manifest](https://github.com/chaione/manifest)
- Mac App iBeacon: [BeaconEmitter](https://github.com/lgaches/BeaconEmitter)
- iOS App iBeacon: [beacon](https://github.com/chaione/beacon)
- Vault Demo: [vault](https://github.com/chaione/vault)



## p12 to pem
```
openssl pkcs12 -in Certificates.p12 -out certificate.pem -nodes -clcerts
```

## SDK Docs

http://chaione.github.io/carbon-black-ios/



