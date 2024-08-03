import { CommonConstants } from '../../common/constants/CommonConstants'
import Tips from './Tips'

@Component
export struct CityWeather {
  @Prop cities:string[]
  @Prop currentCityIndex:number
  build() {
    Swiper() {
      ForEach(this.cities, (city: string, index) => {
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
  @Prop city: string

  build() {
    Column() {
      Tips()
        .margin({top:200})
      // 这里放置天气详情内容，类似于您提供的第二张图片中的内容
      Text(this.city + ' 天气详情')
      // ... 其他天气信息组件

    }
    .margin({top:CommonConstants.TOPIC_HEIGHT})
    .width('100%')
    .height('100%')
  }
}