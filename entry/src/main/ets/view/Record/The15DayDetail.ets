import { CommonConstants } from '../../common/constants/CommonConstants'
import HttpGet from '../../common/util/HttpGet'
import City from '../../viewmodel/City'
import DayWeather from '../../viewmodel/DayWeather'
import WeatherItem from '../../viewmodel/WeatherItem'

//格式化日期
function formatDate(dateString: string): string {
  const regex = /(\d{4})-(\d{2})-(\d{2})/;
  const match = dateString.match(regex);

  if (match && match.length === 4) {
    const month = parseInt(match[2]);
    const day = parseInt(match[3]);
    return `${month}月${day}日`;
  }

  return dateString; // 如果格式不匹配，返回原字符串
}

@Component
export default struct The15DayDetail {
  @Prop city:City<WeatherItem>
  @Prop DayWeather:WeatherItem

  /*async aboutToAppear(): Promise<void> {
    await HttpGet.getCityWeatherData<WeatherItem>('weather', this.city.id, '7d')
      .then( (result) => {
        if(result.daily)
          this.DayWeather = new WeatherItem(result.code, result.updateTime,result.fxLink, undefined,  undefined,result.daily, result.refer)
      })
  }*/

  build() {
    Row(){
      List({space:10}){
        ForEach(this.DayWeather.daily, (data:DayWeather) => {
          ListItem(){
            Row(){
              Text(`${data.fxDate ? formatDate(data.fxDate) : ''}`)
                .fontSize(16)
                .fontColor(Color.White)
              Blank()
              Image($r(`app.media.${data.iconDay}`))
                .width(20)
                .height(20)
                .margin({right:50})
              Text(`${data.tempMin}°/${data.tempMax}°`)
                .fontSize(16)
                .fontWeight(CommonConstants.FONT_WEIGHT_500)
                .fontColor(Color.White)
            }
            .width('100%')
            .height(30)
            .justifyContent(FlexAlign.SpaceBetween)
          }
        })
      }
      .width('100%')
      .backgroundColor('rgba(0, 0, 0, 0.3)')
      .borderRadius(10)
      .margin({top:20})
      .padding({left:20,right:20,top:10,bottom:10})
    }
    .width('90%')
  }
}