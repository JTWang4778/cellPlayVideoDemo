//
//  JTPlayerCell.m
//  cell播放视频
//
//  Created by 王锦涛 on 16/6/18.
//  Copyright © 2016年 JTWang. All rights reserved.
//

#import "JTPlayerCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+Extension.h"

@interface JTPlayerCell()

@property (nonatomic,strong) MPMoviePlayerController *mpc;

@property (nonatomic,weak)UIButton *coverButton;

@end
@implementation JTPlayerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        NSString *urlString = @"http://baobab.wdjcdn.com/1455782903700jy.mp4";
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        self.mpc = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        self.mpc.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
        
        UIButton *button = [UIButton new];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"播放" forState:UIControlStateNormal];
        [button setTitle:@"播放" forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(didClickPlayButton) forControlEvents:UIControlEventTouchUpInside];
        button.center = self.mpc.view.center;
        [button sizeToFit];
        
        [self.mpc.view addSubview:button];
        
        
        [self.contentView addSubview:self.mpc.view];
        
        self.mpc.controlStyle = MPMovieControlStyleEmbedded;
        
//        [self.mpc prepareToPlay];
//        [self.mpc play];
        
        [self addNotification];
        
    }
    return self;
}

#pragma mark - 控制器通知
/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.mpc];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.mpc];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.mpc];
    
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.mpc.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
        {
            NSLog(@"停止播放.");
            
        }
            break;
        default:
            NSLog(@"播放状态:%li",self.mpc.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.mpc.playbackState);
    // 创建一个遮罩button 添加到播放器的view上
    UIButton *coverView = [[UIButton alloc] initWithFrame:self.mpc.view.bounds];
    coverView.backgroundColor = [UIColor blackColor];
                coverView.alpha = 0.5;
    [coverView addTarget:self action:@selector(didClickCoverButtton) forControlEvents:UIControlEventTouchUpInside];
    [self.mpc.view addSubview:coverView];
    self.coverButton = coverView;
}


// 遮罩buttong的点击事件
- (void)didClickCoverButtton
{
    [self.mpc play];
    self.coverButton.hidden = YES;
}

- (void)didClickPlayButton
{
    [self.mpc play];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}


@end
