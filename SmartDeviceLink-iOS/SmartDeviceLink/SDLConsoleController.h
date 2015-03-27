//  SDLConsoleController.h
//


@import Foundation;
@import UIKit;

#import "SDLDebugTool.h"

@interface SDLConsoleController : UITableViewController <SDLDebugToolConsole> {
	NSMutableArray* messageList;
    BOOL atBottom;
    NSDateFormatter* dateFormatter;
}

@property (strong, readonly) NSMutableArray *messageList;

-(id) initWithTableView:(UITableView*) tableView;


@end
