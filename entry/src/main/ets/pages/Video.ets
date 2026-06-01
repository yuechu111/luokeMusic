import { router, window } from '@kit.ArkUI'

interface VideoItem {
  name: string
  src: Resource | string
}

@Entry
@Component
export struct VideoPlayerPage {
  private controller: VideoController = new VideoController()

  @State isPlaying: boolean = false
  @State currentTime: number = 0
  @State duration: number = 0
  @State isSliderDragging: boolean = false
  @State isFullscreen: boolean = false
  @State isControlsVisible: boolean = true
  private controlsTimer: number = -1

  @State videoList: VideoItem[] = [
    { name: 'No Doubt-BOYNEXTDOOR', src: $rawfile('demo.mp4') }
  ]
  @State currentVideoIndex: number = 0

  formatTime(seconds: number): string {
    if (isNaN(seconds) || seconds < 0) return '00:00'
    const mins = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60)
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }

  togglePlay() {
    if (this.isPlaying) {
      this.controller.pause()
      this.isPlaying = false
    } else {
      this.controller.start()
      this.isPlaying = true
    }
  }

  stopVideo() {
    this.controller.stop()
    this.isPlaying = false
    this.currentTime = 0
  }

  toggleFullscreen() {
    this.isFullscreen = !this.isFullscreen
    if (this.isFullscreen) {
      this.showControlsTemporarily()
      this.setOrientation('landscape')
    } else {
      this.clearControlsTimer()
      this.isControlsVisible = true
      this.setOrientation('portrait')
    }
  }

  private setOrientation(orientation: 'landscape' | 'portrait') {
    const win: window.Window | undefined = AppStorage.get<window.Window>('window')
    if (!win) {
      console.warn('窗口对象未就绪，横竖屏切换失败')
      return
    }
    try {
      win.setPreferredOrientation(
        orientation === 'landscape'
          ? window.Orientation.LANDSCAPE
          : window.Orientation.PORTRAIT
      )
      console.info('设置屏幕方向成功:', orientation)
    } catch (e) {
      console.warn('设置屏幕方向失败:', JSON.stringify(e))
    }
  }

  private toggleControls() {
    this.isControlsVisible = !this.isControlsVisible
    if (this.isControlsVisible) {
      this.showControlsTemporarily()
    } else {
      this.clearControlsTimer()
    }
  }

  private showControlsTemporarily() {
    this.isControlsVisible = true
    this.clearControlsTimer()
    if (this.isPlaying) {
      this.controlsTimer = setTimeout(() => {
        this.isControlsVisible = false
      }, 3000)
    }
  }

  private clearControlsTimer() {
    if (this.controlsTimer !== -1) {
      clearTimeout(this.controlsTimer)
      this.controlsTimer = -1
    }
  }

  onSliderChange(value: number) {
    this.isSliderDragging = true
    this.currentTime = value
  }

  onSliderEnd() {
    this.isSliderDragging = false
    this.controller.setCurrentTime(this.currentTime)
    this.showControlsTemporarily()
  }

  switchVideo(index: number) {
    if (index < 0 || index >= this.videoList.length) return
    this.currentVideoIndex = index
    this.stopVideo()
    setTimeout(() => {
      this.controller.start()
      this.isPlaying = true
      this.showControlsTemporarily()
    }, 100)
  }

  build() {
    Stack() {
      if (this.isFullscreen) {
        // ========== 全屏横屏播放模式 ==========
        Stack() {
          Video({
            controller: this.controller,
            src: this.videoList[this.currentVideoIndex].src,
            previewUri: $r('app.media.pause')
          })
            .width('100%')
            .height('100%')
            .autoPlay(true)
            .controls(false)
            .loop(false)
            .objectFit(ImageFit.Cover)
            .onClick(() => { this.toggleControls() })
            .onPrepared((event) => {
              this.duration = event.duration
              this.isPlaying = true
              this.showControlsTemporarily()
            })
            .onUpdate((event) => {
              if (!this.isSliderDragging) {
                this.currentTime = event.time
              }
            })
            .onStart(() => { this.isPlaying = true })
            .onPause(() => { this.isPlaying = false })
            .onStop(() => { this.isPlaying = false; this.currentTime = 0 })
            .onFinish(() => { this.isPlaying = false; this.currentTime = 0 })
            .onError(() => {
              console.error('视频播放出错')
              this.isPlaying = false
            })

          // 全屏覆盖层控制栏
          if (this.isControlsVisible) {
            Column() {
              // 顶部栏：退出全屏 + 视频名称
              Row() {
                Image($r('app.media.arrow_bar_left'))
                  .width(28).height(28)
                  .fillColor(Color.White)
                  .onClick(() => { this.toggleFullscreen() })
                Text(this.videoList[this.currentVideoIndex].name)
                  .fontSize(18)
                  .fontColor(Color.White)
                  .layoutWeight(1)
                  .margin({ left: 12 })
              }
              .width('100%')
              .padding({
                left: 16, right: 16,
                top: this.isFullscreen ? 24 : 48
              })
              .height(72)

              Blank()

              // 底部控制栏
              Column() {
                // 进度条 + 时间
                Row() {
                  Text(this.formatTime(this.currentTime))
                    .fontSize(14).fontColor(Color.White)
                    .margin({ left: 16 })
                  Slider({
                    value: this.currentTime,
                    min: 0,
                    max: this.duration > 0 ? this.duration : 1,
                    step: 1
                  })
                    .layoutWeight(1)
                    .margin({ left: 12, right: 12 })
                    .trackThickness(4)
                    .blockColor(Color.White)
                    .trackColor('rgba(255,255,255,0.3)')
                    .selectedColor(Color.White)
                    .onChange((value: number) => { this.onSliderChange(value) })
                    .onTouch((event: TouchEvent) => {
                      if (event.type === TouchType.Down) {
                        this.clearControlsTimer()
                      }
                      if (event.type === TouchType.Up) {
                        this.onSliderEnd()
                      }
                    })
                  Text(this.formatTime(this.duration))
                    .fontSize(14).fontColor(Color.White)
                    .margin({ right: 16 })
                }
                .width('100%')
                .padding({ bottom: 12 })

                // 控制按钮组
                Row({ space: 40 }) {
                  this.controlButton(
                    $r('app.media.skip_back'),
                    48, () => {
                      if (this.currentVideoIndex > 0) {
                        this.switchVideo(this.currentVideoIndex - 1)
                      }
                    },
                    'rgba(255,255,255,0.2)'
                  )

                  Button() {
                    Image(this.isPlaying ? $r('app.media.pause') : $r('app.media.play'))
                      .width(40).height(40)
                      .fillColor(Color.White)
                  }
                  .type(ButtonType.Circle)
                  .backgroundColor('rgba(255,255,255,0.3)')
                  .width(64).height(64)
                  .onClick(() => {
                    this.togglePlay()
                    this.showControlsTemporarily()
                  })

                  this.controlButton(
                    $r('app.media.skip_forward'),
                    48, () => {
                      if (this.currentVideoIndex < this.videoList.length - 1) {
                        this.switchVideo(this.currentVideoIndex + 1)
                      }
                    },
                    'rgba(255,255,255,0.2)'
                  )
                }
                .width('100%')
                .justifyContent(FlexAlign.Center)
                .padding({ bottom: 48 })
              }
              .width('100%')
              .background('linear-gradient(to top, rgba(0,0,0,0.8) 0%, rgba(0,0,0,0) 100%)')
            }
            .width('100%')
            .height('100%')
            .transition(TransitionEffect.opacity(0.2).animation({ duration: 200 }))
          }
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Black)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .clip(false)
      } else {
        // ========== 竖屏模式 ==========
        Column() {
          // 标题栏
          Row() {
            Image($r('app.media.arrow_bar_left'))
              .width(24).height(24)
              .onClick(() => { router.back() })
            Text('MV播放器')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
            Blank().width(24)
          }
          .width('100%')
          .height(56)
          .padding({ left: 16, right: 16 })
          .backgroundColor(Color.White)

          // 分割线
          Divider()
            .width('100%')
            .color('#f0f0f0')
            .height(0.5)

          // 视频播放区域 — 使用 16:9 比例自适应
          Video({
            controller: this.controller,
            src: this.videoList[this.currentVideoIndex].src,
            previewUri: $r('app.media.pause')
          })
            .width('100%')
            .height(300)
            .autoPlay(true)
            .controls(false)
            .loop(false)
            .objectFit(ImageFit.Contain)
            .onClick(() => { this.toggleFullscreen() })
            .onPrepared((event) => {
              this.duration = event.duration
              this.isPlaying = true
            })
            .onUpdate((event) => {
              if (!this.isSliderDragging) {
                this.currentTime = event.time
              }
            })
            .onStart(() => { this.isPlaying = true })
            .onPause(() => { this.isPlaying = false })
            .onStop(() => { this.isPlaying = false; this.currentTime = 0 })
            .onFinish(() => { this.isPlaying = false; this.currentTime = 0 })
            .onError(() => {
              console.error('视频播放出错')
              this.isPlaying = false
            })

          // 视频信息
          Row() {
            Column() {
              Text(this.videoList[this.currentVideoIndex].name)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1a1a1a')
                .lineHeight(22)
              Text('MV')
                .fontSize(12)
                .fontColor('#999999')
                .margin({ top: 4 })
            }
            .layoutWeight(1)

            Image($r('app.media.fullscreen'))
              .width(24).height(24)
              .margin({ left: 16 })
              .onClick(() => { this.toggleFullscreen() })
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 16, bottom: 8 })

          // 进度条区域
          Row() {
            Text(this.formatTime(this.currentTime))
              .fontSize(12)
              .fontColor('#999999')
            Slider({
              value: this.currentTime,
              min: 0,
              max: this.duration > 0 ? this.duration : 1,
              step: 1
            })
              .layoutWeight(1)
              .margin({ left: 12, right: 12 })
              .trackThickness(3)
              .blockColor('#1a1a1a')
              .trackColor('#e8e8e8')
              .selectedColor('#1a1a1a')
              .onChange((value: number) => { this.onSliderChange(value) })
              .onTouch((event: TouchEvent) => {
                if (event.type === TouchType.Up) {
                  this.onSliderEnd()
                }
              })
            Text(this.formatTime(this.duration))
              .fontSize(12)
              .fontColor('#999999')
          }
          .width('100%')
          .padding({ left: 20, right: 20 })

          // 控制按钮组
          Row({ space: 28 }) {
            // 停止（方形图标）
            Button() {
              Stack()
                .width(18).height(18)
                .backgroundColor('#666666')
                .borderRadius(3)
            }
            .type(ButtonType.Circle)
            .backgroundColor('#f5f5f5')
            .width(48).height(48)
            .onClick(() => { this.stopVideo() })

            // 上一个
            Button() {
              Image($r('app.media.skip_back'))
                .width(24).height(24)
                .fillColor('#666666')
            }
            .type(ButtonType.Circle)
            .backgroundColor('#f5f5f5')
            .width(48).height(48)
            .onClick(() => {
              if (this.currentVideoIndex > 0) {
                this.switchVideo(this.currentVideoIndex - 1)
              }
            })

            // 播放/暂停 — 主按钮
            Button() {
              Image(this.isPlaying ? $r('app.media.pause') : $r('app.media.play'))
                .width(32).height(32)
                .fillColor(Color.White)
            }
            .type(ButtonType.Circle)
            .backgroundColor('#1a1a1a')
            .width(64).height(64)
            .onClick(() => { this.togglePlay() })

            // 下一个
            Button() {
              Image($r('app.media.skip_forward'))
                .width(24).height(24)
                .fillColor('#666666')
            }
            .type(ButtonType.Circle)
            .backgroundColor('#f5f5f5')
            .width(48).height(48)
            .onClick(() => {
              if (this.currentVideoIndex < this.videoList.length - 1) {
                this.switchVideo(this.currentVideoIndex + 1)
              }
            })

            // 占位保持对称（5个按钮）
            Button() { }
              .type(ButtonType.Circle)
              .backgroundColor(Color.Transparent)
              .width(48).height(48)
              .enabled(false)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ top: 24, bottom: 32 })

          Blank()
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#fafafa')
      }
    }
  }

  // ==================== 通用控制按钮 ====================
  @Builder
  private controlButton(
    icon: Resource,
    size: number,
    onClick: () => void,
    bgColor: string
  ) {
    Button() {
      Image(icon)
        .width(size * 0.6)
        .height(size * 0.6)
        .fillColor(Color.White)
    }
    .type(ButtonType.Circle)
    .backgroundColor(bgColor)
    .width(size)
    .height(size)
    .onClick(onClick)
  }
}
