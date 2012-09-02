//
//  studio_iLeafDetailViewController.h
//  SampleEvernote
//
//  Created by 平杉 敦史 on 12/09/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface studio_iLeafDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
