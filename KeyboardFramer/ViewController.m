//
//  ViewController.m
//  KeyboardFramer
//
//  Created by Dan Leehr on 6/16/20.
//  Copyright © 2020 Dan Leehr LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) NSLayoutConstraint *bottomConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self addAStack];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)showKeyboard:(UIButton *)sender {
    // show the keyboard
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    } else {
        [self.textField becomeFirstResponder];
    }

}

- (void)addAStack {
    // Connected as clonedemo
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headingLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    headingLabel.numberOfLines = 0;
    headingLabel.textAlignment = NSTextAlignmentCenter;
    headingLabel.text = @"heading";
    headingLabel.backgroundColor = [UIColor blueColor];

    UILabel *overviewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *overviewText = [NSString stringWithFormat:@"You will now be prompted to authenticate with %@. %@ will obtain an OAuth token for access and will not see your password.", @"github", @"clone"];
    overviewLabel.text = overviewText;
    overviewLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    overviewLabel.numberOfLines = 0;
    overviewLabel.backgroundColor = [UIColor yellowColor];
    
    // A button to show the keyboard
    UIButton *showKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showKeyboardButton setTitle:@"Show Keyboard" forState:UIControlStateNormal];
    [showKeyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showKeyboardButton addTarget:self action:@selector(showKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [showKeyboardButton sizeToFit];
    showKeyboardButton.backgroundColor = [UIColor greenColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.placeholder = @"Put some text here";
    [textField sizeToFit];
 
    textField.backgroundColor = [UIColor purpleColor];
    self.textField = textField;
    // Git Identity
    // Descriptive paragraph
    // buttons
    // keyboard frame
    NSArray<UIView *> *allViews = @[headingLabel, overviewLabel, showKeyboardButton, textField];
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:allViews];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentCenter;
    
    
    // layout
    stackView.backgroundColor = [UIColor orangeColor];
    
    // Must add stackview to self.view before enabling constraints
    [self.view addSubview:stackView];
    
    NSLayoutConstraint *constraint = nil;
    
    // top
    constraint = [stackView.topAnchor constraintEqualToSystemSpacingBelowAnchor:self.view.safeAreaLayoutGuide.topAnchor multiplier:1.0f];
    [self.view addConstraint:constraint];
    NSLog(@"top %@", @(constraint.active));
    // constraints are initially inactive. need to add to view before activating
    // where to add the constraint?
    constraint.active = YES;
    
    // bottom
    constraint = [stackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor];
    [self.view addConstraint:constraint];
    NSLog(@"bottom %@", @(constraint.active));
    constraint.active = YES;
    self.bottomConstraint = constraint;
    
    // left
    constraint = [stackView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor];
    [self.view addConstraint:constraint];
    NSLog(@"left %@", @(constraint.active));
    constraint.active = YES;

    // right
    constraint = [stackView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor];
    [self.view addConstraint:constraint];
    NSLog(@"right %@", @(constraint.active));
    constraint.active = YES;
}

- (void)handleKeyboardOffset:(CGFloat)heightOffset {
    // This method can update multiple constraints if it needs to
    self.bottomConstraint.constant = - heightOffset;
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
        NSDictionary *userInfo = notification.userInfo;
        // This is where the keyboard will end up
        CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect keyboardRect = [self.view convertRect:frameEnd fromView:nil];
        CGFloat heightOffset = CGRectGetMaxY(self.view.bounds) - CGRectGetMinY(keyboardRect);

        UIViewAnimationOptions options = animationCurve << 16;
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:options
                         animations:^{
            [self handleKeyboardOffset:heightOffset];
            [self.view layoutIfNeeded];
            [self.view setNeedsLayout];
        } completion:nil];
}

@end
