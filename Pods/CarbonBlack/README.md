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
    [CarbonBlack registerWithClientId:@"823b8648-2ff8-451d-a653-748d4fff9128" 
                             andAppId:@"5"];

    return YES;
}
```

#### Adding Custom Data To events
```objective-c

#pragma mark - CCBContextEventManagerDataSource

- (NSDictionary *)payloadForEvent:(NSDictionary *)event {   
    return @{@"first_name":@"Kevin", @"last_name":@"Lee"};
}

```

#### Working with events
```objective-c
#pragma mark  - CCBContextEventManagerDelegate

- (void)willPostEvent:(NSDictionary *)event {
    NSLog(@"Carbon WILL Post Event %@", event);
}

- (void)didPostEvent:(NSDictionary *)event {
    NSLog(@"Carbon DID Post Event %@", event);
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



