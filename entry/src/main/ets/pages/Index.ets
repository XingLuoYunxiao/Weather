import { CommonConstants } from '../common/constants/CommonConstants'
import { CityWeather } from '../view/Record/CityWeather'
import TopNavBar from '../view/Record/TopNavBar'
import City from '../viewmodel/City'
import WeatherItem, { WeatherDetail } from '../viewmodel/WeatherItem'
import PreferenceUtil from '../common/util/PreferenceUtil'
import LocationUtil from '../common/util/LocationUtil'
import HttpGet from '../common/util/HttpGet'
import { router } from '@kit.ArkUI'

//import { BackgroundUtil } from '../common/util/BackgroundUtil'

@Entry
@Component
struct WeatherPage {
  @StorageLink('currentIndex') currentCityIndex: number = 0
  @State cities: City<WeatherItem>[] = []
  @State myBackgroundImage: Resource = $r('app.media.default_background')

/*  async aboutToAppear(): Promise<void> {
    await this.loadCityData()
  }*/

  async onPageShow(): Promise<void> {
    await this.loadCityData()
    //this.updateBackground()
  }

  async loadCityData() {
    try {
      const currentCityInfo = await LocationUtil.getCurrentCityInfo();
      const savedCities = await PreferenceUtil.getAllCities(CommonConstants.CITY_INFO);
      const currentCityExists = savedCities.some(city => city.id === currentCityInfo.id);
      if (!currentCityExists) {
        savedCities.unshift(currentCityInfo);
      }
      let data = savedCities.map(async city => {
        let NowWeather: WeatherItem = await HttpGet.getCityWeatherData('weather', city.id, 'now') as WeatherItem
        return new City(city.name, city.id, NowWeather)
      });
      this.cities = await Promise.all(data)
      await PreferenceUtil.putCity(CommonConstants.CITY_INFO, currentCityInfo.name, currentCityInfo.id)
    } catch (error) {
      console.error('Failed to load city data:', error);
    }
  }

  /*updateBackground() {
    if (this.cities.length > 0 && this.cities[this.currentCityIndex].detail) {
      const weatherCondition = this.cities[this.currentCityIndex].detail?.now?.text || ''
      this.myBackgroundImage = BackgroundUtil.getBackgroundImage(weatherCondition);
    }
  }*/

  @Builder
  WeatherContent() {
    Stack() {
      Image(this.myBackgroundImage)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Scroll() {
        Column() {
          CityWeather({ currentCityIndex: $currentCityIndex, cities: this.cities })
        }
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)

      //TopNavBar({ currentCityIndex: $currentCityIndex, cities: this.cities })

    }
    .width('100%')
    .height('100%')
  }

  build() {
    if (this.cities.length > 0) {
      this.WeatherContent()
      Row({space: 10}) {
        if(this.currentCityIndex < this.cities.length && this.cities[this.currentCityIndex].name !== undefined){
          Text(this.cities[this.currentCityIndex].name)
            .fontColor(Color.White)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }else{
          Text('有问题')
        }
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
    } else {
      Column() {
        Text("加载中...")
          .fontSize(16)
          .fontColor(Color.Gray)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
  }
}