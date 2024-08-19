import { CommonConstants } from '../../common/constants/CommonConstants'
import BackgroundUtil from '../../common/util/BackgroundUtil'
import HttpGet from '../../common/util/HttpGet'
import City from '../../viewmodel/City'
import OtherItem from '../../viewmodel/OtherItem'
import WeatherItem from '../../viewmodel/WeatherItem'
import LifeAdvice from './LifeAdvice'
import OtherWeatherDetail from './OtherWeatherDetail'
import ProgressUsage from './ProgressUsage'
import The7DayDetail from './The7DayDetail'
import The24HoursDetail from './The24HoursDetail'
import Tips from './Tips'

@Component
export struct CityWeather {
  @Watch('updateBackground')
  @StorageLink('currentCityIndex') currentCityIndex:number = 0
  @StorageLink('cities') cities:City<WeatherItem>[] = []
  @Link myBackgroundImage: Resource


  updateBackground() {
    if (this.currentCityIndex && this.cities.length > 0 && this.cities[this.currentCityIndex].detail) {
      const weatherCondition = this.cities[this.currentCityIndex].detail?.now?.text || ''
      this.myBackgroundImage = BackgroundUtil.getBackgroundImage(weatherCondition);
    }
  }

  build() {
    Swiper() {
      ForEach(this.cities, (city: City<WeatherItem>, index) => {
        List(){
          CityWeatherContent({ city: city, index: index})
        }
        .width('100%')
        .height('100%')
      })

    }
    .width('100%')
    .index(this.currentCityIndex)
    .layoutWeight(1)
    .onChange((index: number) => {
      this.currentCityIndex = index
      this.updateBackground()
    })
    .loop(true)
  }
}

//TODO 页面更换时数据未正确加载
@Component
struct CityWeatherContent {
  //@StorageLink('currentCityIndex') currentCityIndex:number = 0
  @StorageLink('cities') cities:City<WeatherItem>[] = []
  @Prop city: City<WeatherItem> = new City("")
  @Prop index: number
  @State isLoading: boolean = false
  @State HourWeather:WeatherItem = new WeatherItem()
  @State DayWeather:WeatherItem = new WeatherItem()
  @State warnings: OtherItem = new OtherItem()
  @State lifeAdvice:OtherItem = new OtherItem()
  @State otherItem:OtherItem = new OtherItem()
  @State isShow:boolean = false


  async aboutToAppear(): Promise<void> {
    this.city = this.cities[this.index]

    await HttpGet.getCityWeatherData<WeatherItem>('weather', this.city.id, '24h')
      .then( (result) => {
        if(result.hourly)
          this.HourWeather = new WeatherItem(result.code, result.updateTime,result.fxLink, undefined, result.hourly, undefined, result.refer)
      })

    await HttpGet.getCityWeatherData<WeatherItem>('weather', this.city.id, '7d')
      .then( (result) => {
        if(result.daily)
          this.DayWeather = new WeatherItem(result.code, result.updateTime,result.fxLink, undefined, this.HourWeather.hourly ,result.daily, result.refer)
      })

    await HttpGet.getCityWeatherData<OtherItem>('indices', this.city.id, '1d', '1,2,3,4,6,8,9,15,16')
      .then( (result) => {
        if(result.daily)
          this.lifeAdvice = new OtherItem(result.code, result.updateTime,result.fxLink, undefined, undefined,result.daily, result.refer)
      })

    await HttpGet.getCityWeatherData<OtherItem>('warning', this.city.id, 'now')
      .then( (result) => {
        if(result.warning)
          this.warnings = new OtherItem(result.code, result.updateTime,result.fxLink, result.warning, undefined, undefined, result.refer)
      })

    await HttpGet.getCityWeatherData<OtherItem>('air', this.city.id, 'now')
      .then( (result) => {
        if(result.now)
          this.otherItem = new OtherItem(result.code, result.updateTime,result.fxLink, this.warnings.warning, result.now, this.lifeAdvice.daily , result.refer)
      })
    this.isLoading = true
  }

