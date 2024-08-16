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
  @StorageLink('cities') cities: City<WeatherItem>[] = []
  @State myBackgroundImage: Resource = $r('app.media.default_background')
  @State judge: boolean = true

/*  async aboutToAppear(): Promise<void> {
    await this.loadCityData()
  }*/

  async onPageShow(): Promise<void> {
    if(this.judge){
      await this.loadCityData()
      this.judge = false
      AppStorage.setOrCreate('cities', this.cities)
    }
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
          CityWeather({ currentCityIndex: $currentCityIndex})
        }
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)

      if( this.cities.length > this.currentCityIndex)
        TopNavBar({ currentCityIndex: $currentCityIndex, cities: this.cities })
      else{
        Text('有问题')
      }
    }
    .width('100%')
    .height('100%')
  }

  build() {
    if (this.cities.length > 0) {
      this.WeatherContent()
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