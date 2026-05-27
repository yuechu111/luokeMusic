import router from '@ohos.router'
import {account} from "../data/PageContent";


//登录页面
@Entry
@Component
struct Login {
  @State username: string = ""
  @State password: string = ""

  build() {
    Column(){
      Column({space: 10}){
        Row(){
          Text("洛克音乐")
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
        }
        Row(){
          Text("让生活充满音乐")
            .fontSize(15)
        }
      }
      .width("100%")
      .height(200)
      .justifyContent(FlexAlign.Center)

      Blank()

      Column({space: 15}){
          TextInput({
              placeholder: "请输入用户名",
              text: this.username
          })
            .width(250)
            .onChange((value) => {
              this.username = value
              console.log("username: " + this.username)
            })

          TextInput({
              placeholder: "请输入密码",
              text: this.password
          })
            .width(250)
            .type(InputType.Password)
            .onChange((value) => {
              this.password = value
              console.log("password: " + this.password)
            })

        Button("登录")
          .width(200)
          .backgroundColor("#cc00bcfd")
          .onClick(() => {
            if (account.get(this.username) === this.password) {
              router.pushUrl({
                url: "pages/HomePage"
              }).catch(() => {
                console.log("Error: Failed to push URL.")
              })
            } else {
              AlertDialog.show({
                title: "提示",
                message: "用户名或密码错误"
              })
            }
          })
      }
      .width("100%")
      .height(150)
      .margin({
        bottom:40
      })

      Row(){
        Text("没有账号？")
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
        Text("立即注册")
          .fontSize(15)
          .fontColor("#cc00bcfd")
          .fontWeight(FontWeight.Bold)
      }
      .width("100%")
      .justifyContent(FlexAlign.Center)
      .margin({
        bottom:10
      })
    }
    .backgroundImage($r("app.media.login_background"))
    .backgroundImageSize(ImageSize.Cover)
    .width("100%")
    .height("100%")
  }
}