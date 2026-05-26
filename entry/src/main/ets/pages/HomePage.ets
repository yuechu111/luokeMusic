import { HomePageC } from '../components/HomePageC'
import { FlexTabs } from '../components/FlexTabs'
@Entry
@Component
struct HomePage {
  @State tabTitles: string[] = ['推荐', '歌单', '歌手', '排行']

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
          .margin({bottom: 20})
        //播放器
          Row(){
          Text("播放器")
          }
          .backgroundColor(Color.Pink)
          .width("100%")
          .margin({bottom: 60})
          .height(60)
      }
    }
  }
}