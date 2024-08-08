//一些其他的天气指数
import { CommonConstants } from '../../common/constants/CommonConstants'
import City from '../../viewmodel/City'
import WeatherItem from '../../viewmodel/WeatherItem'

@Component
export default struct OtherWeatherDetail{
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