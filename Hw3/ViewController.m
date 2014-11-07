//
//  ViewController.m
//  Hw3
//
//  Created by Jeffrey Shih on 10/14/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "ViewController.h"
#import "FlickrFetcher.h"


@interface ViewController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showPhoto];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)showPhoto{
    
    NSURL * photoURL = [FlickrFetcher urlForPhoto:[self photoInfo] format:FlickrPhotoFormatOriginal];
    dispatch_queue_t fetchQueue = dispatch_queue_create("load photo queue", NULL);
    dispatch_async(fetchQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
            self.imageView = [[UIImageView alloc] initWithImage:image];
            [self.scrollView addSubview:self.imageView];
            [self.scrollView flashScrollIndicators];

        });
    });

    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end
