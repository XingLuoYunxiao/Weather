import { CommonConstants } from '../../common/constants/CommonConstants'
import City from '../../viewmodel/City'
import The24HoursDetail from './The24HoursDetail'
import Tips from './Tips'

@Component
export struct CityWeather {
  @Link currentCityIndex:number
  @Prop cities:City[]
  build() {
    Swiper() {
      ForEach(this.cities, (city: City, index) => {
        CityWeatherContent({ city: city })
      })
    }
    .width('100%')
    .index(this.currentCityIndex)
    .layoutWeight(1)
    .onChange((index: number) => {
      this.currentCityIndex = index
    })
    .loop(true)
  }
}

@Component
struct CityWeatherContent {
  @Prop city: City

  build() {
    Column() {
      // 这里放置天气详情内
      Text(this.city.name + ' 天气详情')
      Column({space: 20}){
        Text(`${this.city.detail?.now?.temp}°`)
          .fontSize(70)
          .fontWeight(CommonConstants.FONT_WEIGHT_700)
        Text(`${this.city.detail?.now?.text} 23°/35° 空气优`)
      }
      .margin(50)
      //提示框
      Tips()
      //24小时的天气预报
      The24HoursDetail({city: this.city})


      // ... 其他天气信息组件

    }
    .margin({top:CommonConstants.TOPIC_HEIGHT})
    .width('100%')
    .height('100%')
  }
}