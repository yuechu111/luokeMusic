// my.ets - 我的主页
@Preview
@Component
export struct MyPage {
  build() {
    Scroll() {
      Column({ space: 16 }) {
        // ====== 顶部整合卡片 ======
        this.TopCard()

        // ====== 一级功能入口（四宫格） ======
        this.PrimaryFunctions()

        // ====== 最近播放模块 ======
        this.RecentPlayModule()

        // ====== 歌单列表模块 ======
        this.PlaylistModule()
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 100 })
    }
    .layoutWeight(1)
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .padding({ top: 30 }) // 避开状态栏
  }

  // ==================== 顶部整合卡片（约占屏幕1/4） ====================
  @Builder
  TopCard() {
    Column() {
      // 内容垂直居中
      Column() {
        // --- 用户信息 ---
        Row() {
          // 左侧：头像 + 用户名
          Row({ space: 8 }) {
            Image($r('app.media.luoke'))
              .width(36)
              .height(36)
              .borderRadius(18)
            Row({ space: 4 }) {
              Text('Lucky月初')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Image($r('app.media.caret_right_fill'))
                .width(12)
                .fillColor('#99ffffff')
            }
          }
          .layoutWeight(1)

        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        // --- 分割线 ---
        Row()
          .width('100%')
          .height(1)
          .backgroundColor('#1affffff')
          .margin({ top: 8, bottom: 6 })

        // --- 次级功能 + 会员中心 同一行 ---
        Row() {
          // 二级功能入口（左半）
          Row() {
            this.FuncIconText($r('app.media.journal_album'), '装扮')
            this.FuncIconText($r('app.media.star'), '日签')
            this.FuncIconText($r('app.media.person'), '关注')
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.SpaceEvenly)

          // 会员中心入口（右半）
          Column({ space: 2 }) {
            Text('会员中心 >')
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor('#99ffffff')
          }
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(1)
        }
        .width('100%')
        .padding({ top: 2, bottom: 2 })
        .alignItems(VerticalAlign.Center)
        .padding({top: 10})
      }
      .width('100%')
    }
    .width('100%')
    .padding(10)
    .borderRadius(14)
    .backgroundColor('#33ffffff')
    .backdropBlur(30)
  }

  @Builder
  FuncIconText(icon: Resource, label: string) {
    Column({ space: 4 }) {
      Image(icon)
        .width(20)
        .fillColor('#54f59b')
      Text(label)
        .fontSize(11)
        .fontColor('#ccffffff')
    }
    .alignItems(HorizontalAlign.Center)
  }

  // ==================== 一级功能入口（一行4项） ====================
  @Builder
  PrimaryFunctions() {
    Row({ space: 8 }) {
      this.PrimaryGridItem($r('app.media.heart_fill'), '收藏')
      this.PrimaryGridItem($r('app.media.arrow_down_square_fill'), '本地')
      this.PrimaryGridItem($r('app.media.file_music_fill'), '有声')
      this.PrimaryGridItem($r('app.media.bag_heart_fill'), '已购')
    }
    .width('100%')
  }

  @Builder
  PrimaryGridItem(icon: Resource, label: string) {
    Column({ space: 4 }) {
      Image(icon)
        .width(22)
        .fillColor('#54f59b')
      Text(label)
        .fontSize(14)
        .fontColor(Color.White)
    }
    .alignItems(HorizontalAlign.Center)
    .width(80)
    .height(85)
    .padding(12)
    .borderRadius(12)
  }

  // ==================== 最近播放模块 ====================
  @Builder
  RecentPlayModule() {
    Column({ space: 10 }) {
      // 标题栏
      Row() {
        Text('最近播放')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Blank()
        Image($r('app.media.chevron_right'))
          .width(18)
          .fillColor('#99ffffff')
      }
      .width('100%')

      // 横向滚动列表
      Scroll() {
        Row({ space: 12 }) {
          this.PlayCard($r('app.media.musiclist_1_1'), '热歌推荐')
          this.PlayCard($r('app.media.musiclist_2_1'), '经典老歌')
          this.PlayCard($r('app.media.musiclist_3_1'), '流行榜单')
          this.PlayCard($r('app.media.playlist_1'), '每日推荐')
          this.PlayCard($r('app.media.playlist_2'), '私人FM')
        }
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
    }
  }

  @Builder
  PlayCard(img: Resource, name: string) {
    Column({ space: 6 }) {
      Image(img)
        .width(110)
        .height(110)
        .borderRadius(10)
      Text(name)
        .fontSize(12)
        .fontColor('#ccffffff')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(110)
    }
    .alignItems(HorizontalAlign.Start)
  }

  // ==================== 歌单列表模块 ====================
  @Builder
  PlaylistModule() {
    Column({ space: 10 }) {
      // 标题栏
      Row() {
        Row({ space: 8 }) {
          Text('收藏歌单')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        Blank()
        Row({ space: 12 }) {
          Text('+')
            .fontSize(22)
            .fontColor("#99ffffff")
          Image($r('app.media.box_arrow_in_right'))
            .width(18)
            .fillColor('#99ffffff')
          Image($r('app.media.chevron_right'))
            .width(18)
            .fillColor('#99ffffff')
        }
      }
      .width('100%')

      // 歌单列表项
      this.SongListItem($r('app.media.musiclist_1_1'), '每日推荐歌单', '更新 20首', '周杰伦 / 林俊杰')
      this.DividerLine()
      this.SongListItem($r('app.media.musiclist_2_3'), '深夜情歌', '更新 15首', '邓紫棋 / 陈奕迅')
      this.DividerLine()
      this.SongListItem($r('app.media.musiclist_3_3'), '运动必听', '更新 12首', 'Taylor Swift / Ed Sheeran')
    }
  }

  @Builder
  SongListItem(cover: Resource, title: string, update: string, artist: string) {
    Row({ space: 12 }) {
      Image(cover)
        .width(56)
        .height(56)
        .borderRadius(8)
      Column({ space: 4 }) {
        Text(title)
          .fontSize(15)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(update)
          .fontSize(11)
          .fontColor('#80ffffff')
        Text(artist)
          .fontSize(11)
          .fontColor('#60ffffff')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
  }

  @Builder
  DividerLine() {
    Row()
      .width('100%')
      .height(1)
      .backgroundColor('#1affffff')
  }
}
