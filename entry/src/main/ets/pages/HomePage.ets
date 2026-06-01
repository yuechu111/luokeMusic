import { HomePageC } from '../components/HomePageC'
import { FlexTabs } from '../components/FlexTabs'
import { AvPlayerManager } from '../utils/AvPlayerManager'
import { Music,createMusicList } from '../data/PageContent'
import { common } from '@kit.AbilityKit'
import { media } from '@kit.MediaKit'
import { Core } from '@ohos/hypium'


@Entry
@Component
struct HomePage {
  private player: AvPlayerManager = new AvPlayerManager()
  @Provide('player') playerManager: AvPlayerManager = this.player
  private progressTimer: number = -1

  @State musicList: Music[] = createMusicList()
  @State currentTime: number = 0
  @State currentIndex: number = 0
  @State isPlaying: boolean = false
  @State errorMsg: string = ''
  @State duration: number = 0
  @State initialized: boolean = false
  @State isSliderDragging: boolean = false
  @State music: Music = this.musicList[this.currentIndex]
  @State isheart: boolean = false

  //控制遮罩层的
  @State isGet:boolean = false
  @State positiobX:number = 0
  @State positiobY:number = 800  //800

  // ========== 触发器变量（带 @Watch，子组件修改后自动触发回调）==========
  @Watch('onNextTrigger')
  @Provide('nextTrigger') nextTrigger: number = 0

  @Watch('onPrevTrigger')
  @Provide('prevTrigger') prevTrigger: number = 0

  @Watch('onPlayTrigger')
  @Provide('playTrigger') playTrigger: number = 0

  // 提供数据给孙组件
  @Provide('currentMusic') currentMusic: Music = this.music
  @Provide('globalIsPlaying') globalIsPlaying: boolean = false
  @Provide('globalCurrentTime') globalCurrentTime: number = 0
  @Provide('globalDuration') globalDuration: number = 0

  // 触发器回调方法
  private onNextTrigger() {
    if (this.nextTrigger > 0) {
      this.next()
    }
  }

  private onPrevTrigger() {
    if (this.prevTrigger > 0) {
      this.previous()
    }
  }

  private onPlayTrigger() {
    if (this.music?.id !== this.currentMusic.id) {
      this.music = this.currentMusic
      this.currentIndex = this.musicList.findIndex(m => m.id === this.currentMusic.id)
      this.playCurrent()
    } else {
      // 同一首歌，切换播放状态
      this.togglePlay()
    }
  }

  //在页面开始就初始化播放器
  // HomePage.ets
  aboutToAppear() {
    this.initPlayer()

    // ✅ 存储一个标志位
    AppStorage.setOrCreate('shouldStopMusic', false)
  }

  // 监听标志位变化
  @Watch('onShouldStopMusicChange')
  @StorageProp('shouldStopMusic') shouldStopMusic: boolean = false

  private onShouldStopMusicChange() {
    if (this.shouldStopMusic) {
      this.stopMusicForNavigation()
      // 重置标志
      AppStorage.setOrCreate('shouldStopMusic', false)
    }
  }

  private async stopMusicForNavigation() {
    console.log('停止音乐播放器')

    if (this.progressTimer !== -1) {
      clearInterval(this.progressTimer)
      this.progressTimer = -1
    }

    await this.player.pause()
    this.isPlaying = false
    this.currentTime = 0
    this.globalIsPlaying = false
  }

  aboutToDisappear() {
    // ✅ 页面消失时停止播放
    this.player.stop()
  }


  //初始化播放器
  private async initPlayer() {
    this.initialized = true
    // 自动开始播放第一首（playRawFile 内部会创建播放器）
    // this.playCurrent()
  }

  //播放
  private async playCurrent() {
    this.music = this.musicList[this.currentIndex]
    this.currentMusic = this.music
    if (!this.music) {
      this.errorMsg = '播放列表为空'
      return
    }
    try {
      // 使用本地 rawfile 播放 - 通过 getRawFd 获取文件描述符
      const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
      const rawFileFd = await context.resourceManager.getRawFd(this.music.fileName)
      const fdSrc: media.AVFileDescriptor = {
        fd: rawFileFd.fd,
        offset: rawFileFd.offset,
        length: rawFileFd.length
      }
      await this.player.playRawFile(fdSrc)
      this.isPlaying = true
      this.globalIsPlaying = true
      this.duration = this.player.getDuration()
      this.globalDuration = this.duration
      this.startProgressUpdate()
    } catch (e) {
      const msg = e instanceof Error ? e.message : JSON.stringify(e)
      this.isPlaying = false
      this.globalIsPlaying = false
    }
  }

