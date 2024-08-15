import { AQICategory } from '../../model/CityModel';
import OtherItem from '../../viewmodel/OtherItem';

@Component
export default struct CustomSliders {
  @Prop otherItem: OtherItem
  build() {
    Column({space:10}) {
      // 空气质量组件
      Row(){
        Text('空气质量')
          .fontSize(16)
          .fontColor($r('app.color.text_fontcolor'))
          .fontWeight(FontWeight.Bold)
        Blank()
        Text('>')
          .fontSize(16)
          .fontColor($r('app.color.text_fontcolor'))
      }
      .width('100%')
      .padding(10)

      Divider()

        .color($r('app.color.text_fontcolor'))
      Column({space:10}){
        Row(){
          Text(this.otherItem.now?.category)
            .fontSize(16)
            .fontColor(Color.White)
          Text(this.otherItem.now?.aqi)
            .fontSize(16)
            .fontColor(Color.White)
        }
        .padding({top:10})
        .width('90%')
        .justifyContent(FlexAlign.Start)

        if(this.otherItem.now?.level)
        Text(AQICategory[this.otherItem.now?.level])
          .width('90%')
          .fontSize(14)
          .fontColor($r('app.color.text_fontcolor'))
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})

        Row() {
          Slider({
            value: Number(this.otherItem.now?.aqi),
            min: 0,
            max: 500,
            style: SliderStyle.InSet
          })
            .width('100%')
            .height(30)
            .blockColor(Color.White)
            .trackThickness(10)
            .showTips(true)
            .blockColor('#ffffffff')
            .sliderInteractionMode(SliderInteraction.SLIDE_ONLY)//不允许用户通过点击滑轨使滑块移动
            .trackColor(new LinearGradient([
              { color: '#00FF00', offset: 0 },
              { color: '#FFFF00', offset: 0.2 },
              { color: '#FFA500', offset: 0.4 },
              { color: '#FF0000', offset: 0.6 },
              { color: '#800080', offset: 0.8 },
              { color: '#8B4513', offset: 1 }
            ]))
            .selectedColor('#ffbeffcd')
        }
      }

      
    }
    .backgroundColor($r('app.color.card_background'))
    .borderRadius(10)
    .height(160)
    .justifyContent(FlexAlign.SpaceBetween)
    .width('90%')
    .padding(20)
    .margin({top:20})
  }
}