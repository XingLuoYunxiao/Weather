import { CommonConstants } from '../../common/constants/CommonConstants'

@Component
export default struct Tips {
  build() {
    Swiper() {
      this.tip('降雨提醒','1小时后降雨')
      this.tip('宜穿短袖','潮湿闷热')
      this.tip('空气优','空气很好，可以正常活动')

    }
    .width('90%')
    .loop(true)
    .autoPlay(true)
  }

  @Builder tip(title:string, content:string){
    Column() {
      Text(`${title}`)
        .width('100%')
        .height(15)
        .textAlign(TextAlign.Start)
        .fontSize(20)
        .fontWeight(CommonConstants.FONT_WEIGHT_700)
      Text(`${content}`)
        .width('100%')
        .height(45)
        .textAlign(TextAlign.Start)
        .fontSize(14)
        .fontWeight(CommonConstants.FONT_WEIGHT_700)
    }
    .backgroundColor('#ff96dcea')
    .borderRadius(10)
    .width('100%')
    .height(60)
    .padding(10)
  }
}