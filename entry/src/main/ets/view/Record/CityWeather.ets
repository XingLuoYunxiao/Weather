import { CommonConstants } from '../../common/constants/CommonConstants'
import BackgroundUtil from '../../common/util/BackgroundUtil'
import HttpGet from '../../common/util/HttpGet'
import City from '../../viewmodel/City'
import OtherItem from '../../viewmodel/OtherItem'
import WeatherItem from '../../viewmodel/WeatherItem'
import LifeAdvice from './LifeAdvice'
import OtherWeatherDetail from './OtherWeatherDetail'
import ProgressUsage from './ProgressUsage'
import The15DayDetail from './The15DayDetail'
import The24HoursDetail from './The24HoursDetail'
import Tips from './Tips'

@Component
export struct CityWeather {
  @StorageLink('currentCityIndex') currentCityIndex:number = 0
  @StorageLink('cities') cities:City<WeatherItem>[] = []
  @Link myBackgroundImage: Resource

  updateBackground() {
    if (this.cities.length > 0 && this.cities[this.currentCityIndex].detail) {
      const weatherCondition = this.cities[this.currentCityIndex].detail?.now?.text || ''
      this.myBackgroundImage = BackgroundUtil.getBackgroundImage(weatherCondition);
    }
  }

  build() {
    Swiper() {
      ForEach(this.cities, (city: City<WeatherItem>, index) => {
        List(){
          CityWeatherContent({ city: city})
        }
        .width('100%')
        .height('100%')
      })

    }
    .width('100%')
    .index(this.currentCityIndex)
    .layoutWeight(1)
    .onChange((index: number) => {
      this.currentCityIndex = index
      this.updateBackground()
    })
    .loop(true)
  }
}

@Component
struct CityWeatherContent {
  @StorageProp('currentCityIndex') currentCityIndex:number = 0
  @StorageLink('cities') cities:City<WeatherItem>[] = []
  @Prop city: City<WeatherItem>
  @State isLoading: boolean = false
  @State HourWeather:WeatherItem = new WeatherItem()
  @State DayWeather:WeatherItem = new WeatherItem()
  @State warnings: OtherItem = new OtherItem()
  @State lifeAdvice:OtherItem = new OtherItem()
  @State otherItem:OtherItem = new OtherItem()


  async aboutToAppear(): Promise<void> {
    this.city.detail = this.cities[this.currentCityIndex].detail

    await HttpGet.getCityWeatherData<WeatherItem>('weather', this.city.id, '24h')
      .then( (result) => {
        if(result.hourly)
          this.HourWeather = new WeatherItem(result.code, result.updateTime,result.fxLink, undefined, result.hourly, undefined, result.refer)
      })

    await HttpGet.getCityWeatherData<WeatherItem>('weather', this.city.id, '7d')
      .then( (result) => {
        if(result.daily)
          this.DayWeather = new WeatherItem(result.code, result.updateTime,result.fxLink, undefined, this.HourWeather.hourly ,result.daily, result.refer)
      })

    await HttpGet.getCityWeatherData<OtherItem>('indices', this.city.id, '1d', '1,2,3,4,6,8,9,15,16')
      .then( (result) => {
        if(result.daily)
          this.lifeAdvice = new OtherItem(result.code, result.updateTime,result.fxLink, undefined, undefined,result.daily, result.refer)
      })

    await HttpGet.getCityWeatherData<OtherItem>('warning', this.city.id, 'now')
      .then( (result) => {
        if(result.warning)
          this.warnings = new OtherItem(result.code, result.updateTime,result.fxLink, result.warning, undefined, undefined, result.refer)
      })

    await HttpGet.getCityWeatherData<OtherItem>('air', this.city.id, 'now')
      .then( (result) => {
        if(result.now)
          this.otherItem = new OtherItem(result.code, result.updateTime,result.fxLink, this.warnings.warning, result.now, this.lifeAdvice.daily , result.refer)
      })
    this.isLoading = true
  }

  build() {
    if(this.isLoading === true && this.city.detail?.now && this.DayWeather.daily){
      Column() {
        Column({space: 20}){
          Text(`${this.city.detail?.now?.temp}°`)
            .fontSize(80)
            .fontWeight(CommonConstants.FONT_WEIGHT_700)
            .fontColor(Color.White)
          Text(`${this.city.detail?.now?.text}   ${this.DayWeather.daily[0].tempMin}°/${this.DayWeather.daily[0].tempMax}°`)
            .fontColor(Color.White)
            .fontSize(16)
            .fontWeight(CommonConstants.FONT_WEIGHT_500)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin(50)
        //提示框
        Tips({otherItem: this.otherItem})
        //24小时的天气预报
        The24HoursDetail({ HourWeather:this.HourWeather})
        //15天的天气预报
        The15DayDetail({ DayWeather: this.DayWeather})
        //空气质量
        ProgressUsage({otherItem:this.otherItem})
        //其他天气信息组件
        OtherWeatherDetail({city: this.city, DayWeather: this.DayWeather})
        //生活建议指数
        LifeAdvice({ lifeAdvice: this.lifeAdvice})
      }
      .margin({top:CommonConstants.TOPIC_HEIGHT})
      .width('100%')
      .height('300%')
    } else {
      Text('加载中')
    }
  }


}

