//tabs结构内容
@Preview
@Component
export struct HouseContent {
  @State tabName: string = ''
  @State tabContent: string = ''
  @State currentTab: number = 0

  build() {
      Tabs({ index: this.currentTab,barPosition: BarPosition.Start }) {
        TabContent() {
          Scroll(){
            Column(){
             Grid(){
               ForEach([1, 2, 3], (item: number, index) => {
                 GridItem(){
                 Column(){
                  Row(){
                    Text("For you")
                    Image($r('app.media.luoke'))
                      .width(70)
                  }
                  .width("100%")
                   .height(70)
                   .justifyContent(FlexAlign.SpaceBetween)
                   .padding({left: 10,right: 10})

                   Row(){
                    Column(){
                      Text("猜你喜欢")
                      Text("歌名")

                    }
                    Row(){
                      Image($r('app.media.play'))
                        .width(40)
                        .fillColor(Color.Green)
                        .padding({left:4})
                    }
                    .width(40)
                    .height(40)
                    .border({width:1})
                    .borderRadius(20)
                     .backgroundColor(Color.White)

                   }
                   .width("100%")
                   .justifyContent(FlexAlign.SpaceBetween)
                   .padding({left: 10,right: 10})
                   .margin({top: 20})
                 }
                 .margin({left:15})
                 .width(200)
                 .height(150)
                 .backgroundColor(Color.Yellow)
               }})

             }
             .backgroundColor(Color.Black)
             .width('100%')
             .height(180)
             .rowsTemplate('1fr')
             .scrollBar(BarState.Off)
              .columnsGap(10)

              ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], (item: number, index) => {
                Column() {
                  Text('听xxx的也会喜欢')
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .margin({ left: 15, bottom: 10 })
                    .width('100%')

                  // 横向滚动网格
                  Grid() {
                    ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], (subItem: number) => {
                      GridItem() {
                       Row(){
                         Image($r('app.media.luoke'))
                           .width(50)
                       }
                       .width("100%")
                      }
                      .width(320)
                      .backgroundColor(Color.Yellow)
                    })
                  }
                  .rowsTemplate('1fr 1fr 1fr')
                  .width('100%')
                  .height(160)
                  .scrollBar(BarState.Off)                 // 显示滚动条
                  .edgeEffect(EdgeEffect.Spring)            // 边缘效果
                  .backgroundColor(Color.Pink)
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
              Swiper(){
                Text()
              }
              .width('90%')
              .height(200)
              .backgroundColor(Color.Black)

             Scroll(){
                Row({space: 50}){
                  ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], (item: number, index) => {
                    Image($r('app.media.person'))
                      .width(30)
                  })
                }
                .padding({left:20})
             }
             .scrollable(ScrollDirection.Horizontal)
             .scrollBar(BarState.Off)

              Column(){
                ForEach([1, 2, 3], (item: number, index) => {
                  Row(){Text("你最喜欢的歌单")}.width('100%').margin({left:40,top:20,bottom:10})
                  Grid(){
                    ForEach([1, 2, 3], (item: number, index) => {
                      GridItem(){
                        Column(){
                          Image($r('app.media.luoke'))
                            .width(180)
                            .height(200)
                          Row(){ Text("享受青春")}
                          .width(180).height(70).backgroundColor(Color.Yellow)
                        }
                      }
                    })
                  }
                  .backgroundColor(Color.Black)
                  .width('100%')
                  .height(300)
                  .rowsTemplate('1fr')
                  .scrollBar(BarState.Off)
                  .padding({left: 20})
                  .columnsGap(15)

                  Row(){Text("排行榜")}.width('100%').margin({left:40,top:20,bottom:10})
                  Grid(){
                    ForEach([1, 2, 3], (item: number, index) => {
                      GridItem(){
                        Column(){
                         Row(){
                           Image($r('app.media.luoke'))
                             .width(90)
                             .padding({top:30})
                           Image($r('app.media.luoke'))
                           .width(120)
                           Image($r('app.media.luoke'))
                           .width(90)
                           .padding({top:30})
                         }
                         Row(){ Text("热歌榜")}.width("100%").margin({top:10,left:10})
                        ForEach([1, 2, 3], (item: number, index) => {
                          Row({space: 20}){
                            Text("1")
                            Column(){
                              Text("玻璃")
                              Text("yuechu")
                            }
                          }
                          .width("90%")
                          .height(40)
                          .backgroundColor(Color.Pink)
                          .margin({bottom:5})
                        })
                        }
                        .width(310)
                        .height(280)
                        .backgroundColor(Color.Yellow)
                      }
                    })
                  }
                  .backgroundColor(Color.Black)
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

            }
          }
        }
        .tabBar(this.TabBarBuilder('儿童', 2))
        TabContent() {
          Scroll() {
            Column() {

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