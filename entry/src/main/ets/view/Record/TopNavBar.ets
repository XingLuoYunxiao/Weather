import { CommonConstants } from '../../common/constants/CommonConstants'
import router from '@ohos.router'
import City from '../../viewmodel/City'
import WeatherItem from '../../viewmodel/WeatherItem'

@Component
export default struct TopNavBar {
  @Link currentCityIndex:number
  @Prop cities:City<WeatherItem>[]
  build() {
      Row({space: 10}) {
        Text(this.cities[this.currentCityIndex].name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Blank()
        /*Image($r('app.media.theme_icon'))
          .width(24)
          .height(24)*/
        Image($r('app.media.city_manager_icon'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/CityManage'
            },
            router.RouterMode.Single,
            err => {
              if( err){
                console.log(`路由失败，err:${err.code} errMsg:${err.message}`)
              }
            })
          })
        Image($r('app.media.settings_icon'))
          .width(24)
          .height(24)
      }
      .position({x:0,y:0})
      .width('100%')
      .height(CommonConstants.TOPIC_HEIGHT)
      .backgroundColor('#ff2967c8')
      .padding({ left: 16, right: 16 })
    }
}