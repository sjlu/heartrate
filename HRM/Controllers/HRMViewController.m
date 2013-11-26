#import "HRMViewController.h"

#import "UIView+Utility.h"

@interface HRMViewController ()

@end

@implementation HRMViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    if (self.shouldObserveKeyboard) {
        [self unregisterFromKeyboardNotifications];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.shouldObserveKeyboard) {
        [self registerForKeyboardNotification];
    }
}

#pragma mark - Keyboard

- (BOOL)shouldObserveKeyboard {
    return NO;
}

- (void)registerForKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect endRect = [(NSValue *)[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    WEAK(self);
    
    [UIView animateWithDuration:[[notification.userInfo
                                  objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:(UIViewAnimationOptions)[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^ {
                         weak_self.view.top -= endRect.size.height;
                         weak_self.navigationController.navigationBar.top -= endRect.size.height;
                     }
                     completion:^(BOOL __unused finished) {
                         if (finished) {
                             [weak_self keyboardDidShow];
                         }
                     }];
}

- (void)keyboardDidShow {}

- (void)keyboardDidHide {}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect endRect =
    [(NSValue *)[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    WEAK(self);
    [UIView animateWithDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:(UIViewAnimationOptions)[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^ {
                         weak_self.view.top += endRect.size.height;
                         weak_self.navigationController.navigationBar.top = weak_self.view.top + 20.f;
                     }
                     completion:^(BOOL __unused finished) {
                         [self keyboardDidHide];
                     }];
}

- (void)unregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

@end
