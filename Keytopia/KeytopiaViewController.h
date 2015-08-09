//
//  ViewController.h
//  Keytopia
//
//  Created by Rob Stearn on 05/05/2015.
//  Copyright (c) 2015 cocoadelica. All rights reserved.
//

@import UIKit;

@interface KeytopiaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

