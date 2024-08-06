import { CommonConstants } from '../../common/constants/CommonConstants'
import HttpGet from '../../common/util/HttpGet'
import PreferenceUtil from '../../common/util/PreferenceUtil'
import City from '../../viewmodel/City'
import WeatherItem from '../../viewmodel/WeatherItem'

@Component
export struct CityList {
  @Watch('loadCities')
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
               /* if(city.detail)
                Text(city.detail.weather.airQuality)
                  .fontColor('#ffe2e1e1')
                  .fontSize(14)*/
              }
              .padding({left:20})
              Blank()
              Column({space:20}){
                if(city.detail)
                Text(`${city.detail.now?.temp}°`)
                  .fontSize(20)
                  .fontWeight(CommonConstants.FONT_WEIGHT_700)
                  .fontColor(Color.White)
                if(city.detail)
                Text(city.detail.now?.text)
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
          .swipeAction({end: this.deleteButton(city.name)})
        })
    }
    .alignListItem(ListItemAlign.Center)
    .width('100%')
    .height('100%')
  }

  //删除一个城市
  @Builder
  deleteButton(name: string){
    Image($r('app.media.delete_icon'))
      .fillColor(Color.Red)
      .width('20')
      .height('20')
      .onClick( () => {
        this.cities = this.cities.filter(c => c.name !== name)
        PreferenceUtil.removeCity(CommonConstants.CITY_INFO, name)
      })
  }

  //TODO 待完成
  async loadCities(name:string) {
    let WeatherDetail:WeatherItem = new WeatherItem()
    for(let i = 0; i < this.cities.length; i++){
      if( this.cities[i].id != undefined)
      {
        WeatherDetail = await HttpGet.getCityWeatherData(this.cities[i].id, "now")
        this.cities[i].detail = WeatherDetail
      }
    }
  }
}
