import { CommonConstants } from '../../common/constants/CommonConstants'
import HttpGet from '../../common/util/HttpGet'
import City from '../../viewmodel/City'
import DayWeather from '../../viewmodel/DayWeather'
import WeatherItem from '../../viewmodel/WeatherItem'

function formatDate(dateString: string): string {
  const regex = /(\d{4})-(\d{2})-(\d{2})/;
  const match = dateString.match(regex);

  if (match && match.length === 4) {
    const month = parseInt(match[2]);
    const day = parseInt(match[3]);
    return `${month}月${day}日`;
  }

  return dateString;
}

function getDayDescription(dateString: string): string {
  const today = new Date();
  const targetDate = new Date(dateString);
  const diffDays = Math.floor((targetDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));

  if (diffDays === -1) return '今天';
  if (diffDays === 0) return '明天';

  const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  return weekdays[targetDate.getDay()];
}

@Component
export default struct The15DayDetail {
  @Prop DayWeather: WeatherItem

  build() {
    Row() {
      List({ space: 10 }) {
        ForEach(this.DayWeather.daily, (data: DayWeather) => {
          ListItem() {
            Row() {
              Row(){
                Row() {
                  //具体日期
                  Text(`${data.fxDate ? formatDate(data.fxDate) : ''}`)
                    .fontSize(16)
                    .fontColor(Color.White)
                    .fontWeight(CommonConstants.FONT_WEIGHT_500)
                    .margin({right:20})
                    .width(70)
                  //星期
                  Text(getDayDescription(data.fxDate!))
                    .fontSize(16)
                    .fontColor(Color.White)
                    .fontWeight(CommonConstants.FONT_WEIGHT_500)
                    .width(70)
                }
                .justifyContent(FlexAlign.Start)
              }
              Blank()
              //天气
              Image($r(`app.media.${data.iconDay}`))
                .width(20)
                .height(20)
                .margin({ right: 50 })
              //温差
              Text(`${data.tempMin}° / ${data.tempMax}°`)
                .fontSize(16)
                .fontWeight(CommonConstants.FONT_WEIGHT_500)
                .fontColor(Color.White)
            }
            .width('100%')
            .height(40)  // Increased height to accommodate two lines of text
            .justifyContent(FlexAlign.SpaceBetween)
          }
        })
      }
      .width('100%')
      .backgroundColor($r('app.color.card_background'))
      .borderRadius(10)
      .margin({ top: 20 })
      .padding({ left: 20, right: 20, top: 10, bottom: 10 })
    }
    .width('90%')
  }
}