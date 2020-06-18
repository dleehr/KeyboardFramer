//
//  ViewController.m
//  KeyboardFramer
//
//  Created by Dan Leehr on 6/16/20.
//  Copyright © 2020 Dan Leehr LLC. All rights reserved.
//

#import "ViewController.h"

@interface DLLToolbar : UIToolbar

@end

@implementation DLLToolbar

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 375.0f, 44.0f)];
    return self;
}

// setItems calls into this, so no need to override both
- (void)setItems:(NSArray<UIBarButtonItem *> *)items animated:(BOOL)animated {
    [super setItems:items animated:animated];
    [self updateConstraintsIfNeeded];
}

@end


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

- (void)doneTapped:(id)sender {
    [self.textField resignFirstResponder];
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
    
    // Remember, auto layout for UIToolbars gets messed up
    UIToolbar *toolbar = [[DLLToolbar alloc] init];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[ flex, doneItem ];
    self.textField.inputAccessoryView = toolbar;
    
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

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    NSLog(@"viewSafeAreaInsetsDidChange: %@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
//    2020-06-16 23:27:29.331065-0400 KeyboardFramer[43154:2088782] viewSafeAreaInsetsDidChange: {44, 0, 34, 0}
    // top, left, bottom, right

}

- (void)handleKeyboardOffset:(CGFloat)heightOffset {
    // This method can update multiple constraints if it needs to

    // ah here's the trick.
    // when the height offset is zero, keyboard is off the screen and our views should bind to the safe area layout guide on the bottom
    // but when it's zero, we don't care about the safe area layout guide really - because the keyboard itself accounts for that
    // so if we simply update the constant, we'd just be adding a gap
    // if the height offset is nonzero, the bottomConstraint should NOT be the safeAreaLayoutGuide
    // we can stil use the safe area layout guide, but just update the constant to account for that when heightOffset is nonzero

    if (heightOffset == 0.0f) {
        self.bottomConstraint.constant = 0.0f;
    } else {
        self.bottomConstraint.constant = self.view.safeAreaInsets.bottom - heightOffset;
    }
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
