import { CommonConstants } from '../../common/constants/CommonConstants'
import { AQICategory } from '../../model/CityModel'
import OtherItem, { Warn } from '../../viewmodel/OtherItem'
import { LengthMetrics } from '@kit.ArkUI'


@Component
export default struct Tips {
  @Prop otherItem: OtherItem
  build() {
    Swiper() {
      if( this.otherItem.warning)
        this.tip($r('app.media.warning_icon'), this.otherItem.warning[0].title, this.otherItem.warning[0].text)
      if( this.otherItem.daily)
        this.tip($r('app.media.shirt'), this.otherItem.daily[2].category, this.otherItem.daily[2].text)
      if( this.otherItem.now)
        this.tip($r('app.media.air_icon'), `空气${this.otherItem.now.category}`, AQICategory[Number(this.otherItem.now.level)])

    }
    .width('90%')
    .loop(true)
    .autoPlay(true)
  }

  @Builder tip(image: Resource, title:string, content:string){
    Column() {
      Row({space:5}){
        Image(image)
          .width(20)
          .height(20)
          .fillColor(Color.White)
        Text(`${title}`)
          .width('100%')
          .height(25)
          .textAlign(TextAlign.Start)
          .fontSize(20)
          .fontWeight(CommonConstants.FONT_WEIGHT_700)
          .fontColor(Color.White)
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .padding({right:5})
      }
      .alignItems(VerticalAlign.Center)
      .width('100%')
      Text(`${content}`)
        .margin({top:5})
        .width('100%')
        .height(30)
        .textAlign(TextAlign.Start)
        .fontColor($r('app.color.text_fontcolor'))
        .fontSize(14)
        .lineSpacing(LengthMetrics.px(5))
        .fontWeight(CommonConstants.FONT_WEIGHT_700)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(10)
    .width('100%')
    .height(100)
    .padding(10)
  }
}