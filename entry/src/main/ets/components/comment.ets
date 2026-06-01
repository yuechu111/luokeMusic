// comment.ets - 评论区组件（优化版）
@Preview
@Component
export struct CommentSection {
  @State commentList: CommentItem[] = [
    {
      id: '1', user: '音乐爱好者', avatar: $r('app.media.person'),
      content: '这首歌太好听了，单曲循环中！', time: '2分钟前', liked: false, likeCount: 5
    },
    {
      id: '2', user: '夜的第七章', avatar: $r('app.media.person'),
      content: '歌词写得真美，很有共鸣。', time: '15分钟前', liked: false, likeCount: 3
    },
    {
      id: '3', user: '晴天娃娃', avatar: $r('app.media.person'),
      content: '第一次听就被惊艳到了，旋律太上头了🎵', time: '1小时前', liked: false, likeCount: 8
    },
    {
      id: '4', user: '追风少年', avatar: $r('app.media.person'),
      content: '每次心情不好的时候都会听这首歌，总能让我平静下来。', time: '3小时前', liked: false, likeCount: 2
    },
    {
      id: '5', user: '星辰大海', avatar: $r('app.media.person'),
      content: '现场版比录音棚更有感染力，推荐去看演唱会！', time: '5小时前', liked: false, likeCount: 12
    },
    {
      id: '6', user: '午后红茶', avatar: $r('app.media.person'),
      content: '听到前奏就爱上了，已经设为铃声了😄', time: '昨天', liked: false, likeCount: 6
    },
    {
      id: '7', user: '漫步云端', avatar: $r('app.media.person'),
      content: '这个编曲真的很高级，和声部分绝了。', time: '昨天', liked: false, likeCount: 4
    },
  ]

  @State inputText: string = ''
  @State isPosting: boolean = false
  private nextId: number = 8

  build() {
    Column() {
      // ====== 标题栏 ======
      Row() {
        Text(`${this.commentList.length}条`)
          .fontSize(13)
          .fontColor('#80ffffff')
      }
      .width('100%')
      .padding({ bottom: 8 })
      .margin({ top: 10 })

      // ====== 输入框（置顶） ======
      Row({ space: 10 }) {
        TextInput({ placeholder: '发表你的评论...', text: this.inputText })
          .placeholderColor('#60ffffff')
          .placeholderFont({ size: 14 })
          .fontSize(14)
          .fontColor(Color.White)
          .height(40)
          .layoutWeight(1)
          .backgroundColor('#1affffff')
          .borderRadius(20)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.inputText = value
          })
          .onSubmit(() => {
            this.postComment()
          })

        // 发送按钮
        Row({ space: 4 }) {
          Text('发送')
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#0d1b2a')
        }
        .height(40)
        .padding({ left: 14, right: 14 })
        .borderRadius(20)
        .backgroundColor('#54f59b')
        .opacity(this.inputText.trim().length > 0 ? 1 : 0.4)
        .onClick(() => {
          this.postComment()
        })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .margin({ top: 10 })
      .padding({ bottom: 4 })

      // ====== 评论列表 ======
      if (this.commentList.length === 0) {
        // 空状态
        Column({ space: 8 }) {
          Image($r('app.media.chat_dots'))
            .width(48)
            .height(48)
            .fillColor('#33ffffff')
            .opacity(0.4)
          Text('暂无评论，快来发表第一条吧')
            .fontSize(14)
            .fontColor('#60ffffff')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 30, bottom: 30 })
      } else {
        ForEach(this.commentList, (item: CommentItem) => {
          this.CommentItem(item)
          this.DividerLine()
        }, (item: CommentItem) => item.id)
      }
    }
    .width('100%')
  }

  // ==================== 单条评论 ====================
  @Builder
  CommentItem(item: CommentItem) {
    Column() {
      Row({ space: 10 }) {
        // 头像
        Image(item.avatar)
          .width(36)
          .height(36)
          .borderRadius(18)
          .backgroundColor('#33ffffff')

        // 评论内容区
        Column({ space: 6 }) {
          // 用户名 + 时间
          Row({ space: 8 }) {
            Text(item.user)
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .fontColor('#54f59b')
            Text(item.time)
              .fontSize(11)
              .fontColor('#60ffffff')
          }
          .alignItems(VerticalAlign.Center)

          // 评论正文
          Text(item.content)
            .fontSize(14)
            .fontColor(Color.White)
            .lineHeight(20)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
      .padding({ top: 10, bottom: 6 })
      .alignItems(VerticalAlign.Top)

      // 操作按钮行
      Row({ space: 20 }) {
        // 点赞
        Row({ space: 4 }) {
          Image($r('app.media.heart'))
            .width(14)
            .fillColor(item.liked ? '#ff4757' : '#80ffffff')
          Text(`${item.likeCount}`)
            .fontSize(11)
            .fontColor(item.liked ? '#ff4757' : '#80ffffff')
        }
        .onClick(() => {
          this.toggleLike(item)
        })

        // 回复
        Row({ space: 4 }) {
          Image($r('app.media.chat_dots'))
            .width(14)
            .fillColor('#80ffffff')
          Text('回复')
            .fontSize(11)
            .fontColor('#80ffffff')
        }
      }
      .width('100%')
      .padding({ left: 46, bottom: 6 })
    }
  }

  // ==================== 分割线 ====================
  @Builder
  DividerLine() {
    Row()
      .width('100%')
      .height(1)
      .backgroundColor('#1affffff')
  }

  // ==================== 点赞切换 ====================
  toggleLike(target: CommentItem) {
    let list: CommentItem[] = []
    for (let i = 0; i < this.commentList.length; i++) {
      let item = this.commentList[i]
      if (item.id === target.id) {
        let updated: CommentItem = {
          id: item.id,
          user: item.user,
          avatar: item.avatar,
          content: item.content,
          time: item.time,
          liked: !item.liked,
          likeCount: item.liked ? item.likeCount - 1 : item.likeCount + 1
        }
        list.push(updated)
      } else {
        list.push(item)
      }
    }
    this.commentList = list
  }

  // ==================== 发表评论 ====================
  postComment() {
    let text = this.inputText.trim()
    if (text.length === 0 || this.isPosting) {
      return
    }
    this.isPosting = true

    let newComment: CommentItem = {
      id: `${this.nextId++}`,
      user: 'Lucky月初',
      avatar: $r('app.media.luoke'),
      content: text,
      time: '刚刚',
      liked: false,
      likeCount: 0
    }
    // 展开赋值触发 @State 刷新
    this.commentList = [newComment, ...this.commentList]
    this.inputText = ''
    this.isPosting = false
  }
}

// 评论数据类型定义
interface CommentItem {
  id: string
  user: string
  avatar: Resource
  content: string
  time: string
  liked: boolean
  likeCount: number
}
