import { HomePageC } from '../components/HomePageC'
import { FlexTabs } from '../components/FlexTabs'
import { AvPlayerManager } from '../utils/AvPlayerManager'
import { Music,createMusicList } from '../data/PageContent'
import { common } from '@kit.AbilityKit'
import { media } from '@kit.MediaKit'

@Entry
@Component
struct HomePage {
  private player: AvPlayerManager = new AvPlayerManager()
  private progressTimer: number = -1

  @State currentTime: number = 0
  @State musicList: Music[] = []
  @State currentIndex: number = 0
  @State isPlaying: boolean = false
  @State errorMsg: string = ''
  @State duration: number = 0
  @State initialized: boolean = false
  @State isSliderDragging: boolean = false
  @State music: Music | null = this.musicList[this.currentIndex]
  //在页面开始就初始化播放器
  aboutToAppear() {
    this.musicList = createMusicList()
    this.initPlayer()
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
      this.duration = this.player.getDuration()
      this.startProgressUpdate()
    } catch (e) {
      const msg = e instanceof Error ? e.message : JSON.stringify(e)
      this.isPlaying = false
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

  //更改播放逻辑
  togglePlay() {
    if (this.isPlaying) {
      // 正在播放 -> 暂停
      this.player.pause()
      this.isPlaying = false
    } else {
      // 暂停状态 -> 判断是否已经播放过
      if (this.duration > 0) {
        // 已播放过，直接恢复
        this.player.resume()
        this.isPlaying = true
      } else {
        // 首次播放，初始化并播放
        this.playCurrent()
      }
    }
  }


  build() {
    Column() {
      //头部搜索栏
      HomePageC()
      //Tab组件
        Stack({
          alignContent: Alignment.Bottom
        }) {
        //页面总tabs
        FlexTabs()
          .margin({bottom: 30})
        //播放器
          Row(){
          Blank()
            //音乐滚动
          Row(){
            Marquee({
              start: true,  // 是否开始滚动
              step: 6,      // 滚动步长（像素）
              loop: 1,      // 循环次数，-1表示无限循环
              src: this.music?.name + ' - ' + this.music?.singer
            })
              .fontSize(16)
              .fontColor(Color.Black)
              .marqueeUpdateStrategy(MarqueeUpdateStrategy.DEFAULT)
          }
            .width(110)
            .backgroundColor(Color.Yellow)
            .margin({right:10})
          Row({space:10}){
            Image($r('app.media.heart'))
              .width(25)
              .onClick(() => {this.previous()})
            Image(this.isPlaying ? $r('app.media.pause') : $r('app.media.play'))
              .width(40)
              .onClick(() => {
                this.togglePlay()
              })
            Image($r('app.media.list'))
              .width(30)
              .onClick(() => {this.next()})
          }
          .margin({right: 10})
          }
          .backgroundColor(Color.Pink)
          .width("100%")
          .margin({bottom: 80})
          .height(70)
          .borderRadius({
            topLeft: 15,
            topRight: 15
          })

          Image(this.music?.cover)
            .width(90)
            .margin({right:230,bottom: 89})
            .borderRadius(10)
      }
    }
  }
}