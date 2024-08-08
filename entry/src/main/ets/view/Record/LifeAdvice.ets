import HttpGet from '../../common/util/HttpGet'
import OtherItem,{LifeItem} from '../../viewmodel/OtherItem'
import { CommonConstants } from '../../common/constants/CommonConstants'

@Component
export default struct LifeAdvice {
  @Prop lifeAdvice:OtherItem = new OtherItem()

  //生活建议
  build() {
    Column(){
      Row(){
        Text('生活建议')
          .fontSize(14)
          .fontColor($r('app.color.text_fontcolor'))
        Text('>')
          .fontSize(16)
          .fontColor($r('app.color.text_fontcolor'))
      }
      .width('100%')
      .padding(8)
      .justifyContent(FlexAlign.SpaceBetween)
      Divider()
        .color($r('app.color.text_fontcolor'))
      Grid(){
        ForEach(this.lifeAdvice.daily, (data:LifeItem) => {
          GridItem(){
            this.Card($r(`app.media.life${data.type}`), data.name, data.category)
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
    }
    .padding({bottom:20})
    .margin({top:30})
    .width('90%')
    .borderRadius(10)
    .height(450)
    .backgroundColor($r('app.color.card_background'))
  }

  @Builder Card(image:Resource,title:string, text:string){
    Column({space:10}){
      Text(title)
        .fontSize(14)
        .fontColor(Color.White)
        .fontWeight(CommonConstants.FONT_WEIGHT_600)
      Image(image)
        .width(30)
        .height(30)
        .fillColor(Color.White)
      Text(text)
        .fontSize(16)
        .fontColor($r('app.color.text_fontcolor'))
        .fontWeight(CommonConstants.FONT_WEIGHT_500)
    }
    .padding(10)
  }
}