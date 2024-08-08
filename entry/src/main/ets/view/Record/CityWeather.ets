import { CommonConstants } from '../../common/constants/CommonConstants'
import HttpGet from '../../common/util/HttpGet'
import City from '../../viewmodel/City'
import WeatherItem from '../../viewmodel/WeatherItem'
import LifeAdvice from './LifeAdvice'
import The15DayDetail from './The15DayDetail'
import The24HoursDetail from './The24HoursDetail'
import Tips from './Tips'

@Component
export struct CityWeather {
  @Link currentCityIndex:number
  @Prop cities:City<WeatherItem>[]

  build() {
    Swiper() {
      ForEach(this.cities, (city: City<WeatherItem>, index) => {
        List(){
          CityWeatherContent({ city: city })
        }
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
  @Prop city: City<WeatherItem>
  @State HourWeather:WeatherItem = new WeatherItem()
  @State DayWeather:WeatherItem = new WeatherItem()


  async aboutToAppear(): Promise<void> {
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
  }

  build() {
    if(this.city.detail?.now && this.DayWeather.daily){
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
        Tips()
        //24小时的天气预报
        The24HoursDetail({city: this.city, HourWeather:this.HourWeather})
        //15天的天气预报
        The15DayDetail({city: this.city, DayWeather: this.DayWeather})
        //其他天气信息组件
        OtherWeatherDetail({city: this.city, DayWeather: this.DayWeather})
        //生活建议指数
        LifeAdvice({cityId: this.city.id})
      }
      .margin({top:CommonConstants.TOPIC_HEIGHT})
      .width('100%')
      .height('200%')
    } else {
      Text('加载中')
    }

  }

  @Builder OtherWeatherDetail(){

  }


}

//一些其他的天气指数
@Component
struct OtherWeatherDetail{
  @Prop city:City<WeatherItem>
  @Prop DayWeather:WeatherItem

  build() {
    Grid(){
      GridItem(){
        if(this.DayWeather.daily && this.DayWeather.daily[0].uvIndex)
          this.Card($r('app.media.uvIndex'), '紫外线', this.DayWeather.daily[0].uvIndex, '级')
      }
      GridItem(){
        if( this.city.detail?.now?.feelsLike)
          this.Card($r('app.media.feelsLike'), '体感温度', this.city.detail?.now?.feelsLike, '°')
      }
      GridItem(){
        if( this.city.detail?.now?.humidity)
          this.Card($r('app.media.humidity'), '湿度', this.city.detail?.now?.humidity, '%')
      }
      GridItem(){
        if( this.city.detail?.now?.windDir && this.city.detail.now.windSpeed)
          this.Card($r('app.media.wind'), this.city.detail?.now?.windDir, this.city.detail?.now?.windSpeed, '千米/小时')
      }
      GridItem(){
        if( this.city.detail?.now?.pressure)
          this.Card($r('app.media.pressure'), '气压', this.city.detail?.now?.pressure, '百帕')
      }
      GridItem(){
        if( this.city.detail?.now?.vis)
          this.Card($r('app.media.vis'), '能见度', this.city.detail?.now?.vis, '千米')
      }
    }
    .width('90%')
    .margin({top:30})
    .height(240)
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap(10)
    .rowsTemplate('1fr 1fr')
    .rowsGap(8)
  }

  @Builder Card(image:Resource, text:string, data:string, unit:string){
    Column({space:10}){
      Image(image)
        .width(30)
        .height(30)
        .fillColor(Color.White)
      Text(text)
        .fontSize(14)
        .fontColor($r('app.color.text_fontcolor'))
      Row(){
        Text(`${data} `)
          .fontSize(16)
          .fontWeight(CommonConstants.FONT_WEIGHT_500)
          .fontColor(Color.White)
        Text(unit)
          .fontSize(12)
          .fontWeight(CommonConstants.FONT_WEIGHT_500)
          .fontColor(Color.White)
      }
      .justifyContent(FlexAlign.Center)
      .width(80)
    }
    .width(100)
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(10)
    .padding(20)

  }
}