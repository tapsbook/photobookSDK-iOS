
#import "PullableView.h"

/**
 @author Fabio Rodella fabio@crocodella.com.br
 */

@implementation PullableView

@synthesize handleView;
@synthesize closedCenter;
@synthesize openedCenter;
@synthesize dragRecognizer;
@synthesize tapRecognizer;
@synthesize animate;
@synthesize animationDuration;
@synthesize delegate =_delegate;
@synthesize tiedView = _tiedView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        animate = YES;
        animationDuration = 0.2;
        
        toggleOnTap = YES;
 
        
        // Creates the handle view. Subclasses should resize, reposition and style this view
        handleView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 66, frame.size.width, 66)];
        [self addSubview:handleView];
        
        dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
        dragRecognizer.minimumNumberOfTouches = 1;
        dragRecognizer.maximumNumberOfTouches = 1;
        
        [handleView addGestureRecognizer:dragRecognizer];
        
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        
        [handleView addGestureRecognizer:tapRecognizer];
        
        opened = NO;
    }
    return self;
}

- (void)handleDrag:(UIPanGestureRecognizer *)sender {
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(pullableView:willChangeState:)]) {
            [self.delegate pullableView:self willChangeState:opened];
        }
        
        startPos = self.center;
        startPosTiedView = self.tiedView.center;
        
        // Determines if the view can be pulled in the x or y axis
        verticalAxis = closedCenter.x == openedCenter.x;
        
        // Finds the minimum and maximum points in the axis
        if (verticalAxis) {
            minPos = closedCenter.y < openedCenter.y ? closedCenter : openedCenter;
            maxPos = closedCenter.y > openedCenter.y ? closedCenter : openedCenter;
        } else {
            minPos = closedCenter.x < openedCenter.x ? closedCenter : openedCenter;
            maxPos = closedCenter.x > openedCenter.x ? closedCenter : openedCenter;
        }
        
    } else if ([sender state] == UIGestureRecognizerStateChanged) {
                
        CGPoint translate = [sender translationInView:self.superview];
        
        CGPoint newPos;
        
        // Moves the view, keeping it constrained between openedCenter and closedCenter
        if (verticalAxis) {
            
            newPos = CGPointMake(startPos.x, startPos.y + translate.y);
            
            if (newPos.y < minPos.y) {
                newPos.y = minPos.y;
                translate = CGPointMake(0, newPos.y - startPos.y);
            }
            
            if (newPos.y > maxPos.y) {
                newPos.y = maxPos.y;
                translate = CGPointMake(0, newPos.y - startPos.y);
            }
        } else {
            
            newPos = CGPointMake(startPos.x + translate.x, startPos.y);
            
            if (newPos.x < minPos.x) {
                newPos.x = minPos.x;
                translate = CGPointMake(newPos.x - startPos.x, 0);
            }
            
            if (newPos.x > maxPos.x) {
                newPos.x = maxPos.x;
                translate = CGPointMake(newPos.x - startPos.x, 0);
            }
        }
        
        if (verticalAxis) {
            translate.x = 0;
        } else {
            translate.y = 0;
        }
        self.tiedView.center = CGPointMake( startPosTiedView.x + translate.x, startPosTiedView.y + translate.y);

        [sender setTranslation:translate inView:self.superview];
        self.center = newPos;
        
        //tell caller how much we are done.
        float openPercent = (newPos.x - minPos.x)/(maxPos.x - minPos.x);
        
        if ([self.delegate respondsToSelector:@selector(pullableView:isChangingState:)]) {
            [self.delegate pullableView:self isChangingState:openPercent];
        }
        
    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        
        // Gets the velocity of the gesture in the axis, so it can be
        // determined to which endpoint the state should be set.
        
        CGPoint vectorVelocity = [sender velocityInView:self.superview];
        CGFloat axisVelocity = verticalAxis ? vectorVelocity.y : vectorVelocity.x;
        
        CGPoint target = axisVelocity < 0 ? minPos : maxPos;
        BOOL op = CGPointEqualToPoint(target, openedCenter);
        
        [self.tiedView setOpened:op animated:animate];
        [self setOpened:op animated:animate];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(pullableView:willChangeState:)]) {
        [self.delegate pullableView:self willChangeState:opened];
    }

    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self.tiedView setOpened:!opened animated:animate];
        [self setOpened:!opened animated:animate];
    }
}

- (void)setToggleOnTap:(BOOL)tap {
    toggleOnTap = tap;
    tapRecognizer.enabled = tap;
}

- (BOOL)toggleOnTap {
    return toggleOnTap;
}

- (void)setOpened:(BOOL)op animated:(BOOL)anim {
    opened = op;
    
    if (anim) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    
    self.center = opened ? openedCenter : closedCenter;
    
    if (anim) {
        
        // For the duration of the animation, no further interaction with the view is permitted
        dragRecognizer.enabled = NO;
        tapRecognizer.enabled = NO;
        
        [UIView commitAnimations];
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [self.delegate pullableView:self didChangeState:opened];
        }
    }
}
         
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (finished) {
        // Restores interaction after the animation is over
        dragRecognizer.enabled = YES;
        tapRecognizer.enabled = toggleOnTap;
        
        if ([self.delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [self.delegate pullableView:self didChangeState:opened];
        }
    }
}

- (void)closeIfOpened:(BOOL)animated {
    if (opened) {
        [self setOpened:!opened animated:animate];
    }
}

@end
