import { CommonConstants } from '../../common/constants/CommonConstants'
import { router } from '@kit.ArkUI'
import City from '../../viewmodel/City'
import SearchHeader from './SearchHeader'
import { preferences } from '@kit.ArkData'
import PreferenceUtil from '../../common/util/PreferenceUtil'
import WeatherItem from '../../viewmodel/WeatherItem'
import HttpGet from '../../common/util/HttpGet'

//import WeatherApi from '../../api/WeatherApi' // 假设这是您的天气API服务

@Component
export default struct CityHeader {
  @State isShow: boolean = false
  @Consume cities: City<WeatherItem>[]
  @State searchText: string = ''
  @State searchResults: City<WeatherItem>[] = []
  @State hotCities: City<WeatherItem>[] = [
    new City('北京', '101010100'),
    new City('上海', '101020100'),
    new City('深圳', '101280601'),
    new City('广州', '101280101'),
    new City('武汉', '101200101'),
    new City('长沙', '101250101'),
    new City('南京', '101190101'),
    new City('苏州', '101190401'),
    new City('西安', '101110101'),
    new City('济南', '101120101'),
    new City('青岛', '101120201'),
    new City('沈阳', '101070101'),
    new City('重庆', '101040100'),
    new City('郑州', '101180101'),
    new City('成都', '101270101'),
    new City('杭州', '101210101'),
    new City('厦门', '101230201')
  ]
  @State internationalCities: City<WeatherItem>[] = [
    new City( '纽约','US_NY0996' ),
    new City( '巴黎','FR_PA0001' ),
    new City( '伦敦','GB_LO0001'),
    new City( '东京','JP_TK0001'),
    new City( '罗马','IT_RM0001' ),
    new City( '迪拜','AE_DB0001' ),
    new City( '莫斯科','RU_MS0001'),
    new City( '悉尼','AU_SD0001',),
    new City( '新加坡','SG_SP0001'),
    new City( '北京','101010100'),
    new City( '雅典','GR_AT0001'),
  ]

  build() {
    Column() {
      this.NavigationBar()
    }
  }

  @Builder NavigationBar() {
    Row() {
      Image($r('app.media.back_icon'))
        .width(30)
        .height(24)
        .padding({ right: 10 })
        .onClick(() => {
          router.back()
        })
      Text('城市管理')
        .fontSize(18)
        .fontWeight(CommonConstants.FONT_WEIGHT_700)
      Blank()
      Image($r('app.media.add_icon'))
        .width(30)
        .height(24)
        .fillColor('#ff226aea')
        .onClick(() => {
          this.isShow = !this.isShow
        })
        .bindSheet(this.isShow, this.AddCityPanel(), {
          detents: [700],
          backgroundColor: Color.White,
          blurStyle: BlurStyle.Thick,
          showClose: true,
          enableOutsideInteractive: false,
          dragBar: true,
          /*shouldDismiss:(async () => {
            this.loadCities()
            this.isShow = !this.isShow
          })*/
        })
    }
    .width('100%')
    .height(CommonConstants.TOPIC_HEIGHT)
    .padding(20)
  }

  @Builder AddCityPanel() {
    Column({ space: 20 }) {
      Text('添加城市')
        .fontSize(24)
        .fontWeight(CommonConstants.FONT_WEIGHT_700)

      SearchHeader({ searchText: $searchText, searchResults: $searchResults })

      this.showHotCity('热门城市', this.hotCities)
      this.showHotCity('国际热门城市', this.internationalCities)

      if (this.searchResults.length > 0) {
        this.showSearchResults()
      }
    }
    .padding(20)
  }

  @Builder showHotCity(title: string, cities: City<WeatherItem>[]) {
    Column({ space: 10 }) {
      Text(title)
        .fontSize(14)
        .fontColor('#ff7c7878')
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
        ForEach(cities, (city: City<WeatherItem>) => {
          Text(city.name)
            .fontSize(16)
            .backgroundColor(this.isCitySelected(city) ? '#ff226aea' : '#f5f5f5')
            .fontColor(this.isCitySelected(city) ? Color.White : Color.Black)
            .borderRadius(20)
            .padding(10)
            .margin(5)
            .onClick(() => {
              this.toggleCitySelection(city)
            })
        })
      }
    }
  }

  @Builder showSearchResults() {
    Column({ space: 10 }) {
      Text('搜索结果')
        .fontSize(14)
        .fontColor('#ff7c7878')
      List() {
        ForEach(this.searchResults, (city: City<WeatherItem>) => {
          ListItem() {
            Row() {
              Text(city.name)
                .fontSize(16)
              Blank()
              Text(this.isCitySelected(city) ? '已添加' : '+')
                .fontSize(16)
                .fontColor(this.isCitySelected(city) ? '#999999' : '#ff226aea')
            }
            .width('100%')
            .padding(10)
            .onClick(() => {
              this.toggleCitySelection(city)
            })
          }
        })
      }
      .width('100%')
      .height('100%')
    }
  }

  isCitySelected(city: City<WeatherItem>): boolean {
    return this.cities.some(c => c.id === city.id)
  }

  toggleCitySelection(city: City<WeatherItem>) {
    if (this.isCitySelected(city)) {
      this.cities = this.cities.filter(c => c.id !== city.id)
      PreferenceUtil.removeCity(CommonConstants.CITY_INFO, city.name)
    } else {
      this.cities.push(city)
      PreferenceUtil.putCity(CommonConstants.CITY_INFO, city.name, city.id)
    }
    // 触发UI更新
    this.cities = [...this.cities]
  }

  async loadCities() {
    let WeatherDetail:WeatherItem = new WeatherItem()
    for(let i = 0; i < this.cities.length; i++){
      if( this.cities[i].id != undefined)
      {
        WeatherDetail = await HttpGet.getCityWeatherData(this.cities[i].id, "now")
        this.cities[i].detail = WeatherDetail
      }
    }
  }
}

