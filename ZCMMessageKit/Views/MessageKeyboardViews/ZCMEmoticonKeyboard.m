//
//  ZCMEmoticonKeyboard.m
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMEmoticonKeyboard.h"
#import "ZCMEmoticonHandler.h"
#import "ZCMEmoticonKeyboardToolBar.h"
#import "ZCMEmoticonCollectionViewCell.h"
#import "ZCMMsgDisMacros.h"


#import "ZCMMessageKeyboard.h"



#define kZCMEmoticonMinimumLineSpacing           2



//
//
//  ZCMEmoticonKeyboard
//
//


@interface ZCMEmoticonKeyboard ()<UICollectionViewDelegate, UICollectionViewDataSource, ZCMEmoticonSectionBarDelegate> {
    CGFloat _emoticonViewHeight;
}

/**
 *  显示表情的collectView控件
 */
@property (nonatomic, weak) UICollectionView *emoticonCollectionView;

/**
 *  显示页码的控件
 */
@property (nonatomic, weak) UIPageControl *emoticonPageControl;

/**
 *  管理多种类别gif表情的滚动试图
 */
@property (nonatomic, weak) ZCMEmoticonKeyboardToolBar *emoticonToolBar;

/**
 *  当前选择了哪类gif表情标识
 */
@property (nonatomic, assign) NSInteger selectedIndex;


@end

@implementation ZCMEmoticonKeyboard

#pragma mark - Life cycle

- (void)setup {
    if (!_emoticonToolBar) {
        ZCMEmoticonKeyboardToolBar *emoticonToolBar = [ZCMEmoticonKeyboardToolBar new];
        emoticonToolBar.delegate = self;
        emoticonToolBar.backgroundColor = [UIColor colorWithWhite:0.886 alpha:1.000];
        [[self view] addSubview:emoticonToolBar];
        self.emoticonToolBar = emoticonToolBar;
    }
    
    if (!_emoticonCollectionView) {
        UICollectionView *emoticonView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        emoticonView.translatesAutoresizingMaskIntoConstraints = NO;
        emoticonView.backgroundColor = [UIColor clearColor];
        [emoticonView registerClass:[ZCMEmoticonCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCMEmoticonCollectionViewCell class])];
        emoticonView.showsHorizontalScrollIndicator = NO;
        emoticonView.showsVerticalScrollIndicator = NO;
        [emoticonView setScrollsToTop:NO];
        emoticonView.pagingEnabled = YES;
        emoticonView.delegate = self;
        emoticonView.dataSource = self;
        [[self view] addSubview:emoticonView];
        self.emoticonCollectionView = emoticonView;
    }
    
    if (!_emoticonPageControl) {
        UIPageControl *emoticonPageControl = [UIPageControl new];
        emoticonPageControl.translatesAutoresizingMaskIntoConstraints = NO;
        emoticonPageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
        emoticonPageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
        emoticonPageControl.backgroundColor = [UIColor clearColor];
        emoticonPageControl.hidesForSinglePage = YES;
        emoticonPageControl.defersCurrentPageDisplay = YES;
        [[self view] addSubview:emoticonPageControl];
        self.emoticonPageControl = emoticonPageControl;
    }
    
    
    [self setupSubviewsContraints];
    
    //[self reloadData];
}

-(void)setDataSource:(id<ZCMEmoticonKeyboardDataSource>)dataSource {
    if (dataSource) {
        _dataSource = dataSource;
    } else {
        _dataSource = [ZCMEmoticonHandler sharedEmoticonHandler];
    }
    
    [self reloadData];
}

/**
 *  设置subviews约束
 */
