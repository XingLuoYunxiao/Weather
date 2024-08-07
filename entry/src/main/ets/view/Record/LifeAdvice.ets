import HttpGet from '../../common/util/HttpGet'
import OtherItem,{LifeItem} from '../../viewmodel/OtherItem'
import { ImageAnimatorModifier } from '@kit.ArkUI'
import { CommonConstants } from '../../common/constants/CommonConstants'

@Component
export default struct LifeAdvice {
  @Prop cityId:string
  @State lifeAdvice:OtherItem = new OtherItem()

  async aboutToAppear(): Promise<void> {
    await HttpGet.getCityWeatherData<OtherItem>('indices', this.cityId, '1d', '1,2,3,4,6,8,9,15,16')
      .then( (result) => {
        if(result.daily)
          this.lifeAdvice = new OtherItem(result.code, result.updateTime,result.fxLink, undefined, undefined,result.daily, result.refer)
      })
  }
  //生活建议
  build() {
    Column(){
      Grid(){
        ForEach(this.lifeAdvice.daily, (data:LifeItem, index) => {
          GridItem(){
            this.Card($r(`app.media.life${data.type}`), data.name, data.category)
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
    }
    .margin({top:30})
    .width('90%')
    .borderRadius(10)
    .height(300)
    .backgroundColor('rgba(0, 0, 0, 0.3)')
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
      Text(text)
        .fontSize(16)
        .fontColor('#80414141')
        .fontWeight(CommonConstants.FONT_WEIGHT_500)
    }
  }
}