//
//  NERAlert+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 2016/10/31.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERAlertMaker.h"
#import "NERDefs.h"

#define Alert           [[NERAlertMaker alloc] initWithStyle:UIAlertControllerStyleAlert]
#define ActionSheet     [[NERAlertMaker alloc] initWithStyle:UIAlertControllerStyleActionSheet]

typedef NERAlertMaker *(^NERChainableNERAlertMakerActionBlock)(id, id);
typedef UIAlertController *(^NERAlertShowBlock)();

/**
 * Examples:
    Alert.title(@"Greeting").message(@"A greeting from little green man.").action(@"Cool", nil).tint(@"green").show();
 
    ActionSheet.title(@"Zombie atatck").message(@"Choose your weapon!").action(@"Gun", ^{
        Log(@"Gun");
    }).action(@"Chainsaw", ^{
        Log(@"Chainsaw");
    }).destructiveAction(@"Nuke", ^{
        Log(@"Nuke");
    }).cancelAction(@"Give up").show();
 */

@interface NERAlertMaker (NERChainable)

/**
 * Alert title or ActionSheet title.
 * Usages: .title(@"Put title here")
 */
NER_ALERT_PROP(Object)          title;

/**
 * Alert message or ActionShett message.
 * Usages: .message(@"Put message here")
 */
NER_ALERT_PROP(Object)          message;

/**
 * Adding a default action with title and callback block.
 * Usages: .action(@"Option1", ^{...}).action(@"Option2", ^{...})
 */
NER_ALERT_PROP(Action)          action;

/**
 * Adding a cancel action with title and a optional callback block.
 * Usages: .cancelAction(@"Cancel"), .cancelAction(@"Cancel", ^{...})
 */
NER_ALERT_PROP(ObjectList)      cancelAction;

/**
 * Adding a destructive action with title and callback block.
 * Usages: .destructiveAction(@"Delete", ^{...})
 */
NER_ALERT_PROP(Action)          destructiveAction;

/**
 * tintColor
 * You can use tint to change action button's title color.
 * tint use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .tint(@"red"), .tint(@"#F00"), .tint(@"255,0,0"), .tint(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_ALERT_PROP(Object)          tint;

/**
 * Present alert/actionsheet in top visible view controller.
 * You must call show() in the end in order to present alert/actionsheet.
 * Usages: .show()
 */
NER_READONLY NERAlertShowBlock  show;

#define cancelAction(...)   cancelAction(__VA_ARGS__, nil)

@end
