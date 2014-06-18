//
//  ViewController.m
//  Geekon-SocialMap
//
//  Created by Wenxu Li on 6/16/14.
//  Copyright (c) 2014 OrdersTeam1. All rights reserved.
//

#import "ViewController.h"
#import "CategoryTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // customize search buttons
    UIColor * color = [UIColor colorWithRed:230.0f/255.0f green:184.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    
    [self.searchButtonForAll setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.searchButtonForAll.layer.cornerRadius = 12;
    self.searchButtonForAll.layer.borderWidth = 1;
    self.searchButtonForAll.layer.borderColor = color.CGColor;
    
    [self.searchButtonForFood setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.searchButtonForFood.layer.cornerRadius = 12;
    self.searchButtonForFood.layer.borderWidth = 1;
    self.searchButtonForFood.layer.borderColor = color.CGColor;
    
    [self.searchButtonForEvents setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.searchButtonForEvents.layer.cornerRadius = 12;
    self.searchButtonForEvents.layer.borderWidth = 1;
    self.searchButtonForEvents.layer.borderColor = color.CGColor;
    
    [self.searchButtonForDeals setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.searchButtonForDeals.layer.cornerRadius = 12;
    self.searchButtonForDeals.layer.borderWidth = 1;
    self.searchButtonForDeals.layer.borderColor = color.CGColor;
    
    // click on search buttons
    [self.searchButtonForAll addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButtonForFood addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButtonForEvents addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButtonForDeals addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // post text bar
    self.postBar.delegate = self;
    
    // Remove the icon, which is located in the left view
    [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;
    self.postBar.searchTextPositionAdjustment = UIOffsetMake(10, 0);
    
    // customize keyboard search button
    
}

- (void) searchButtonTapped:(id) button {
    if (![button isKindOfClass:[UIButton class]])
        return;
    
    if(button == self.searchButtonForAll) {
        NSString *title = [(UIButton *)button currentTitle];
        NSLog(@"%@", title);
    } else if(button == self.searchButtonForFood) {
        NSString *title = [(UIButton *)button currentTitle];
        NSLog(@"%@", title);
    } else if (button == self.searchButtonForEvents) {
        NSString *title = [(UIButton *)button currentTitle];
        NSLog(@"%@", title);
    } else if (button == self.searchButtonForDeals) {
        NSString *title = [(UIButton *)button currentTitle];
        NSLog(@"%@", title);
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.postBar.text = @"";
    [self.postBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    // Do the search...
    NSString *text = searchBar.text;
    NSLog(@"%@", text);
}

@end
