import { CommonConstants } from '../common/constants/CommonConstants'
import City from '../viewmodel/City'
import router from '@ohos.router'
import CityHeader from '../view/City/CityHeader'
import { CityList } from '../view/City/CityList'
import CityItem from '../viewmodel/CityItem'

@Entry
@Component
struct CityManage {
  @Provide cities: City[] = [
    new City("长安区",'1',  new CityItem(30,'多云', "空气优 31")),
    new City( "北京",'2', new CityItem(31, '多云', "空气良 51") ),
  ]

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