-(void)setupSubviewsContraints {
    //autolayout 布局，约束条件
    NSDictionary *metrics = @{@"margin":@0, @"sh":@(kZCMEmoticonSectionBarHeight), @"pbm":@(kZCMEmoticonSectionBarHeight+5), @"eh":@(_emoticonViewHeight=kZCMEmoticonKeyboardHeight-kZCMEmoticonSectionBarHeight-(8+15+8)-8)};
    NSDictionary *views = NSDictionaryOfVariableBindings(self,_emoticonToolBar, _emoticonCollectionView, _emoticonPageControl);
    NSArray *c = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_emoticonToolBar]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [[self view] addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_emoticonCollectionView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [[self view] addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_emoticonPageControl]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [[self view] addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_emoticonCollectionView(eh)]-8-[_emoticonPageControl(15)]-5-[_emoticonToolBar(sh)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [[self view] addConstraints:c];
    
}

- (void)dealloc {
    _dataSource = nil;
    _delegate = nil;
    self.emoticonToolBar = nil;
    self.emoticonPageControl = nil;
    self.emoticonCollectionView.delegate = nil;
    self.emoticonCollectionView.dataSource = nil;
    self.emoticonCollectionView = nil;
}

/**
 *  隐藏键盘, delegate自动置nil
 */
-(void)hide {
    [super hide];
    _delegate = nil;
    _dataSource = nil;
}

-(UICollectionViewLayout *)emoticonCollectionViewLayout:(ZCMEmoticonMgr *)emoticonMgr {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat h = [emoticonMgr emoticonHeight];
    if (h > _emoticonViewHeight/[emoticonMgr numberOfRowsInSection]) {
        h = _emoticonViewHeight/[emoticonMgr numberOfRowsInSection];
    }
    
    layout.minimumLineSpacing = kZCMEmoticonMinimumLineSpacing;
    layout.minimumInteritemSpacing = kZCMEmoticonMinimumLineSpacing/2.0;
    layout.sectionInset = UIEdgeInsetsMake(0, kZCMEmoticonMinimumLineSpacing/2.0, 0, kZCMEmoticonMinimumLineSpacing/2.0);
    layout.itemSize = CGSizeMake([emoticonMgr emoticonWidth]-layout.minimumLineSpacing, h-layout.minimumInteritemSpacing);
    layout.collectionView.alwaysBounceVertical = YES;
    
    return layout;
}

-(void)reloadData {
    if (!_dataSource) {
        _dataSource = [ZCMEmoticonHandler sharedEmoticonHandler];
    }
    
    
    NSInteger numberOfEmoticonMgrs = [self.dataSource numberOfEmoticonMgrsInEmoticonKeyboard:self];
    if (self.emoticonToolBar.emoticonMgrs != [_dataSource emoticonMgrsInEmoticonKeyboard:self]) {
        self.emoticonToolBar.emoticonMgrs = [_dataSource emoticonMgrsInEmoticonKeyboard:self];
    }
    
    ZCMEmoticonMgr *emoticonMgr = nil;
    if (numberOfEmoticonMgrs <= 0) {
        self.selectedIndex = 0;
        self.emoticonPageControl.numberOfPages = 0;
    } else {
        if (self.selectedIndex >= numberOfEmoticonMgrs) {
            self.selectedIndex = 0;
        }
        
        emoticonMgr = [self.dataSource emoticonMgrInEmoticonKeyboard:self atSection:self.selectedIndex];
        NSInteger numberOfEmoticons = emoticonMgr.emoticons.count;
        if (numberOfEmoticons > 0) {
            BOOL showDelete = [self.dataSource shouldShowDeleteActionInEmoticonKeyboard:self atSection:self.selectedIndex];
            NSInteger numberOfPage = [emoticonMgr numberOfRowsInSection]*[emoticonMgr numberOfSections] - (showDelete==YES ? 1 : 0);
            self.emoticonPageControl.numberOfPages = (numberOfEmoticons/numberOfPage) + ((numberOfEmoticons%numberOfPage)==0 ? 0 : 1);
            self.emoticonPageControl.currentPage = 0;
            //[_emoticonCollectionView setCollectionViewLayout:[self emoticonCollectionViewLayout:emoticonMgr]];
        } else {
            self.emoticonPageControl.numberOfPages = 0;
        }
    }
    
    //[self.emoticonToolBar reloadData];
    [self.emoticonCollectionView reloadData];
    [_emoticonCollectionView setCollectionViewLayout:[self emoticonCollectionViewLayout:emoticonMgr]];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.emoticonPageControl setCurrentPage:currentPage];
}

