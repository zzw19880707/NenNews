//
//  LoginViewController.m
//  testLanucher
//
//  Created by 佐筱猪 on 13-10-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#define kLeftMargin				20.0
#define kRightMargin			20.0

#define kTextFieldWidth			160.0
#define kTextFieldHeight		36


#import "LoginViewController.h"
//#import "ResignViewController.h"
static NSString *kNameKey=@"kNameKey";
static NSString *kFieldKey=@"kFieldKey";
@interface LoginViewController ()

@end



@implementation LoginViewController
@synthesize loginTableView, logoImageView;
@synthesize btnLogin, btnCancel;
@synthesize txtUser,txtPass;
@synthesize dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"登陆";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray=[NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"账户",kNameKey,self.txtUser,kFieldKey, nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"密码",kNameKey,self.txtPass,kFieldKey, nil]
                    , nil];
    self.editing=NO;
    btnLogin.showsTouchWhenHighlighted = YES;

    
}

#pragma mark 内存管理
-(void)viewDidUnload{
    
    [super viewDidUnload];
    [txtUser release];
	txtUser = nil;
	[txtPass release];
	txtPass = nil;
    self.dataArray=nil;
    
}
-(void)dealloc{
    [loginTableView release];
	[logoImageView release];
	[btnLogin release];
	[btnCancel release];
	[txtUser release];
	[txtPass release];
	[dataArray release];
    [super dealloc];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----初始化TextFields
- (UITextField *)txtUser{
	if (txtUser == nil) {
		CGRect frame = CGRectMake(kLeftMargin + 50, 4, kTextFieldWidth, kTextFieldHeight);
		txtUser = [[UITextField alloc] initWithFrame:frame];
		txtUser.borderStyle = UITextBorderStyleNone;
		txtUser.textColor = [UIColor blackColor];
		txtUser.font = [UIFont systemFontOfSize:17];
		txtUser.placeholder = @"请输入账户";
		txtUser.backgroundColor = NenNewsgroundColor;
		txtUser.autocorrectionType = UITextAutocorrectionTypeNo;
		txtUser.keyboardType = UIKeyboardTypeDefault;
        txtUser.returnKeyType = UIReturnKeyNext;
		txtUser.clearButtonMode = UITextFieldViewModeWhileEditing;
		txtUser.tag = 1001;
		txtUser.delegate = self;
	}
	return txtUser;
}

- (UITextField *)txtPass{
	if (txtPass == nil) {
		CGRect frame = CGRectMake(kLeftMargin + 50, 4, kTextFieldWidth, kTextFieldHeight);
		txtPass = [[UITextField alloc] initWithFrame:frame];
		txtPass.borderStyle = UITextBorderStyleNone;
		txtPass.textColor = [UIColor blackColor];
		txtPass.font = [UIFont systemFontOfSize:17];
		txtPass.placeholder = @"请输入密码";
		txtPass.backgroundColor = NenNewsgroundColor;
        txtPass.secureTextEntry=YES;
		txtPass.autocorrectionType = UITextAutocorrectionTypeNo;
		txtPass.keyboardType = UIKeyboardTypeDefault;
		txtPass.returnKeyType = UIReturnKeyDone;
		txtPass.clearButtonMode = UITextFieldViewModeWhileEditing;
		txtPass.tag = 1002;
		txtPass.delegate = self;
        txtPass.clearsOnBeginEditing = YES;
        

	}
	return txtPass;
}
#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celldentifier=@"loginCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celldentifier];
    if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:celldentifier] autorelease];
	}else {
		UIView *viewToCheck = nil;
		viewToCheck = [cell.contentView viewWithTag:(1000+indexPath.row)];
		if (viewToCheck) {
			[viewToCheck removeFromSuperview];
		}
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//配置单元格
	cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] valueForKey:kNameKey];
	UITextField *tmpTxtField = [[self.dataArray objectAtIndex:indexPath.row] valueForKey:kFieldKey];
	[cell.contentView addSubview:tmpTxtField];
	return cell;
    
}
#pragma mark UITextFieldDelegate methods
//让textField获取第一响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag==1001) {
        [txtPass becomeFirstResponder];
        return NO;
    }else{
        [textField resignFirstResponder];
        
        [self logodidAppear];
        return YES;
    }
    
}//隐藏登陆logo，重新修改frame
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	NSUInteger distance;
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.3];
	self.logoImageView.alpha = 0.0f;
	
	CGRect frame = self.loginTableView.frame;
	CGRect frame2 = self.btnLogin.frame;
	distance = frame2.origin.y - frame.origin.y;
	frame.origin.y = 20.0;
	self.loginTableView.frame = frame;
	frame2.origin.y = frame.origin.y + distance;
	self.btnLogin.frame = frame2;
	CGRect frame3 = self.btnCancel.frame;
	frame3.origin.y = frame2.origin.y;
	self.btnCancel.frame = frame3;
	[UIView commitAnimations];
	return YES;
}

#pragma mark 按钮事件
- (IBAction)loginAction:(id)sender {
//    [NSUserDefaults resetStandardUserDefaults];
    
//username:123
//password:123
//quickforward:yes
//handlekey:ls

    NSString *url = @"http://bbs.nen.com.cn/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1";
//    NSString *username = txtUser.text;
//    NSString *password = txtPass.text;
    NSString *username = @"1块2毛5";
    NSString *password = @"tt19880311";
    DataService *service = [[DataService alloc]init];
    service.eventDelegate = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",[NSNumber numberWithBool:YES],@"quickforward",@"ls",@"handlekey", nil];
    if ([self getConnectionAlert]) {
        [service requestWithURL:url
                      andparams:params isJoint:NO andhttpMethod:@"POST"];
        NSUserDefaults *userDefaults=[[NSUserDefaults standardUserDefaults]init];
        [userDefaults setObject:username forKey:kuser_name];
        [userDefaults setObject:password forKey:kuser_password];
        
        [userDefaults synchronize];
    }
    

}

#pragma mark ASIRequestDelegate
-(void)requestFailed:(ASIHTTPRequest *)request{
#warning
}
-(void)requestFinished:(id)result{
    _po(result);
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(login) userInfo:nil repeats:NO];

}


-(void)login{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (IBAction)cancelAction:(id)sender {
    txtPass.text=nil;
    txtUser.text=nil;
    [self logodidAppear];
    [txtUser resignFirstResponder];
    [txtPass resignFirstResponder];
    
}


//登陆图标浮出
-(void)logodidAppear{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.3];
    self.logoImageView.alpha=1.0f;
	self.loginTableView.frame = CGRectMake(19, 133, 280, 200);
    self.btnLogin.frame = CGRectMake(187, 267, 110, 44);
    self.btnCancel.frame = CGRectMake(20, 267, 110, 44);
	[UIView commitAnimations];
}
@end
