//
//  HeaderView.m
//  ParallaxScrollObjc
//
//  Created by Beomseok Seo on 2/9/17.
//  Copyright © 2017 Beomseok Seo. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setTranslatesAutoresizingMaskIntoConstraints:false];
        [self setBackgroundColor:[UIColor grayColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        self.imageView = imageView;
        
        [imageView setTranslatesAutoresizingMaskIntoConstraints:false];
        [imageView setBackgroundColor:[UIColor brownColor]];
        [imageView setImage:[UIImage imageNamed:@"img"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:true];
        
        [self addSubview:imageView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(imageView);
        NSDictionary *metrics = @{@"Padding":@0.0};
        
        NSArray <NSLayoutConstraint *> *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Padding-[imageView]-Padding-|"
                                                                                              options:0
                                                                                              metrics:metrics
                                                                                                views:views];
        [self addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Padding-[imageView]-Padding-|"
                                                              options:0
                                                              metrics:metrics
                                                                views:views];
        [self addConstraints:constraints];
        
        
    }
    return self;
}


@end
