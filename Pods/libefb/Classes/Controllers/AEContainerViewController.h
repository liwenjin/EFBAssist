//
//  AEContainerViewController.h
//  Pods
//
//  Created by 徐 洋 on 14-6-16.
//
//

#import <UIKit/UIKit.h>

@interface AEContainerViewController : UIViewController

/// The view controllers currently managed by the container view controller.
@property (nonatomic, copy, readonly) NSArray *viewControllers;

/// The currently selected and visible child view controller.
@property (nonatomic, assign) UIViewController *selectedViewController;

/** Designated initializer.
 @note The view controllers array cannot be changed after initialization.
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;


@end