  private startProgressUpdate() {
    // 清除旧定时器
    if (this.progressTimer !== -1) {
      clearInterval(this.progressTimer)
    }
    // 每 500ms 更新一次进度
    this.progressTimer = setInterval(() => {
      if (!this.isSliderDragging) {
        this.currentTime = this.player.getCurrentTime()
        this.duration = this.player.getDuration()
      }
      if (!this.player.getIsPlaying() && this.isPlaying) {
        // 播放完成，自动切歌
        this.isPlaying = false
        clearInterval(this.progressTimer)
        this.progressTimer = -1
        this.next()
      }
    }, 500)
  }
  //上一首
  async previous() {
    // 1. 先停止当前播放
    await this.player.stop()

    // 2. 清除进度更新定时器
    if (this.progressTimer !== -1) {
      clearInterval(this.progressTimer)
      this.progressTimer = -1
    }

    // 3. 重置状态
    this.isPlaying = false
    this.currentTime = 0

    // 4. 切换索引并播放新歌（注意减号的处理）
    this.currentIndex = (this.currentIndex - 1 + this.musicList.length) % this.musicList.length
    await this.playCurrent()
  }

  //下一首
  async next() {
    // 1. 先停止当前播放
    await this.player.stop()

    // 2. 清除进度更新定时器
    if (this.progressTimer !== -1) {
      clearInterval(this.progressTimer)
      this.progressTimer = -1
    }

    // 3. 重置状态
    this.isPlaying = false
    this.currentTime = 0

    // 4. 切换索引并播放新歌
    this.currentIndex = (this.currentIndex + 1) % this.musicList.length
    await this.playCurrent()
  }

  togglePlay() {
    if (this.isPlaying) {
      // 正在播放 -> 暂停
      this.player.pause()
      this.isPlaying = false
      this.globalIsPlaying = false
    } else {
      // 暂停状态 -> 判断是否已经播放过
      if (this.duration > 0) {
        // 已播放过，直接恢复
        this.player.resume()
        this.isPlaying = true
        this.globalIsPlaying = true
      } else {
        // 首次播放，初始化并播放
        this.playCurrent()
      }
    }
  }




  build() {
      //Tab组件
        Stack({
          alignContent: Alignment.Bottom
        }) {
          Column() {
          //头部搜索栏
          HomePageC()
            .position({ x: 0, y: 15 })
            .width('100%')
            .margin({bottom:20})
        //页面总tabs
        FlexTabs()
          .position({ x: 0, y: 60 })  // 向下偏移60，给搜索栏留空间
          .width('100%')
          .margin({ bottom: 30 })
        //播放器
          Row(){
          Blank()
            //音乐滚动
          Row(){
            Marquee({
              start: true,  // 是否开始滚动
              step: 6,      // 滚动步长（像素）
              loop: -1,      // 循环次数，-1表示无限循环
              src: !this.music?.name ? '暂无播放歌曲' : this.music?.name + ' - ' + this.music?.singer
            })
              .fontSize(16)
              .fontColor(Color.White)
              .marqueeUpdateStrategy(MarqueeUpdateStrategy.DEFAULT)
          }
            .width(120)
            // .backgroundColor(Color.Yellow)
            .margin({right:10})
          Row({space:10}){
            Image(this.isheart === true ? $r('app.media.heart_fill') :$r('app.media.heart'))
              .width(25)
              .fillColor(Color.Green)
              .onClick(() => {this.isheart = !this.isheart})
              .fillColor(this.isheart ===true ? Color.Red : Color.Green)
            Image(this.isPlaying ? $r('app.media.pause') : $r('app.media.play'))
              .width(40)
              .fillColor(Color.Green)
              .onClick(() => {
                this.togglePlay()
              })
            Image($r('app.media.list'))
              .width(30)
              .fillColor(Color.Green)
          }
          .margin({right: 10})
          }
          .backgroundColor("#ff313a56")
          .width("100%")
          .margin({bottom: 80})
          .height(70)
          .borderRadius({
            topLeft: 15,
            topRight: 15
          })
          .position({ x: 0, y: 650 })

          Image(this.music?.cover)
            .width(80)
            .height(80)
            .borderRadius(10)
            .position({ x: 25, y: 630 })
            .onClick(() => {
                this.positiobY = 0
            })
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.globalBackground'))  // 设置背景图
    .backgroundImageSize(ImageSize.Cover)         // 覆盖整个屏幕

      musicDetailPpage({ positionX: this.positiobX,
        positionY: this.positiobY,
        currentIndex:this.currentIndex ,
        musicList: this.musicList,
        currentTime:this.currentTime,
        duration:this.duration,
        isSliderDragging:this.isSliderDragging,
        isPlaying:this.isPlaying

      })
        }
        .width('100%')
        .height('100%')
  }
}

@Component
struct  musicDetailPpage{
  @Link positionX:number
  @Link positionY:number
  @Link currentIndex:number
  @Prop musicList: Music[]
  @Prop isPlaying: boolean
  @Link currentTime: number
  @Link duration:number
  @Link isSliderDragging: boolean
  @Consume('player') player: AvPlayerManager
  @Consume('playTrigger') playTrigger: number
  @Consume('prevTrigger') prevTrigger: number
  @Consume('nextTrigger') nextTrigger: number


