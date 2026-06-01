import { Music,createMusicList,card_bg_color, Playlist, RankItem,SongInfo, Singer,
  createSingerList } from '../data/PageContent'
import {createPlaylistData,createRankData} from '../data/PageContent'

//tabs结构内容
@Preview
@Component
export struct HouseContent {
  @State tabName: string = ''
  @State tabContent: string = ''
  @State currentTab: number = 0
  @State musicList: Music[] = createMusicList()
  PlaylistData: Playlist[] = createPlaylistData()
  createRankData: RankItem[] = createRankData()
  singerList:Singer[] = createSingerList()

  // ========== 新增：消费祖父组件提供的数据 ==========
  @Consume('currentMusic') currentMusic: Music
  @Consume('globalIsPlaying') globalIsPlaying: boolean
  @Consume('globalCurrentTime') globalCurrentTime: number
  @Consume('globalDuration') globalDuration: number

  // ========== 新增：消费触发器（用于调用祖父组件方法）==========
  @Consume('nextTrigger') nextTrigger: number
  @Consume('prevTrigger') prevTrigger: number
  @Consume('playTrigger') playTrigger: number

  build() {
      Tabs({ index: this.currentTab,barPosition: BarPosition.Start }) {
        TabContent() {
          Scroll(){
            Column(){
             Grid(){
               ForEach(this.musicList, (item: Music, index) => {
                 GridItem(){
                 Column(){
                  Row(){
                    Text("For you")
                      .fontColor(Color.White)
                    Image(item.cover)
                      .width(70)
                      .margin({top:5})
                      .height(70)


                  }
                  .width("100%")
                   .height(70)
                   .justifyContent(FlexAlign.SpaceBetween)
                   .padding({left: 10,right: 10})

                   Row(){
                    Column(){
                      Text("猜你喜欢")
                        .fontColor(Color.White)
                      Marquee({
                        start: true,  // 是否开始滚动
                        step: 6,      // 滚动步长（像素）
                        loop: -1,      // 循环次数，-1表示无限循环
                        src: item.name,
                      })
                        .fontSize(16)
                        .fontColor(Color.White)
                        .marqueeUpdateStrategy(MarqueeUpdateStrategy.DEFAULT)

                    }
                    // .backgroundColor(Color.Green)
                     .width(100)
                     //子组件居右显示
                     .alignItems(HorizontalAlign.Start)
                    Row(){
                      if (this.currentMusic?.id === item.id) {
                        Image(this.globalIsPlaying ===  true ? $r('app.media.pause') : $r('app.media.play'))
                          .width(40)
                          .fillColor(Color.Green)
                          .padding({left:3})
                      }else{
                        Image($r('app.media.play'))
                          .width(40)
                          .fillColor(Color.Green)
                          .padding({left:3})
                      }
                    }
                    .width(40)
                    .height(40)
                    .borderRadius(20)
                     .backgroundColor("#99ffffff")
                     // .backgroundColor(Color.Black)


                   }
                   .width("100%")
                   .justifyContent(FlexAlign.SpaceBetween)
                   .padding({left: 10,right: 10})
                   .margin({top: 20})
                 }
                 .margin({left:15})
                 .width(200)
                 .height(150)
                  .backgroundColor(card_bg_color[index])
                   .borderRadius(10)
               } .onClick(() => {this.currentMusic = item;this.playTrigger++})})

             }
             // .backgroundColor(Color.Black)
             .width('100%')
             .height(180)
             .rowsTemplate('1fr')
             .scrollBar(BarState.Off)
              .columnsGap(10)

              ForEach(['大家都在听','听《潮流季》也会喜欢','这些反复听过的歌一定值得收藏','今日推荐'], (item: string, index) => {
                Column() {
                  Text(item)
                    .fontSize(16)
                    .fontColor(Color.White)
                    .fontWeight(FontWeight.Bold)
                    .margin({ left: 15, bottom: 10 })
                    .width('100%')

                  // 横向滚动网格
                  Grid() {
                    ForEach(this.musicList, (Item: Music, index) => {
                      GridItem() {
                       Row(){
                         Image(Item.cover)
                           .width(50)
                         Column(){
                           Text(Item.name)
                             .fontSize(15)
                             .fontColor(Color.White)
                           Text(Item.singer)
                             .fontSize(12)
                             .fontColor("#ffcfc4c4")
                         }
                         .margin({left:10})
                         // .backgroundColor(Color.Green)
                         .width(200)
                         .alignItems(HorizontalAlign.Start)
                       }
                       .width("100%")
                      }
                      .onClick(() => {this.currentMusic = Item;this.playTrigger++})
                      .width(320)
                      // .backgroundColor(Color.Yellow)
                    })
                  }
                  .rowsTemplate('1fr 1fr 1fr')
                  .width('100%')
                  .height(160)
                  .scrollBar(BarState.Off)                 // 显示滚动条
                  .edgeEffect(EdgeEffect.Spring)            // 边缘效果
                  // .backgroundColor(Color.Pink)
                  .columnsGap(15)    // 列间距 15px
                  .rowsGap(10)
                  .padding(5)
                }
                .margin({ bottom: 20 })
              })
            }
          }
        }
        .tabBar(this.TabBarBuilder('推荐', 0))

        TabContent() {
          Scroll(){
            Column() {
              Swiper() {
                Image($r('app.media.swipper_dengziqi'))
                  .width('100%')
                  .height(200)
                  .borderRadius(12)
                Image($r('app.media.swipper_linjunjie'))
                  .width('100%')
                  .height(200)
                  .borderRadius(12)
                Image($r('app.media.swipper_zhoujielun'))
                  .width('100%')
                  .height(200)
                  .borderRadius(12)
              }
              .width('90%')
              .height(200)
              .autoPlay(true)           // 开启自动轮播
              .interval(3000)           // 轮播间隔（毫秒），3000 = 3秒
              .loop(true)               // 循环播放
              .duration(500)            // 切换动画时长（毫秒）


                Row({space: 40}){
                 ForEach(this.singerList, (item: Singer, index) => {
                   Column({space: 5}){
                     Image(item.avatar)
                       .width(30)
                       .fillColor(Color.Green)
                     Text(item.name)
                       .fontSize(10)
                       .fontColor(Color.White)
                   }
                 })
                }
                .padding({left:10,right:10})
              .margin({top:10})


              Column(){
                ForEach([1, 2, 3], (item: number, index) => {
                  Row(){Text("你最喜欢的歌单").fontColor(Color.White)}
                  .width('100%')
                  .margin({left:40,top:20,bottom:10})
                  Grid(){
                    ForEach(this.PlaylistData, (item: Playlist, index) => {
                      GridItem(){
                        Column(){
                          Image(item.cover)
                            .width(180)
                            .height(200)
                            .borderRadius({topLeft: 10,topRight: 10})
                          Row(){ Text(item.description).fontColor(Color.White)}
                          .width(180).height(70).backgroundColor('#b7149bd6')
                          .borderRadius({bottomLeft: 10,bottomRight: 10})
                        }
                      }
                    })
                  }
                  .width('100%')
                  .height(300)
                  .rowsTemplate('1fr')
                  .scrollBar(BarState.Off)
                  .padding({left: 20})
                  .columnsGap(15)

                  Row(){Text("排行榜").fontColor(Color.White)}.width('100%').margin({left:40,top:20,bottom:10})
                  Grid(){
                    ForEach(this.createRankData, (item: RankItem, index) => {
                      GridItem(){
                        Column(){
                         Row(){
                           Image(item.songs[0].cover)
                             .width(90)
                             .height(90)
                             .objectFit(ImageFit.Cover)
                             .fitOriginalSize(false)
                             // .padding({top:30})
                           Image(item.songs[1].cover)
                           .width(120)
                             .height(120)
                             .objectFit(ImageFit.Cover)
                             .fitOriginalSize(false)
                           Image(item.songs[2].cover)
                           .width(90)
                             .height(90)
                             .objectFit(ImageFit.Cover)
                             .fitOriginalSize(false)

                         }
                         Row(){ Text("热歌榜").fontColor(Color.White)}.width("100%").margin({top:10,left:10})
                        ForEach(item.songs, (song: SongInfo, index) => {
                          Row({space: 20}){
                            Text((index+1).toString()).fontColor(Color.White)
                            Column(){
                              Row(){Text(song.songName).fontColor(Color.White).fontSize(18)}.width("100%")
                              Row(){Text(song.singer).fontColor(Color.White).fontSize(14)}.width("100%")
                            }
                          }
                          .width("90%")
                          .height(40)
                          // .backgroundColor(Color.Pink)
                          .margin({bottom:5})
                        })
                        }
                        .width(310)
                        .height(280)
                        // .backgroundColor(Color.Yellow)
                        .backgroundColor('#85bfbaba')
                        .borderRadius(20)
                      }
                    })
                  }
                  // .backgroundColor(Color.Black)

                  .width('100%')
                  .height(300)
                  .rowsTemplate('1fr')
                  .scrollBar(BarState.Off)
                  .padding({left: 20})
                  .columnsGap(15)

                })
              }
            }
          }

        }
        .tabBar(this.TabBarBuilder('乐馆', 1))

        TabContent() {
          Scroll(){
            Column() {
              Text("待开发")
                .fontSize(40)
                .fontColor(Color.White)
            }
          }
        }
        .tabBar(this.TabBarBuilder('儿童', 2))
        TabContent() {
          Scroll() {
            Column() {
                Text("待开发")
                  .fontSize(40)
                  .fontColor(Color.White)
            }
          }
        }
        .tabBar(this.TabBarBuilder('听书', 3))
      }
      .barHeight(50)
      .barMode(BarMode.Fixed)
      .width('100%')
      .height('100%')
      .onChange((index: number) => {
        this.currentTab = index
      })
    }

  @Builder
  TabBarBuilder(title: string, index: number) {
    Column({space: 5}) {
      Text(title)
        .fontSize(16)
        .fontColor(this.currentTab === index ? '#ff0c0d0e' : '#666666')
        .width(60)
        .height(30)
        .textAlign(TextAlign.Center)
        .borderRadius(15)
        .backgroundColor(this.currentTab === index ? '#ff58ac72' : 'transparent')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentTab = index
    })
  }
}