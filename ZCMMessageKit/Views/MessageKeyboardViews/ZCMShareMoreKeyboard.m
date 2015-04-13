//
//  ZCMShareMoreKeyboard.m
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMShareMoreKeyboard.h"
#import "ZCMShareMoreMenuCell.h"
#import "ZCMMessageKeyboard.h"
#import "ZCMShareMoreDataHandler.h"

@interface ZCMShareMoreKeyboard ()<UICollectionViewDataSource, UICollectionViewDelegate, ZCMShareMoreMenuCellDelegate>

@property (nonatomic, assign) CGFloat collectionHeight;

/**
 *  显示表情的collectView控件
 */
@property (nonatomic, weak) UICollectionView *collectionView;

/**
 *  显示页码的控件
 */
@property (nonatomic, weak) UIPageControl *pageControl;


@end

@implementation ZCMShareMoreKeyboard

#pragma mark - Life cycle

- (void)setup {
    if (!_collectionView) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self collectionViewLayout]];
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[ZCMShareMoreMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCMShareMoreMenuCell class])];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView setScrollsToTop:NO];
        collectionView.pagingEnabled = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [[self view] addSubview:collectionView];
        self.collectionView = collectionView;
    }
    
    if (!_pageControl) {
        UIPageControl *pageControl = [UIPageControl new];
        pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
        pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
        pageControl.backgroundColor = [UIColor clearColor];
        //pageControl.hidesForSinglePage = YES;
        pageControl.defersCurrentPageDisplay = YES;
        [[self view] addSubview:pageControl];
        self.pageControl = pageControl;
    }
    
    
    [self setupSubviewsContraints];
    
    //[self reloadData];
}

-(void)setDataSource:(id<ZCMShareMoreKeyboardDataSource>)dataSource {
    if (dataSource) {
        _dataSource = dataSource;
    } else {
        _dataSource = [ZCMShareMoreDataHandler sharedMoreDataHandler];
    }
    
    [self reloadData];
}

/**
 *  设置subviews约束
 */
-(void)setupSubviewsContraints {
    //autolayout 布局，约束条件
    NSDictionary *metrics = @{@"margin":@0};
    NSDictionary *views = NSDictionaryOfVariableBindings(self, _collectionView, _pageControl);
    
    NSArray *c = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_collectionView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [[self view] addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_pageControl]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [[self view] addConstraints:c];
    
    _collectionHeight = kZCMEmoticonKeyboardHeight - 8 - 5 - 15 - 5;
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_collectionView]-5-[_pageControl(15)]-5-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [[self view] addConstraints:c];
}

- (void)dealloc {
    _delegate = nil;
    _dataSource = nil;
    self.pageControl = nil;
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.collectionView = nil;
}

/**
 *  隐藏键盘, delegate自动置nil
 */
-(void)hide {
    [super hide];
    _delegate = nil;
    _dataSource = nil;
}

-(UICollectionViewLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat h = _collectionHeight/2;;
    CGFloat itemW = 59;
    CGFloat minSpacing = [UIScreen mainScreen].bounds.size.width/4-itemW;
    
    layout.minimumLineSpacing = minSpacing;
    layout.minimumInteritemSpacing = 3;//minSpacing/2.0;
    layout.sectionInset = UIEdgeInsetsMake(0, minSpacing/2, 0, minSpacing/2);
    layout.itemSize = CGSizeMake(itemW, h-layout.minimumInteritemSpacing);
    layout.collectionView.alwaysBounceVertical = YES;
    
    return layout;
}

-(void)reloadData {
    if (!_dataSource) {
        _dataSource = [ZCMShareMoreDataHandler sharedMoreDataHandler];
    }
    
    _pageControl.numberOfPages = [_dataSource numberOfShareItemInShareMoreKeyboard:self]/8 + ([_dataSource numberOfShareItemInShareMoreKeyboard:self]%8 == 0 ? 0 : 1);
    _pageControl.currentPage = 0;
    
    [_collectionView reloadData];
    
    [_collectionView setCollectionViewLayout:[self collectionViewLayout]];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.pageControl setCurrentPage:currentPage];
}

#pragma UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _pageControl.numberOfPages * 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCMShareMoreMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZCMShareMoreMenuCell class]) forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    cell.delegate = (id<ZCMShareMoreMenuCellDelegate>)self;
    
    ZCMShareMoreMenuItem *item = [_dataSource shareItemInShareMoreKeyboard:self atSection:indexPath.row];
    cell.shareItem = item;
    
    return cell;
}

#pragma mark - UICollectionView delegate

/**
 *  多媒体功能被点击 的delegate
 */
-(void)shareMoreCollectionViewCell:(ZCMShareMoreMenuCell *)cell didSelectedShareItem:(ZCMShareMoreMenuItem *)shareItem {
    if ([self.delegate respondsToSelector:@selector(shareMoreKeyboard:didSelectedShareItem:)]) {
        [self.delegate shareMoreKeyboard:self didSelectedShareItem:shareItem];
    }
}


@end