#pragma UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ZCMEmoticonMgr *emoticonMgr = [self.dataSource emoticonMgrInEmoticonKeyboard:self atSection:self.selectedIndex];
    NSInteger count = _emoticonPageControl.numberOfPages*([emoticonMgr numberOfSections]*[emoticonMgr numberOfRowsInSection]);
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCMEmoticonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZCMEmoticonCollectionViewCell class]) forIndexPath:indexPath];
    cell.delegate = (id<ZCMEmoticonCollectionViewCellDelegate>)self;
    
    ZCMEmoticonMgr *emoticonMgr = [self.dataSource emoticonMgrInEmoticonKeyboard:self atSection:self.selectedIndex];
    
    NSInteger rows = [emoticonMgr numberOfRowsInSection];
    NSInteger sections = [emoticonMgr numberOfSections];
    NSInteger numberOfPage = rows * sections;
    NSInteger row = indexPath.row;
    NSInteger curPage = row/numberOfPage;
    
    BOOL showDelete = [self.dataSource shouldShowDeleteActionInEmoticonKeyboard:self atSection:self.selectedIndex];
    NSInteger sub = (showDelete == YES ? 1 : 0);
    //NSInteger index = row - row/numberOfPage;
    NSInteger index = (row-curPage * numberOfPage) % rows * sections + (row-curPage * numberOfPage) / rows + curPage * (numberOfPage-sub);
    
    if (showDelete && (row+1)%numberOfPage == 0) {
        ZCMEmoticon *emt = [[ZCMEmoticon alloc] init];
        emt.emoticonType = ZCMEmoticonDeleteType;
        emt.emoticonConverPicture = [UIImage imageNamed:@"DeleteEmoticonBtn"];
        cell.emoticon = emt;
    }
    else if (emoticonMgr.emoticons.count > index) {
        cell.emoticon = emoticonMgr.emoticons[index];
    } else {
        cell.emoticon = nil;
    }
    
    return cell;
}

#pragma mark - UICollectionView delegate
/**
 *  表情被点击 的delegate
 */
-(void)emoticonCollectionViewCell:(ZCMEmoticonCollectionViewCell *)cell didSelectedEmoticon:(ZCMEmoticon *)emoticon {
    if ([self.delegate respondsToSelector:@selector(emoticonKeyboard:didSelectedEmoticon:atIndexPath:)]) {
        if (emoticon.emoticonType == ZCMEmoticonDeleteType) {
            [self.delegate emoticonKeyboardDidPressBackspace:self];
        } else if (emoticon.emoticonType == ZCMEmoticonAddCustomType) {
            [self.delegate didSelectedCustomEmoticon];
        } else {
            [self.delegate emoticonKeyboard:self didSelectedEmoticon:emoticon atIndexPath:[_emoticonCollectionView indexPathForCell:cell]];
        }
    }
}

/**
 *  表情管理
 */
-(void)doEmoticonSetting {
    if ([self.delegate respondsToSelector:@selector(didSelectedSettingEmoticon)]) {
        [self.delegate didSelectedSettingEmoticon];
    }
}

#pragma mark - ZCMEmoticon Section Bar Delegate
/**
 *  点击某一类gif表情的回调方法
 *
 *  @param emoticonManager 被点击的管理表情Model对象
 *  @param section        被点击的位置
 */
- (void)didSelectedEmoticonMgr:(ZCMEmoticonMgr *)emoticonMgr atSection:(NSInteger)section {
    if (emoticonMgr.emoticonType != ZCMEmoticonSettingType) {
        self.selectedIndex = section;
        [self reloadData];
    } else {
        [self doEmoticonSetting];
    }
}

/**
 *  选择的section，是否需要选中状态
 *
 *  @param emoticonManager 被点击的管理表情Model对象
 *  @param section        被点击的位置
 */
- (BOOL)shouldShowSelectedStatusForEmoticonMgr:(ZCMEmoticonMgr *)emoticonMgr atSection:(NSInteger)section {
    if (emoticonMgr.emoticonType == ZCMEmoticonSettingType) {
        return NO;
    }
    
    return YES;
}

/**
 *  点击表情商店按钮
 */
- (void)didSelectedEmoticonStore {
    if ([self.delegate respondsToSelector:@selector(didSelectedEmoticonStore)]) {
        [self.delegate didSelectedEmoticonStore];
    }
}

/**
 *  点击发送表情按钮
 */
- (void)didSelectedSendEmoticon {
    if ([self.delegate respondsToSelector:@selector(didSelectedSendEmoticon)]) {
        [self.delegate didSelectedSendEmoticon];
    }
}

@end
