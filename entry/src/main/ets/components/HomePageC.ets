@Preview
@Component
export struct HomePageC {
  @State searchValue: string = ""
  build() {
    Row() {
      Search(
        {
          value: this.searchValue,
          placeholder: "请搜索你的音乐"
        }
      )
        .fontColor(Color.White)  // 输入文字颜色为白色
        .placeholderColor(Color.White)  // 占位符文字颜色为白色
        .backgroundColor('#99ffffff')  // 背景色设为白色
        // .fontColor(Color.Black)  // 输入文字颜色改为黑色（因为背景是白色）
        .width("80%")
        .height(35)
        .onClick(() => {})
    }
    .width("100%")
    .padding({left: 20})
  }
}