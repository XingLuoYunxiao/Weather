import { CommonConstants } from '../../common/constants/CommonConstants'
import City from '../../viewmodel/City'

@Component
export struct CityList {
  @Consume cities: City[]

  build() {
    List({space:10}){
      ForEach(this.cities,
        (city:City) => {
          ListItem(){
            Row(){
              Column({space:20}){
                Text(city.name)
                  .fontSize(24)
                  .fontWeight(CommonConstants.FONT_WEIGHT_700)
                  .fontColor(Color.White)
                if(city.detail)
                Text(city.detail.airQuality)
                  .fontColor('#ffe2e1e1')
                  .fontSize(14)
              }
              .padding({left:20})
              Blank()
              Column({space:20}){
                if(city.detail)
                Text(`${city.detail.temp}°`)
                  .fontSize(20)
                  .fontWeight(CommonConstants.FONT_WEIGHT_700)
                  .fontColor(Color.White)
                if(city.detail)
                Text(city.detail.weather)
                  .fontSize(14)
                  .fontColor(Color.White)
              }
              .padding({right:20})
            }
            .width("90%")
            .height('15%')
            .borderRadius(15)
            .backgroundColor('#ff2ca3e2') //TODO 需要根据天气进行卡片颜色的更新
          }
          .swipeAction({end: this.deleteButton(city.id)})
        })
    }
    .alignListItem(ListItemAlign.Center)
    .width('100%')
    .height('100%')
  }
  deleteButton(id: string){

  }
}