//
//  HarpyConstants.h
//  
//
//  Created by Arthur Ariel Sabintsev on 1/30/13.
//
//

#warning Please customize Harpy's static variables

/*
 Option 1 (DEFAULT): NO gives user option to update during next session launch
 Option 2: YES forces user to update app on launch
 */
static BOOL harpyForceUpdate = NO;

// 2. Your AppID (found in iTunes Connect) //731851266 425349261
#define kHarpyAppID                 @"796971080"

// 3. Customize the alert title and action buttons
#define kHarpyAlertViewTitle        @"更新提示"
#define kHarpyCancelButtonTitle     @"以后更新"
#define kHarpyUpdateButtonTitle     @"马上更新"
#define kHarpyUpdateAlreadyNewVersion     @"已经是最新版本"

#define kHarpyAlertViewTitle_EN       @"Update Available"
#define kHarpyCancelButtonTitle_EN    @"Later"
#define kHarpyUpdateButtonTitle_EN    @"OK"
#define kHarpyUpdateAlreadyNewVersion_EN     @"Is already the newest version"