import { CommonConstants } from '../common/constants/CommonConstants'
import { CityWeather } from '../view/Record/CityWeather'
import TopNavBar from '../view/Record/TopNavBar'
import City from '../viewmodel/City'
import WeatherItem, { WeatherDetail } from '../viewmodel/WeatherItem'
import PreferenceUtil from '../common/util/PreferenceUtil'
import LocationUtil from '../common/util/LocationUtil'
import HttpGet from '../common/util/HttpGet'

@Entry
@Component
struct WeatherPage {
  @StorageLink('currentIndex') currentCityIndex: number = 0
  /*@State cities:City[]  = [
    new City("长安区",'101110102',  new WeatherItem(undefined, undefined, undefined,new WeatherDetail("2020-06-30T21:40+08:00","24","26","101","多云"), undefined)),
    new City( "北京",'101010100', new WeatherItem(undefined, undefined, undefined,new WeatherDetail("2020-06-30T21:40+08:00","30","26","101","阴天"), undefined)),
  ]*/
  @State cities:City<WeatherItem>[]  = []
  //@Provide cities:City[] = (router.getParams() as Record<string,City[]>)['cities'];

  async aboutToAppear(): Promise<void> {
    await this.loadCityData();
  }

  async loadCityData() {
    try {
      // 获取当前位置的城市信息
      const currentCityInfo = await LocationUtil.getCurrentCityInfo();
      // 从偏好设置中加载保存的城市列表
      const savedCities = await PreferenceUtil.getAllCities(CommonConstants.CITY_INFO);
      // 检查当前城市是否已在列表中
      const currentCityExists = savedCities.some(city => city.id === currentCityInfo.id);
      if (!currentCityExists) {
        // 如果当前城市不在列表中，添加它
        savedCities.unshift(currentCityInfo);
      }
      // 更新cities数组
      let data = savedCities.map(async city => {
        let NowWeather:WeatherItem = await HttpGet.getCityWeatherData(city.id, 'now') as WeatherItem
        return  new City(city.name, city.id, NowWeather)
      });
      // 使用Promise.all等待所有结果解析
      this.cities = await Promise.all(data)

      // 保存到首选项当中
      PreferenceUtil.putCity(CommonConstants.CITY_INFO, currentCityInfo.name, currentCityInfo.id)

    } catch (error) {
      // 处理错误，可能需要显示一个错误消息给用户
      console.error('Failed to load city data:', error);
    }
  }
  //加载城市数据
  /*aboutToAppear(): void {
    PreferenceUtil.getAllCities(CommonConstants.CITY_INFO)
      .then(data => {
          this.cities = data.map(city => new City(city.name, city.id))
      })
  }*/

  build() {
    if (this.cities.length > 0) {
      Stack() {
        Scroll() {
          Column() {
            // 城市天气页面
            CityWeather({ currentCityIndex: $currentCityIndex, cities: this.cities })
          }
        }
        .scrollable(ScrollDirection.Vertical)
        // 最上方固定导航栏
        TopNavBar({ currentCityIndex: $currentCityIndex, cities: this.cities })
      }
    } else {
      // 显示加载中提示
      Text("加载中...")
    }
  }
}