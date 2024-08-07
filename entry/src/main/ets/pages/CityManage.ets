import { CommonConstants } from '../common/constants/CommonConstants'
import City from '../viewmodel/City'
import CityHeader from '../view/City/CityHeader'
import { CityList } from '../view/City/CityList'
import WeatherItem, { WeatherDetail } from '../viewmodel/WeatherItem'
import PreferenceUtil from '../common/util/PreferenceUtil'
import HttpGet from '../common/util/HttpGet'

@Entry
@Component
struct CityManage {
  /*@Provide cities: City[] = [
    new City("长安区",'101110102',  new WeatherItem(undefined, undefined, undefined,new WeatherDetail("2020-06-30T21:40+08:00","24","26","101","多云"), undefined)),
    new City( "北京",'101010100', new WeatherItem(undefined, undefined, undefined,new WeatherDetail("2020-06-30T21:40+08:00","30","26","101","阴天"), undefined)),
  ]*/
  @Watch('aboutToAppear')
  @Provide cities: City<WeatherItem>[] = []

  async aboutToAppear(): Promise<void> {
    this.cities = await PreferenceUtil.getAllCities(CommonConstants.CITY_INFO);
  }

  build() {
    Column(){
      // 1.导航栏
      CityHeader()
      // 2.城市列表
      CityList()

    }
    .width('100%')
    .height('100%')
  }


}