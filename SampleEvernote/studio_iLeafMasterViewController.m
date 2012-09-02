//
//  studio_iLeafMasterViewController.m
//  SampleEvernote
//
//  Created by 平杉 敦史 on 12/09/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "studio_iLeafMasterViewController.h"
#import "EvernoteSDK.h"

#define EVERNOTE_HOST   @"sandbox.evernote.com"
#define CONSUMER_KEY    @"ahirasugi-3815"   // Consumer key
#define CONSUMER_SECRET @"6e8148859b98b313"  // Consumer secret

@interface studio_iLeafMasterViewController ()
@end


@implementation studio_iLeafMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Evernote OAuth";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch ([indexPath row]) {
        case 0:
            cell.textLabel.text = @"Evernote OAuth 認証";
            break;
        case 1:
            cell.textLabel.text = @"Logout";
            break;
        default:
            cell.textLabel.text = @"Evernote にノートを送る";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
            [self login];
            break;
        case 1:
            [self logout];
            break;
        default:
            [self sendEvernote];
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)login
{
    [EvernoteSession setSharedSessionHost:EVERNOTE_HOST consumerKey:CONSUMER_KEY consumerSecret:CONSUMER_SECRET];
    
    EvernoteSession *session = [EvernoteSession sharedSession];
    [session authenticateWithViewController:self completionHandler:^(NSError *error) {
        if (error || !session.isAuthenticated) {
            NSLog(@"Error: Could not authenticate");
        } else {
            NSLog(@"Authenticated!");
        } 
    }];
}

- (void)logout
{
    [[EvernoteSession sharedSession] logout];
}

- (void)sendEvernote
{
    EDAMNote *note = [[EDAMNote alloc] init];
    //note.title = @"note.title";
    //note.content = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">\n<en-note>note.content</en-note>";
    
    note.title = @"とある地点の住所";
    note.content = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">\n<en-note>地図の画像とリンク</en-note>";
    
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    
    @try {
        [noteStore createNote:note success:^(EDAMNote *note) {} failure:^(NSError *error) {
            //NSLog(@"Error: %@", error);                                            
            NSLog(@"書き込めませんでした。ネット環境をご確認ください。");
        }];
    }
    @catch (EDAMUserException *e) {
        return;
    }
    
    NSLog(@"Note was saved.");
}

@end