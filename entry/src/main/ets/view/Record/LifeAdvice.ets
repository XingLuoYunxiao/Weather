import HttpGet from '../../common/util/HttpGet'
import OtherItem,{LifeItem} from '../../viewmodel/OtherItem'
import { CommonConstants } from '../../common/constants/CommonConstants'
import { lifeCard } from './Tips'

@Component
export default struct LifeAdvice {
  @Prop lifeAdvice:OtherItem = new OtherItem()
  @State isShow2: boolean = false
  @State currentIndex:number = 0


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
    .onClick( () => {
      this.isShow2 = !this.isShow2
    })
    .bindSheet(this.isShow2, this.tipsBuilderLifeAdvice(this.lifeAdvice), {
      detents: [700],
      backgroundColor: Color.White,
      blurStyle: BlurStyle.Thick
    })
  }

  //模态框
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

  //主页面的生活建议Card
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