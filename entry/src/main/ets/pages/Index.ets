import { CommonConstants } from '../common/constants/CommonConstants'
import { CityWeather } from '../view/Record/CityWeather'
import TopNavBar from '../view/Record/TopNavBar'

@Entry
@Component
struct WeatherPage {
  @State currentCityIndex: number = 0
  @State cities: string[] = ['长安区', '其他城市1', '其他城市2'] // 示例城市列表

  build() {
    Stack() {
      // 顶部导航栏
      Scroll() {
        Column() {
          // 城市天气Swiper
          CityWeather({ cities: this.cities, currentCityIndex: this.currentCityIndex })
        }
      }
      .scrollable(ScrollDirection.Vertical)
      TopNavBar({ cities: this.cities, currentCityIndex: $currentCityIndex })

    }
  }


}