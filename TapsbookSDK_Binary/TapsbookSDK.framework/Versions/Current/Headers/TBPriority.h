//
//  TBPriority.h
//  AtomBook
//
//  Created by Xinrong Guo on 14-3-4.
//
//

typedef NS_ENUM(NSInteger, TBPriority) {
    TBPriority_None = NSOperationQueuePriorityVeryLow - 1000,
    TBPriority_VeryLow = NSOperationQueuePriorityVeryLow,
    TBPriority_Low = NSOperationQueuePriorityLow,
    TBPriority_Normal = NSOperationQueuePriorityNormal,
    TBPriority_High = NSOperationQueuePriorityHigh,
    TBPriority_VeryHigh = NSOperationQueuePriorityVeryHigh,
};

