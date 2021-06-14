//
//  ObjCViewController.m
//  KBPopupExample
//
//  Created by 张鹏 on 2021/6/11.
//

#import "ObjCViewController.h"
#import <KBPopup/KBPopup.h>

@interface ObjCViewController ()

@end

@implementation ObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    myView.backgroundColor = UIColor.cyanColor;
    
    KBPopupView *popupView      = [[KBPopupView alloc] initWithContentView :myView];
    popupView.arrowHeight       = 30;
    popupView.arrowCornerRadius = 6;
    popupView.cornerRadius      = 15;
    popupView.margin            = UIEdgeInsetsMake(50, 50, 100, 50);
    
    popupView.contentInsets     = UIEdgeInsetsMake(20, 20, 20, 20);
    popupView.contentSize       = CGSizeMake(200, 200);
    
    popupView.sourceFrame       = CGRectMake(100, 100, 100, 50);
    
    [popupView showIn:self.view];
}

@end
