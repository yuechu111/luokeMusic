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
      .width("80%")
      .height(25)
      .onClick(() => {})
    }
    .width("100%")
    .padding({left: 20})
  }
}