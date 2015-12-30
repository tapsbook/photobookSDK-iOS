
#import <UIKit/UIKit.h>

@class PullableView;

/**
 Protocol for objects that wish to be notified when the state of a
 PullableView changes
 */
@protocol PullableViewDelegate <NSObject>

@optional
/**
 Notifies of a changed state
 @param pView PullableView whose state was changed
 @param opened The new state of the view
 */
- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened;
- (void)pullableView:(PullableView *)pView willChangeState:(BOOL)opened;
- (void)pullableView:(PullableView *)pView isChangingState:(float)percentage;

@end

/**
 Class that implements a view that can be pulled out by a handle, 
 similar to the Notification Center in iOS 5. This class supports
 pulling in the horizontal or vertical axis. This is determined by
 the values for openedCenter and closedCenter that you set: if
 both have the same x coordinate, the pulling should happen in the
 vertical axis, or the horizontal axis otherwise.
 @author Fabio Rodella fabio@crocodella.com.br
 */
@interface PullableView : UIView {
    
    CGPoint closedCenter;
    CGPoint openedCenter;
    
    UIView *handleView;
    UIPanGestureRecognizer *dragRecognizer;
    UITapGestureRecognizer *tapRecognizer;
    
    CGPoint startPos;
    CGPoint minPos;
    CGPoint maxPos;
    CGPoint startPosTiedView;
    
    BOOL opened;
    BOOL verticalAxis;
    
    BOOL toggleOnTap;
    
    BOOL animate;
    float animationDuration;
    
    id<PullableViewDelegate> delegate;
}
/**
 The view that will move in the same manner as self
 usually this is a tab or handle that stick outside
 */
@property (nonatomic, weak) PullableView *tiedView;

/**
 The view that is used as the handle for the PullableView. You
 can style it, add subviews or set its frame at will.
 */
@property (nonatomic,readonly) UIView *handleView;

/**
 The point that defines the center of the view when in its closed
 state. You must set this before using the PullableView.
 */
@property (readwrite,assign) CGPoint closedCenter;

/**
 The point that defines the center of the view when in its opened
 state. You must set this before using the PullableView.
 */
@property (readwrite,assign) CGPoint openedCenter;

/**
 Gesture recognizer responsible for the dragging of the handle view.
 It is exposed as a property so you can change the number of touches
 or created dependencies to other recognizers in your views.
 */
@property (nonatomic,readonly) UIPanGestureRecognizer *dragRecognizer;

/**
 Gesture recognizer responsible for handling tapping of the handle view.
 It is exposed as a property so you can change the number of touches
 or created dependencies to other recognizers in your views.
 */
@property (nonatomic,readonly) UITapGestureRecognizer *tapRecognizer;

/**
 If set to YES, tapping the handle view will toggle the PullableView.
 Default value is YES.
 */
@property (readwrite,assign) BOOL toggleOnTap;

/**
 If set to YES, the opening or closing of the PullableView will
 be animated. Default value is YES.
 */
@property (readwrite,assign) BOOL animate;

/**
 Duration of the opening/closing animation, if enabled. Default
 value is 0.2.
 */
@property (readwrite,assign) float animationDuration;

/**
 Delegate that will be notified when the PullableView changes state.
 If the view is set to animate transitions, the delegate will be
 called only when the animation finishes.
 */
@property (nonatomic,assign) id<PullableViewDelegate> delegate;

/**
 Toggles the state of the PullableView
 @param op New state of the view
 @param anim Flag indicating if the transition should be animated
 */
- (void)setOpened:(BOOL)op animated:(BOOL)anim;

- (void)closeIfOpened:(BOOL)animated;

@end
