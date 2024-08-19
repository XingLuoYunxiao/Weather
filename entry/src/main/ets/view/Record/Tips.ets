import { CommonConstants } from '../../common/constants/CommonConstants'
import { AQICategory } from '../../model/CityModel'
import OtherItem, { LifeItem, Warn } from '../../viewmodel/OtherItem'
import { LengthMetrics } from '@kit.ArkUI'
import { DEFAULT } from '@ohos/hypium'


@Component
export default struct Tips {
  @Prop otherItem: OtherItem
  @State isShow1: boolean = false
  @State isShow2: boolean = false
  @State isShow3: boolean = false
  //半模态框显示的当前生活建议
  @State currentIndex:number = 0
  build() {
    Swiper() {
      if( this.otherItem.warning != undefined && this.otherItem.warning[0] != undefined){
        // 预警
        Column() {
          Row({space:5}){
            Image($r('app.media.warning_icon'))
              .width(20)
              .height(20)
              .fillColor(Color.White)
            Text(this.subString(this.otherItem.warning[0].title))
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
          Text(this.otherItem.warning[0].text)
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
        .onClick( () => {
          this.isShow1 = !this.isShow1
        })
        .bindSheet(this.isShow1, tipsBuilderWarn(this.otherItem), {
          detents: [700],
          backgroundColor: Color.White,
          blurStyle: BlurStyle.Thick
        })
      }
      if( this.otherItem.daily != undefined && this.otherItem.daily[2] != undefined)
      {
        // 生活建议
        Column() {
          Row({space:5}){
            Image($r('app.media.shirt'))
              .width(20)
              .height(20)
              .fillColor(Color.White)
            Text(this.otherItem.daily[2].category)
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
          Text(this.otherItem.daily[2].text)
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
        .onClick( () => {
          this.isShow2 = !this.isShow2
        })
        .bindSheet(this.isShow2, this.tipsBuilderLifeAdvice(this.otherItem), {
          detents: [700],
          backgroundColor: Color.White,
          blurStyle: BlurStyle.Thick
        })
      }
      if( this.otherItem.now != undefined)
      {
        // 空气质量
        Column() {
          Row({space:5}){
            Image($r('app.media.air_icon'))
              .width(20)
              .height(20)
              .fillColor(Color.White)
            Text(`空气${this.otherItem.now.category}`)
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
          Text(AQICategory[Number(this.otherItem.now.level)])
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
    .width('90%')
    .loop(true)
    .autoPlay(true)
  }

  @Builder
  tipsBuilderLifeAdvice(otherItem: OtherItem){
  Column({space:20}){
    Column({space:10}){
      if(otherItem.daily){
        Text(otherItem.daily[this.currentIndex].name)
          .fontSize(24)
          .fontWeight(CommonConstants.FONT_WEIGHT_600)
        Image($r(`app.media.life${otherItem.daily[this.currentIndex].type}`))
          .height(100)
          .width(100)
        Text(otherItem.daily[this.currentIndex].text)
          .fontSize(16)
          .fontColor($r('app.color.text_fontcolor_gray'))
      }
    }
    .height(250)
    .padding(10)
    .width('100%')
    .backgroundColor('#ffd6d6d6')
    .borderRadius(10)

    Text('其他建议')
      .fontSize(20)
      .fontWeight(CommonConstants.FONT_WEIGHT_500)
    Scroll(){
      Grid(){
        ForEach(otherItem.daily, (data:LifeItem, index: number) => {
          GridItem(){
            lifeCard($r(`app.media.life${data.type}`), data.name, data.category)
          }
          .padding(10)
          .margin(5)
          .borderRadius(10)
          .backgroundColor(this.currentIndex === index ? '#8084c4e7' : '#ffd6d6d6')
          .onClick( () => {
            this.currentIndex = index
          })
        })
      }
      .rowsTemplate('1fr')
      .borderRadius(10)

    }
    .width('200%')
    .height(120)
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }
  .backgroundColor('#ffefecec')
  .padding(10)
  .margin({top:20})
  .width('95%')
}


  subString(title: string): string{
    const regex = /发布(.*?预警)/; // 修改正则表达式
    const match = title.match(regex);

    if (match) {
      const extractedText = match[1];
      return extractedText
      console.log(extractedText); // 输出：大风蓝色预警
    } else {
      console.log("未找到匹配内容");
    }
    return ''
  }

  /*@Builder tip(image: Resource, title:string, content:string){
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
  }*/
}

function formatDate(dateString: string): string {
  const regex = /(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})/;
  const match = dateString.match(regex);

  if (match && match.length === 6) {
    const year = parseInt(match[1])
    const month = parseInt(match[2]);
    const day = parseInt(match[3]);
    const hour = parseInt(match[4])
    const minutes = match[5]
    return `${year}-${month}-${day} ${hour}:${minutes}`;
  }

  return dateString;
}

@Builder
export function tipsBuilderWarn(otherItem: OtherItem){
  Column(){
    ForEach( otherItem.warning, (warn: Warn) => {
      Column({space:10}){
        Row(){
          Image($r('app.media.warning_icon'))
            .height(20)
            .width(20)
          Text(warn.title)
            .fontSize(16)
            .fontWeight(CommonConstants.FONT_WEIGHT_500)
        }
        Text(formatDate(warn.pubTime))
          .fontSize(12)
          .fontColor($r('app.color.text_fontcolor_gray'))
        Text(warn.text)
          .fontSize(14)
      }
      .alignItems(HorizontalAlign.Start)
      .padding(10)
      .margin({top:20})
      .width('95%')
    })
  }
}

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
      .lineSpacing(LengthMetrics.px(5))
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
}

@Builder export  function lifeCard(image:Resource,title:string, text:string){
  Column({space:10}){
    Text(title)
      .fontSize(14)
      .fontWeight(CommonConstants.FONT_WEIGHT_600)
    Image(image)
      .width(30)
      .height(30)
    Text(text)
      .fontSize(16)
      .fontColor($r('app.color.text_fontcolor_gray'))
      .fontWeight(CommonConstants.FONT_WEIGHT_500)
  }
  .borderRadius(10)

}