//
//  ViewController.m
//  ReacttiveCocoaDemo
//
//  Created by ccguo on 15/11/22.
//  Copyright © 2015年 ccguo. All rights reserved.
//

#import "ViewController.h"
//#import <re>
//#import <ReactiveCocoa-umbrella>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWorld;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic) BOOL passwordIsValid;
@property (nonatomic) BOOL usernameIsValid;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Index";
    self.loginButton.enabled = NO;

    // Do any additional setup after loading the view, typically from a nib.
//    [self.userName.rac_textSignal subscribeNext:^(id x){
//        NSLog(@"%@",x);
//    }];
    
//    [self.userName.rac_newTextChannel
//     subscribeNext:^(id x){
//         NSLog(@"%@",x);
//     }
//     completed:^{
//         NSLog(@"complate : ");
//     }];
    
//    [[self.userName.rac_textSignal
//     filter:^BOOL(NSString *value){
//         return value.length > 3;
//     }]
//     subscribeNext:^(id x){
//         NSLog(@"%@",x);
//     }];
    
//    [[[self.userName.rac_textSignal map:^id(id value){
//        return value;
//     }]
//     filter:^BOOL(id value){
//         if ([value isEqualToString:@"123"]) {
//             return YES;
//         }
//         return NO;
//     }]
//     subscribeNext:^(id x){
//         NSLog(@"%@",x);
//     }];
    
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"ok" delegate:self cancelButtonTitle:@"cancle" otherButtonTitles:@"OK", nil];
//    alert.delegate = self;
//    [alert show];
//    
//    [alert.rac_buttonClickedSignal subscribeNext:^(id x){
//        NSLog(@"index : %@",x);
//    }];
    
    
//    NSArray *array  = @[@"a",@"b",@"c"];
//    [array.rac_sequence all:^BOOL(id value){
//        NSLog(@"aaa");
//        return YES;
//    }];
    
//    [array.rac_sequence foldLeftWithStart:@(1) reduce:^id(id accumulator, id value){
//        NSLog(@"%@    :   %@",accumulator,value);
//        return @"3";
//    }];
    
    
    
    RACSignal *usernameSourceSingle = self.userName.rac_textSignal;
    RACSignal *filteredUserName = [usernameSourceSingle
                                   filter:^BOOL(NSString * value){
                                       NSString *text = value;
                                       return text.length > 3;
                                   }];
    [filteredUserName subscribeNext:^(id x){
        NSLog(@"%@",x);
    }];
    
    
    RACSignal *validUserNameSingle = [self.userName.rac_textSignal
                                      map:^id(id value){
                                          return @([self isValidUsername:value]);
                                      }];
    
    RACSignal *validPassWordSingle = [self.passWorld.rac_textSignal
                                      map:^id(id value){
                                          return @([self isValidPassword:value]);
                                      }];
    
    [[validPassWordSingle
      map:^id(NSNumber *passwordValid){
          return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
      }]
     subscribeNext:^(UIColor *color){
         self.passWorld.backgroundColor = color;
     }];
    
    
    RAC(self.passWorld, backgroundColor) =
    [validPassWordSingle
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];
    
    RAC(self.userName, backgroundColor) =
    [validUserNameSingle
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];
    
    
    
    self.userName.backgroundColor =
    self.usernameIsValid ? [UIColor clearColor] : [UIColor yellowColor];
    self.passWorld.backgroundColor =
    self.passwordIsValid ? [UIColor clearColor] : [UIColor yellowColor];
    
    
    
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUserNameSingle, validPassWordSingle]
                      reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
                          return @([usernameValid boolValue]&&[passwordValid boolValue]);
                      }];
    
    
    [signUpActiveSignal subscribeNext:^(NSNumber*signupActive){
        self.loginButton.enabled =[signupActive boolValue];
    }];
    
    [[[[self.loginButton
        rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x){
           self.loginButton.enabled =NO;
//           self.signInFailureText.hidden =YES;
       }]
      flattenMap:^id(id x){
          return @"";
      }]
     subscribeNext:^(NSNumber*signedIn){
         self.loginButton.enabled =YES;
         BOOL success =[signedIn boolValue];
//         self.signInFailureText.hidden = success;
         if(success){
             [self performSegueWithIdentifier:@"signInSuccess" sender:self];
         }
     }];
    
    
    
    
    
    
//    @weakify(self);
//    [[RACObserve(self, warningText)
//      filter:^(NSString *newString) {
//          self.resultLabel.text = newString;
//          return YES;
//          //          return [newString hasPrefix:@"Success"];
//      }]
//     subscribeNext:^(NSString *newString) {
//         @strongify(self);
//         self.bt.enabled = [newString hasPrefix:@"Success"];
//     }];
//    
//    
//    RAC(self,self.loginButton) = [RACSignal combineLatest:@[
//                                                            RACObserve(self,self.userName.text),RACObserve(self, self.passWorld.text)]
//                                                   reduce:^(NSString *userName, NSString *password)
//    {
//        if ([self isValidUsername:userName] && [self isValidUsername:password])
//        {
//            self.loginButton.enabled = YES;
//            return @"Success";
//        }
//        else if([self isValidUsername:password])
//        {
//            return @"Please Input";
//        }
//        else
//            return @"Input Error";
//    }
//    ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (RACSignal *)signInSignal {
//    return [RACSignal createSignal:^RACDisposable *(id subscriber){
//        [self.signInService
//         signInWithUsername:self.usernameTextField.text
//         password:self.passwordTextField.text
//         complete:^(BOOL success){
//             [subscriber sendNext:@(success)];
//             [subscriber sendCompleted];
//         }];
//        return nil;
//    }];
//}

- (BOOL)isValidUsername:(NSString *)text
{
    return text.length > 3;;
}

- (BOOL)isValidPassword:(NSString *)text
{
    return text.length > 3;;
}

- (IBAction)loginAction:(id)sender {
}

@end