  formatTime(ms: number): string {
    // 毫秒转秒
    const seconds = Math.floor(ms / 1000)
    const m = Math.floor(seconds / 60)
    const s = seconds % 60
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
  }

  onSliderChange(value: number) {
    this.isSliderDragging = true
    this.currentTime = value
  }

  onSliderEnd() {
    this.isSliderDragging = false
    try {
      this.player.seek(this.currentTime)
    } catch (e) {
      console.error('seek 失败:', JSON.stringify(e))
    }
  }



  build() {
    Column(){
      Row(){
        Image($r('app.media.chevron_down'))
          .width(40)
          .fillColor(Color.White)
          .onClick(() => {this.positionY = 800})
      }
      .width("100%")
      .margin({top:20})
      .padding({left: 20})

      Blank()

      Column(){
          Column({space:10}){
             Row({space:20}){
               Text(this.musicList[this.currentIndex].name)
                 .fontSize(24)
                 .fontWeight(FontWeight.Bold)
                 .fontColor(Color.White)
                 .layoutWeight(1)
               Image($r('app.media.chat_dots'))
                 .width(30)
                 .fillColor("#99ffffff")
               Image($r('app.media.heart'))
                 .width(30)
                 .fillColor("#99ffffff")
             }
             .width('100%')
              Text(this.musicList[this.currentIndex].singer)
                .fontSize(18)
                .fontColor(Color.White)

            //存放歌词的地方
            Scroll() {
              Column() {
                Text(this.musicList[this.currentIndex].lyrics || '暂无歌词')
                  .fontSize(14)
                  .fontColor(Color.White)
                  .lineHeight(30)
                  .width('100%')
                  .textAlign(TextAlign.Center)
              }
              .width('100%')
              .padding({ top: 10, bottom: 10 })
            }
            .height(80)
            .scrollBar(BarState.Off)  // 隐藏滚动条
            .edgeEffect(EdgeEffect.None)  // 无边缘效果
          }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        // .backgroundColor(Color.Green)
        .height(170)
        .padding({left: 20,right:20})
        //进度条
        Column(){
          Slider({
            value: this.currentTime,
            min: 0,
            max: this.duration ? this.duration : 1,
            step: 1,
            style: SliderStyle.OutSet
          })
            .width("80%")
            .trackThickness(4)
            .blockColor('#1e90ff')
            .trackColor('#e0e0e0')
            .selectedColor('#1e90ff')
            .onChange((value: number) => {
              this.onSliderChange(value)
            })
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Up) {
                this.onSliderEnd()
              }
            })
          Row(){
            Text(this.formatTime(this.currentTime))
              .fontSize(13)
              .fontColor('#999999')
            Text(this.formatTime(this.duration))
              .fontSize(13)
              .fontColor('#999999')
          }
          .padding({left: 20,right:20})
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .height(100)
        // .backgroundColor(Color.Black)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        //按钮
        Row({space:40}){
            Image($r('app.media.caret_left_fill'))
              .width(40)
              .fillColor(Color.White)
              .onClick(() => {
                this.prevTrigger++;
              })
            Image(this.isPlaying !==true ? $r('app.media.play_fill') : $r('app.media.pause'))
              .width(60)
              .fillColor(Color.White)
              .onClick(() => {
                this.playTrigger++;
              })
            Image($r('app.media.caret_right_fill'))
              .width(40)
              .fillColor(Color.White)
            .onClick(() => {
                this.nextTrigger++;
              })
        }
        .width('100%')
        .height(150)
        // .backgroundColor(Color.Blue)
        .justifyContent(FlexAlign.Center)
        .padding({bottom:40})
      }
      // .backgroundColor("#e6c4bdbd")
      .borderRadius(50)
      .backdropBlur(60)
      .padding({ top: 20 })
      .linearGradient({
        colors: [
          ['#ff98efef', 0.0],   // 完全透明（底部）
          ['#4d98efef', 1.0]    // 半透明白（顶部）
        ],
        direction: GradientDirection.Top  // 渐变方向：从下到上
      })

    }

    .width('100%')
    .height('110%')
    .backgroundImage(this.musicList[this.currentIndex].cover_bg)
    .backgroundImageSize(ImageSize.Cover)
    // .position({ x: 0, y: 20 })
    .position({ x: this.positionX, y: this.positionY })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .animation({
      duration: 300,
    })
  }
}