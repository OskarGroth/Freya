//
//  MenuController.m
//  Freya
//
//  Created by oskar groth on 2012-07-31.
//  Copyright (c) 2012 Cindori Software. All rights reserved.
//

#import "MenuController.h"
#import "AppDelegate.h"
@implementation MenuController

- (IBAction)savePress:(id)sender {
    AppDelegate *d = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    if(d.arrayController.selectedObjects.count == 0){
        return;
    }
    NSString *file = [[[d.arrayController selectedObjects] objectAtIndex:0] valueForKey:@"name"];
    NSString *path = [NSString stringWithFormat:@"%@/Firmwares/%@", [d applicationSupportFolder], file];
    [d.modifyController.boundDataHexView.data writeToFile:path atomically:YES];
    /*
    AppDelegate *d = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    NSSavePanel *savePanel = [NSSavePanel savePanel]; 
    [savePanel setTitle:@"Save firmware..."];
    savePanel set
    int result = [savePanel runModal]; 
    
    if(tvarInt == NSOKButton){
        
    } else if(tvarInt == NSCancelButton) { 
        NSLog(@"Cancel button"); return; 
    } else {
        return; 
    } */
}
- (IBAction)saveAsPress:(id)sender {
    AppDelegate *d = (AppDelegate*)[[NSApplication sharedApplication] delegate];

}


@end