  build() {
    if(this.isLoading == true && this.city.detail?.now && this.DayWeather.daily){
      Column() {
        Column({space: 20}){
          Text(`${this.city.detail.now.temp}°`)
            .fontSize(80)
            .fontWeight(CommonConstants.FONT_WEIGHT_700)
            .fontColor(Color.White)
          Text(`${this.city.detail.now.text}   ${this.DayWeather.daily[0].tempMin}°/${this.DayWeather.daily[0].tempMax}°`)
            .fontColor(Color.White)
            .fontSize(16)
            .fontWeight(CommonConstants.FONT_WEIGHT_500)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin(50)
        .onClick( () => {
          this.isShow = !this.isShow
        })
        .bindSheet(this.isShow, this.RealTimeWeather(), {
          detents: [700],
          backgroundColor: Color.White,
          blurStyle: BlurStyle.Thick,
          showClose: true,
          enableOutsideInteractive: false,
          dragBar: true
        })


        //提示框
        Tips({otherItem: this.otherItem})
        //24小时的天气预报
        The24HoursDetail({ HourWeather:this.HourWeather})
        //15天的天气预报
        The7DayDetail({ DayWeather: this.DayWeather})
        //空气质量
        ProgressUsage({otherItem:this.otherItem})
        //其他天气信息组件
        OtherWeatherDetail({city: this.city, DayWeather: this.DayWeather})
        //生活建议指数
        LifeAdvice({ lifeAdvice: this.lifeAdvice})
      }
      .margin({top:CommonConstants.TOPIC_HEIGHT})
      .width('100%')
      .height('300%')
    } else {
      Text('加载中CityWeather')
    }
  }

  // 点击后显示的详情
  @Builder RealTimeWeather(){
    Column({space:10}){
      Column({space:5}){
        Text(this.city.name)
          .fontSize(18)
          .fontWeight(CommonConstants.FONT_WEIGHT_600)
        if( this.city.detail?.now?.obsTime)
        Text(this.CalculateTime(this.city.detail?.now?.obsTime))
          .fontSize(12)
          .fontColor($r('app.color.text_fontcolor_gray'))
      }
      .width("100%")
      .height(50)
      .alignItems(HorizontalAlign.Start)
      if(this.isLoading === true && this.city.detail?.now && this.DayWeather.daily){
        Column({space: 20}){
          Text(`${this.city.detail?.now?.temp}°`)
            .fontSize(80)
            .fontWeight(CommonConstants.FONT_WEIGHT_700)
          Row({space:5}){
            Image($r(`app.media.${this.city.detail.now.icon}`))
              .width(20)
              .height(20)
            Text(`${this.city.detail?.now?.text}   ${this.DayWeather.daily[0].tempMin}°/${this.DayWeather.daily[0].tempMax}°`)
              .fontSize(16)
              .fontWeight(CommonConstants.FONT_WEIGHT_500)
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin(50)
      }
      Divider()
        .color('#ff5b5a5a')
        .width('95%')
      Grid(){
        if(this.city.detail?.now){
          GridItem(){
            if( this.city.detail?.now?.feelsLike)
              this.RealTimeCard('体感温度', `${this.city.detail?.now?.feelsLike}°`)
          }
          GridItem(){
            //风向
            if(this.city.detail?.now?.windDir)
              this.RealTimeCard(this.city.detail.now?.windDir, `${this.city.detail?.now?.windScale}级 ${this.city.detail?.now?.windSpeed}公里/小时`)
          }
          GridItem(){

            this.RealTimeCard('湿度', `${this.city.detail.now?.humidity}%`)
          }
          GridItem(){
            this.RealTimeCard('过去一小时降水量', `${this.city.detail.now?.precip}毫米`)
          }
          GridItem(){
            this.RealTimeCard('能见度', `${this.city.detail.now?.vis}km`)
          }
          GridItem(){
            this.RealTimeCard('气压', `${this.city.detail.now?.pressure} 百帕`)
          }
        }

      }
      .width('100%')
      .height(200)
      .rowsTemplate('1fr 1fr')
      .columnsTemplate('1fr 1fr 1fr')
    }
    .width('95%')
    .height('100%')
    .margin({top:20})
    .padding(10)
  }

  @Builder RealTimeCard(title: string, context:string){
    Column({space:5}){
      Text(title)
        .fontSize(12)
        .fontColor($r('app.color.text_fontcolor_gray'))
      Text(context)
        .fontSize(16)
        .fontWeight(CommonConstants.FONT_WEIGHT_500)
    }
  }

  CalculateTime( data : string): string {
    // 移除时区偏移，将其转换为一个Date对象
    let obsDate = new Date(data.replace('T', ' ').replace('+08:00', ''));

    // 获取当前时间
    let currentDate = new Date();

    // 计算时间差，单位是毫秒, 将时间差转换为分钟
    let diffInMinutes = Math.floor((currentDate.getTime() - obsDate.getTime()) / (1000 * 60));

    // 根据时间差显示“X分钟前”
    let timeAgo:string = ''
    if (diffInMinutes < 1) {
      timeAgo = "刚刚发布";
    } else {
      timeAgo = diffInMinutes + "分钟前发布";
    }
    return timeAgo
  }

}

