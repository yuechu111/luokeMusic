// components/FlexibleTabs.ets
import {HouseContent} from './FlexTabContent';
import {VideoPlayerPage } from '../pages/Video'
import router from '@ohos.router'
import {AvPlayerManager} from '../utils/AvPlayerManager'
import {MyPage} from './my'
import { CommentSection } from './comment'
//FlexTabs结构

@Preview
@Component
export struct FlexTabs {
  @Consume('player') player: AvPlayerManager

  @State currentTab: number = 0
  tabIcons: Resource[] = [
    $r('app.media.house'),
    $r('app.media.file_play'),
    $r('app.media.star'),
    $r('app.media.person')
  ]
  selectTabIcons: Resource[] = [
    $r('app.media.house_door_fill'),
    $r('app.media.file_play_fill'),
    $r('app.media.star_fill'),
    $r('app.media.person_fill')
  ]



  build() {
    Tabs({ index: this.currentTab,barPosition: BarPosition.End }) {
      TabContent() {
        Scroll(){
          Column(){
            HouseContent()
          }
        }
      }
      .tabBar(this.TabBarBuilder('首页', 0))

      TabContent() {
        Scroll(){
          Column({space: 20}) {
            Row(){
              Text("MV")
                .fontSize(40)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
            }
            .width('100%')
            .padding({left:10})
            ForEach([1,2,3,4], (item:number, index) => {
             Column(){
               Image($r('app.media.bg_mv1'))
                 .width('100%')
                 .padding({left: 15, right: 15})
                 .onClick(() => {
                   // ✅ 设置停止标志
                   AppStorage.setOrCreate('shouldStopMusic', true)
                   setTimeout(() => {
                     router.push({
                       url: 'pages/Video',
                     });
                   }, 100)
                 })

               Row(){
                 Text('No Doubt-BOYNEXTDOOR')
                   .fontSize(20)
                   .fontColor('#c49d9393')
                   .margin({left:10})
               }
               .width('100%')
             }
             .width('100%')
             .height(200)
            })
          }
        }
        .margin({top: 10})
      }
      .tabBar(this.TabBarBuilder('视频', 1))

      TabContent() {
        Scroll(){
          Column() {
            CommentSection()
          }
        }
        .padding({ left: 16, right: 16 })
      }
      .tabBar(this.TabBarBuilder('评论', 2))

      TabContent() {
        // 我的
        Scroll() {
          Column({ space: 20 }) {
            MyPage()
          }
          .width('100%')
          .padding({ bottom: 20 })
        }
      }
      .tabBar(this.TabBarBuilder('我的', 3))
    }
    .barBackgroundColor("#ff313a56")
    .barHeight(70)
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
      Image(this.currentTab === index ? this.selectTabIcons[index]: this.tabIcons[index])
      .width(20)
      .height(20)
        .fillColor(this.currentTab === index ? '#ff54f59b' : '#ffd0cbcb')
      Text(title)
        .fontSize(16)
        .fontColor(this.currentTab === index ? '#ff54f59b' : '#ffd0cbcb')
        .fontWeight(this.currentTab === index ? FontWeight.Bold : FontWeight.Normal)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentTab = index
    })
  }
}