// components/FlexibleTabs.ets
import {HouseContent} from './FlexTabContent';

//FlexTabs结构

@Preview
@Component
export struct FlexTabs {
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
          Column() {

          }
        }
      }
      .tabBar(this.TabBarBuilder('视频', 1))

      TabContent() {
        Scroll(){
          Column() {

          }
        }
      }
      .tabBar(this.TabBarBuilder('星光', 2))

      TabContent() {
        Scroll() {
          Column() {

          }
        }
      }
      .tabBar(this.TabBarBuilder('我的', 3))
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
      Image(this.currentTab === index ? this.selectTabIcons[index]: this.tabIcons[index])
      .width(20)
      .height(20)
      Text(title)
        .fontSize(16)
        .fontColor(this.currentTab === index ? '#007AFF' : '#666666')
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