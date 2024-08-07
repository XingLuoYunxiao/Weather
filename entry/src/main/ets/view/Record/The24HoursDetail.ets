import City from '../../viewmodel/City'
import HourWeather from '../../viewmodel/HourWeather'
import WeatherItem from '../../viewmodel/WeatherItem'
import HttpGet from '../../common/util/HttpGet'
import { CommonConstants } from '../../common/constants/CommonConstants'

function extractTime(dateTimeString: string): string {
  const regex = /T(\d{2}:\d{2})/;
  const match = dateTimeString.match(regex);
  return match ? match[1] : '';
}


@Component
export default struct The24HoursDetail {
  @Prop city:City<WeatherItem>
  @State HourWeather:WeatherItem = new WeatherItem()

  async aboutToAppear(): Promise<void> {
    await HttpGet.getCityWeatherData<WeatherItem>(this.city.id, '24h')
      .then( (result) => {
        if(result.hourly)
        this.HourWeather = new WeatherItem(result.code, result.updateTime,result.fxLink, undefined, result.hourly, undefined, result.refer)
      })
  }

  build() {
    Row(){
      List({space:10}){
        ForEach(this.HourWeather.hourly, (data:HourWeather) => {
          ListItem(){
            Column({space:5}){
              Text(`${data.fxTime ? extractTime(data.fxTime) : ''}`)
                .fontSize(12)
                .fontColor(Color.White)
              Image($r(`app.media.${data.icon}`))
                .width(20)
                .height(20)
              Text(`${data.temp}°`)
                .fontSize(14)
                .fontWeight(CommonConstants.FONT_WEIGHT_500)
                .fontColor(Color.White)
            }
          }
        })
      }
      .width('100%')
      .listDirection(Axis.Horizontal)
      .backgroundColor("#33000000")
      .borderRadius(10)
      .margin({top:20})
      .padding({left:20,right:20,top:10,bottom:10})
    }
    .width('90%')
    .height(100)
  }
}