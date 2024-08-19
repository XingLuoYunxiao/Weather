import { CommonConstants } from '../../common/constants/CommonConstants';
import { AQICategory } from '../../model/CityModel';
import OtherItem from '../../viewmodel/OtherItem';
import { tipsBuilderAirQuality } from './Tips';

@Component
export default struct CustomSliders {
  @Prop otherItem: OtherItem
  @State isShow3:boolean = false
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
    .onClick( () => {
      this.isShow3 = !this.isShow3
    })
    .bindSheet(this.isShow3, tipsBuilderAirQuality(this.otherItem), {
      detents: [700],
      backgroundColor: Color.White,
      blurStyle: BlurStyle.Thick
    })
  }
}
/*

function getAQIColor(aqi: number): string {
  if (aqi >= 0 && aqi <= 50) {
    return '#ff4abe4a'; // 优
  } else if (aqi >= 51 && aqi <= 100) {
    return '#ffe5c773'; // 良
  } else if (aqi >= 101 && aqi <= 150) {
    return '#FFA500'; // 轻度污染
  } else if (aqi >= 151 && aqi <= 200) {
    return '#ffe03636'; // 中度污染
  } else if (aqi >= 201 && aqi <= 300) {
    return '#800080'; // 重度污染
  } else if (aqi >= 301 && aqi <= 500) {
    return '#8B4513'; // 严重污染
  } else {
    return '#000000'; // 默认黑色 (AQI 值超出范围)
  }
}

*/
/*
@Builder
export function tipsBuilderAirQuality(otherItem: OtherItem){
  Column(){
    Row({space:10}){
      Text(otherItem.now?.aqi)
        .fontSize(50)
        .fontWeight(CommonConstants.FONT_WEIGHT_600)
        .fontColor(getAQIColor(Number(otherItem.now?.aqi)))
      Text(otherItem.now?.category)
        .fontSize(20)
        .fontColor(getAQIColor(Number(otherItem.now?.aqi)))
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Bottom)
    .padding({left:40, top:20})

    Text(AQICategory[Number(otherItem.now?.level)])
      .margin({top:5})
      .padding({left:40})
      .width('100%')
      .height(30)
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.text_fontcolor_gray'))
      .fontSize(14)

    Grid(){
      if( otherItem.now){
        GridItem(){
          airCard( 'PM2.5' ,otherItem.now?.pm2p5)
        }
        GridItem(){
          airCard( 'NO₂', otherItem.now.no2)
        }
        GridItem(){
          airCard( 'O₃', otherItem.now.o3)
        }
        GridItem(){
          airCard( 'PM10', otherItem.now.pm10)
        }
        GridItem(){
          airCard( 'CO', otherItem.now.co)
        }
        GridItem(){
          airCard( 'SO₂', otherItem.now.so2)
        }
      }
    }
    .width('100%')
    .height(200)
    .columnsTemplate('1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr')
  }
  .alignItems(HorizontalAlign.Start)
  .margin({top:20})
  .width('95%')
  .backgroundColor('#ffe5e4e4')
  .borderRadius(10)
}

@Builder function airCard(title: string, text:string){
  Column({space:5}){
    Text(title)
      .fontSize(16)
      .fontColor($r('app.color.text_fontcolor_gray'))
    Text(text)
      .fontSize(20)
  }
  .padding(10)
}*/

