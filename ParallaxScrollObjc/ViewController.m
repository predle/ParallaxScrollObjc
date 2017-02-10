//
//  ViewController.m
//  ParallaxScrollObjc
//
//  Created by Beomseok Seo on 2/9/17.
//  Copyright © 2017 Beomseok Seo. All rights reserved.
//

#import "ViewController.h"
#import "HeaderView.h"

typedef struct ScrollViewAndContentView {
    __unsafe_unretained UIScrollView *scrollView;
    __unsafe_unretained UIView *contentView;
} ScrollViewAndContentView;

@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *lastAddedView;
@property (nonatomic, weak) HeaderView *headerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ScrollViewAndContentView scrollViewAndContentView = [self addScrollViewTo:self.view];
    self.scrollView = scrollViewAndContentView.scrollView;
    self.contentView = scrollViewAndContentView.contentView;
    
    NSLog(@"ScrollView : %@, ContentView : %@",self.scrollView, self.contentView);
    
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectZero];
    [_contentView addSubview:headerView];
    self.headerView = headerView;
    self.lastAddedView = headerView;
    
    
    NSDictionary *subviews = NSDictionaryOfVariableBindings(headerView);
    NSDictionary *metrics = @{@"headerViewHeight": @300.0, @"verticalSpacing": @8.0};
    NSArray <NSLayoutConstraint *> *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|"
                                                                                          options:0
                                                                                          metrics:metrics
                                                                                            views:subviews];
    [_contentView addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headerView(headerViewHeight)]|"
                                                          options:0
                                                          metrics:metrics
                                                            views:subviews];
    [_contentView addConstraints:constraints];
    
    for (int i = 0 ; i != 10; i++) {
        [self insertViewToContentView];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ScrollViewAndContentView)addScrollViewTo:(UIView * __weak)view {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:false];
    [scrollView setBackgroundColor:[UIColor redColor]];
    [scrollView setDelegate:self];
    [view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:false];
    [contentView setBackgroundColor:[UIColor blueColor]];
    [scrollView addSubview:contentView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, contentView);
    NSDictionary *metrics = @{@"Padding":@0.0};
    
    NSArray <NSLayoutConstraint *> *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|"
                                                                                          options:0
                                                                                          metrics:metrics views:views];
    [view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollView]-0-|"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    [view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView(==scrollView)]-0-|"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    [view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView(>=0)]-0-|"
                                                          options:0
                                                          metrics:metrics
                                                            views:views];
    [view addConstraints:constraints];
    
    ScrollViewAndContentView scrollViewAndContentView;
    scrollViewAndContentView.contentView = contentView;
    scrollViewAndContentView.scrollView = scrollView;
    return scrollViewAndContentView;
}

///
///
///

- (void)insertViewToContentView {
    
    NSDictionary *metrics = @{@"subViewHeight": @100.0, @"verticalSpacing": @8.0};
    UIView *subView = [[UIView alloc] initWithFrame:CGRectZero];
    [subView setBackgroundColor:[UIColor yellowColor]];
    [subView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    // last view 가 initialized 됐다면,
    //
    if (_lastAddedView != nil) {
        
        NSLayoutConstraint *lastConstraint = [[_contentView constraints] lastObject];
        [lastConstraint setActive:false];
        
        for (NSLayoutConstraint *constraint in [_contentView constraints]) {
            NSLog(@"%@",constraint);
        }
        
        [_contentView addSubview:subView];
        
        NSDictionary *views = @{@"subView":subView, @"lastSubView": _lastAddedView};
        NSArray <NSLayoutConstraint *> *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subView]-0-|"
                                                                                              options:0
                                                                                              metrics:metrics views:views];
        [_contentView addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastSubView]-verticalSpacing-[subView(subViewHeight)]|"
                                                              options:0
                                                              metrics:metrics
                                                                views:views];
        [_contentView addConstraints:constraints];
        
        self.lastAddedView = subView;
        
        
        return;
    }
    
}

///
///

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 
    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetY = offset.y;
    
    CATransform3D headerTransform = CATransform3DIdentity;
    
    if (offsetY < 0) {
        
        CGFloat headerScaleFactor = -(offsetY) / _headerView.bounds.size.height;
        headerTransform = CATransform3DTranslate(headerTransform, 0, -(_headerView.bounds.size.height/2.0) + offsetY, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        _headerView.imageView.layer.anchorPoint = CGPointMake(0.5, 0.0);
        _headerView.imageView.layer.transform = headerTransform;
        
    }
    
    
    
}

@end








