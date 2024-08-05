import { CommonConstants } from '../common/constants/CommonConstants'
import { CityWeather } from '../view/Record/CityWeather'
import TopNavBar from '../view/Record/TopNavBar'
import City from '../viewmodel/City'
import { geoLocationManager } from '@kit.LocationKit';
import WeatherItem, { WeatherDetail } from '../viewmodel/WeatherItem'
import PreferenceUtil from '../common/util/PreferenceUtil'


@Entry
@Component
struct WeatherPage {
  @State currentCityIndex: number = 0
  @Provide cities:City[]  = [
    new City("长安区",'101110102',  new WeatherItem(undefined, undefined, undefined,new WeatherDetail("2020-06-30T21:40+08:00","24","26","101","多云"), undefined)),
    new City( "北京",'101010100', new WeatherItem(undefined, undefined, undefined,new WeatherDetail("2020-06-30T21:40+08:00","30","26","101","阴天"), undefined)),
  ]
  //@Provide cities:City[] = (router.getParams() as Record<string,City[]>)['cities'];

  //加载城市数据
  /*aboutToAppear(): void {
    PreferenceUtil.getAllCities(CommonConstants.CITY_INFO)
      .then(data => {
          this.cities = data.map(city => new City(city.name, city.id))
      })
  }*/

  build() {
    Stack() {
      // 顶部导航栏
      Scroll() {
        Column() {
          // 城市天气Swiper
          CityWeather({currentCityIndex: $currentCityIndex})
        }
      }
      .scrollable(ScrollDirection.Vertical)
      TopNavBar({currentCityIndex: $currentCityIndex})

    }
  }


}