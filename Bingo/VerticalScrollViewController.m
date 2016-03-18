//
//  VerticalScrollViewController.m
//  LTInfiniteScrollView
//
//  Created by ltebean on 16/3/13.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import "VerticalScrollViewController.h"
#import "LTInfiniteScrollView.h"

@interface VerticalScrollViewController ()<LTInfiniteScrollViewDelegate,LTInfiniteScrollViewDataSource>
{
  int i;
}
@property (nonatomic,strong) LTInfiniteScrollView *scrollView;
@end

@implementation VerticalScrollViewController
- (IBAction)spin:(id)sender {

  NSTimer* timerSlot03 = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(runSlot) userInfo:nil repeats:YES];
  double delayInSeconds = 5.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [timerSlot03 invalidate];
    int t = i+72;
    if(t > 518){
      t = 0;
    }
    i = t;
    [self.scrollView scrollToIndex:i animated:false];
  });

}

-(void)runSlot{
  i++;
  if(i > 518){
    i = 1;
  }
  
  [self.scrollView scrollToIndex:i animated:true];
  
}


- (void)viewDidLoad {
  [super viewDidLoad];
  i = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.scrollView = [[LTInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, self.slotView.bounds.size.width, self.slotView.bounds.size.height)];
  self.scrollView.verticalScroll = YES;
  
  self.scrollView.delegate = self;
  self.scrollView.dataSource = self;
  self.scrollView.maxScrollDistance = 300;
  self.scrollView.backgroundColor = [UIColor greenColor];
  [self.slotView addSubview:self.scrollView];
  
  
  [self.scrollView reloadDataWithInitialIndex:0];
  
}

# pragma mark - LTInfiniteScrollView dataSource
- (NSInteger)numberOfViews
{
  return 520;
}

- (NSInteger)numberOfVisibleViews
{
  return 1;
}

# pragma mark - LTInfiniteScrollView delegate
- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view;
{
  
  
  if (index > 518) {
    [self.scrollView reloadDataWithInitialIndex:0];
  }
  
  
  
  if (view) {
    ((UIImageView *)view).image = [UIImage imageNamed:@"icon_1.png"];
    return view;
  }
  
  UIImageView *aView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.slotView.bounds.size.width, self.slotView.bounds.size.height)];
  aView.backgroundColor = [UIColor blackColor];
  aView.backgroundColor = [UIColor darkGrayColor];
  aView.image = [UIImage imageNamed:@"icon_1.png"];
  return aView;
}


@end
