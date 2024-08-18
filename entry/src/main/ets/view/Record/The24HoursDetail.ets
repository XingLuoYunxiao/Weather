import City from '../../viewmodel/City'
import HourWeather from '../../viewmodel/HourWeather'
import WeatherItem from '../../viewmodel/WeatherItem'
import HttpGet from '../../common/util/HttpGet'
import { CommonConstants } from '../../common/constants/CommonConstants'

function extractTime(dateTimeString: string): string {
  const regex = /T(\d{2}:\d{2})/;
  const match = dateTimeString.match(regex);
  return match ? match[1] : '';
}


@Component
export default struct The24HoursDetail {
  @Prop HourWeather:WeatherItem
  @State isShow:boolean = false
  @State hourSelectIndex: number = 0;


  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Row(){
      List({space:30}){
        ForEach(this.HourWeather.hourly, (data:HourWeather) => {
          ListItem(){
            Column({space:10}){
              Text(`${data.fxTime ? extractTime(data.fxTime) : ''}`)
                .fontSize(14)
                .fontColor(Color.White)
                .fontWeight(CommonConstants.FONT_WEIGHT_500)
              Image($r(`app.media.${data.icon}`))
                .width(20)
                .height(20)
              Text(`${data.temp}°`)
                .fontSize(16)
                .fontWeight(CommonConstants.FONT_WEIGHT_500)
                .fontColor(Color.White)
            }
          }
        })
      }
      .width('100%')
      .listDirection(Axis.Horizontal)
      .backgroundColor($r('app.color.card_background'))
      .borderRadius(10)
      .margin({top:20})
      .padding({left:20,right:20,top:10,bottom:10})

    }
    .width('90%')
    .height(130)
    .onClick( () => {
      this.isShow = !this.isShow
    })
    .bindSheet(this.isShow, this.myBuilder(), {
      detents: [700],
      backgroundColor: Color.White,
      blurStyle: BlurStyle.Thick,
      showClose: true,
      enableOutsideInteractive: false,
      dragBar: true
    })

  }

  @Builder myBuilder(){
    //The24HoursWeather({HourWeather: this.HourWeather})
    Column() {
      Text('24小时天气详情')
        .fontSize(18)
        .fontWeight(CommonConstants.FONT_WEIGHT_600)
      Scroll(){
        Column(){
          Canvas(this.context)
            .width('400%')
            .height(150)
            .onReady(() => {
              this.drawLineChart()
            })
            .margin({top:20})
          Row() {
            ForEach(this.HourWeather.hourly, (data: HourWeather, index: number) => {
              Column() {
                Column({ space: 5 }) {
                  Text(`${data.fxTime ? extractTime(data.fxTime) : ''}`)
                    .fontSize(14)
                  Image($r(`app.media.${data.icon}`))
                    .width(24)
                    .height(24)
                  Text(`${data.temp}°`)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                  Text(`${data.windDir}`)
                    .fontSize(12)
                  Text(`${data.windScale}级`)
                    .fontSize(12)
                }
                .width((1422.77) / 24)
                .height(120)
              }
              .onClick(() => {
                this.hourSelectIndex = index
              })
              .backgroundColor( this.hourSelectIndex === index ? "#41858383" : "#f1f3f5")
              .borderRadius(10)

            })
          }
          .width('400%')
          .height(120)
        }
      }
      .scrollable(ScrollDirection.Horizontal)


      // 小时的具体信息
      Grid() {
        if( this.HourWeather.hourly){
          GridItem() {
            Column() {
              Text('大气压强').fontSize(14).fontColor($r('app.color.text_fontcolor_gray'))
              Text(`${this.HourWeather.hourly[this.hourSelectIndex].pressure}千帕`).fontSize(18).fontWeight(FontWeight.Bold)
            }
          }

          GridItem() {
            Column() {
              Text('降水概率').fontSize(14).fontColor($r('app.color.text_fontcolor_gray'))
              Text(`${this.HourWeather.hourly[this.hourSelectIndex].pop}%`).fontSize(18).fontWeight(FontWeight.Bold)
            }
          }

          GridItem() {
            Column() {
              Text('湿度').fontSize(14).fontColor($r('app.color.text_fontcolor_gray'))
              Text(`${this.HourWeather.hourly[this.hourSelectIndex].humidity}%`).fontSize(18).fontWeight(FontWeight.Bold)
            }
          }
        }
      }
      .width('100%')
      .height(100)
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr')
      .padding({ top: 5 })

    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#F1F3F5')
    .borderRadius(16)
  }

  private drawLineChart() {
    if (!this.HourWeather.hourly || this.HourWeather.hourly.length === 0) {
      console.log('No data available for drawing chart')
      return
    }
    //canvas的宽高
    const width = this.context.width
    const height = this.context.height
    const padding: GeneratedObjectLiteralInterface_1 = { left: 20, right: 20, top: 30, bottom: 30 }
    const dataPoints = this.HourWeather.hourly!.map(item => Number(item.temp))
    const maxTemp = Math.max(...dataPoints)
    const minTemp = Math.min(...dataPoints)

    // 清除画布
    this.context.clearRect(0, 0, width, height)

    // 绘制折线
    this.context.beginPath()
    this.context.strokeStyle = '#FF7300'
    this.context.lineWidth = 2
    console.log('testTag width和height', this.context.width,this.context.height)
    dataPoints.forEach((temp, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (dataPoints.length - 1))
      const y = height - padding.bottom - ((temp - minTemp) / (maxTemp - minTemp) * (height - padding.top - padding.bottom))
      console.log('tesTag x,y的值：', x,y)
      if (index === 0) {
        //初始点
        this.context.moveTo(x, y)
      } else {
        //连接
        this.context.lineTo(x, y)
      }
    })
    //进行边框绘制
    this.context.stroke()

    // 绘制数据点和温度标注
    this.context.textAlign = 'center'
    this.context.font = '46px sans-serif'
    dataPoints.forEach((temp, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (dataPoints.length - 1))
      const y = height - padding.bottom - ((temp - minTemp) / (maxTemp - minTemp) * (height - padding.top - padding.bottom))

      // 绘制数据点
      this.context.beginPath()
      //绘制弧线路径
      this.context.arc(x, y, 4, 0, 2 * Math.PI)
      this.context.fillStyle = '#FF7300'
      this.context.fill()

      // 绘制温度标注
      this.context.fillStyle = '#333333'
      this.context.fillText(`${temp}°`, x, y - 15)
    })

    // 绘制时间轴
    /*this.context.textAlign = 'center'
    this.context.fillStyle = '#666666'
    this.HourWeather.hourly?.forEach((item, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (this.HourWeather.hourly!.length - 1))
      this.context.fillText(`${item.fxTime ? extractTime(item.fxTime) : ''}`, x, height - 5)
    })*/
  }
}

interface GeneratedObjectLiteralInterface_1 {
  left: number;
  right: number;
  top: number;
  bottom: number;
}



@Component
struct The24HoursWeather{
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @Prop HourWeather: WeatherItem


  build() {
    Column() {
      Canvas(this.context)
        .width('300%')
        .height(100)
        .onReady(() => {
          this.drawLineChart()
        })

      List() {
        ForEach(this.HourWeather.hourly, (data:HourWeather) => {
          ListItem() {
            Column() {
              Text(`${data.fxTime ? extractTime(data.fxTime) : ''}`).fontSize(14)
              Image($r(`app.media.${data.icon}`))
                .width(24)
                .height(24)
              Text(`${data.temp}°`).fontSize(18).fontWeight(FontWeight.Bold)
              Text(`${data.windDir} ${data.windScale}级`).fontSize(12)

              Grid() {
                GridItem() {
                  Column() {
                    Text('大气压强').fontSize(14)
                    Text(`${data.pressure}千帕`).fontSize(18).fontWeight(FontWeight.Bold)
                  }
                }
                GridItem() {
                  Column() {
                    Text('降水概率').fontSize(14)
                    Text(`${data.pop}%`).fontSize(18).fontWeight(FontWeight.Bold)
                  }
                }
                GridItem() {
                  Column() {
                    Text('湿度').fontSize(14)
                    Text(`${data.humidity}%`).fontSize(18).fontWeight(FontWeight.Bold)
                  }
                }
              }
              .columnsTemplate('1fr 1fr 1fr')
              .rowsTemplate('1fr')
              .padding({ top: 16 })
            }

          }
        })
      }
      .listDirection(Axis.Horizontal)
      .padding({ top: 16, bottom: 16 })


    }
    .padding(16)
    .backgroundColor('#F1F3F5')
    .borderRadius(16)
  }

  private drawLineChart() {
    //canvas的宽高
    const width = this.context.width
    const height = this.context.height
    const padding: GeneratedObjectLiteralInterface_1 = { left: 40, right: 40, top: 30, bottom: 20 }
    const dataPoints = this.HourWeather.hourly!.map(item => Number(item.temp))
    const maxTemp = Math.max(...dataPoints)
    const minTemp = Math.min(...dataPoints)

    // 清除画布
    this.context.clearRect(0, 0, width, height)

    // 绘制折线
    this.context.beginPath()
    this.context.strokeStyle = '#FF7300'
    this.context.lineWidth = 2
    console.log('testTag width和height', this.context.width,this.context.height)
    dataPoints.forEach((temp, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (dataPoints.length - 1))
      const y = height - padding.bottom - ((temp - minTemp) / (maxTemp - minTemp) * (height - padding.top - padding.bottom))
      console.log('tesTag x,y的值：', x,y)
      if (index === 0) {
        //初始点
        this.context.moveTo(x, y)
      } else {
        //连接
        this.context.lineTo(x, y)
      }
    })
    //进行边框绘制
    this.context.stroke()

    // 绘制数据点和温度标注
    this.context.textAlign = 'center'
    this.context.font = '36px sans-serif'
    dataPoints.forEach((temp, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (dataPoints.length - 1))
      const y = height - padding.bottom - ((temp - minTemp) / (maxTemp - minTemp) * (height - padding.top - padding.bottom))

      // 绘制数据点
      this.context.beginPath()
      //绘制弧线路径
      this.context.arc(x, y, 4, 0, 2 * Math.PI)
      this.context.fillStyle = '#FF7300'
      this.context.fill()

      // 绘制温度标注
      this.context.fillStyle = '#333333'
      this.context.fillText(`${temp}°`, x, y - 15)
    })

    // 绘制时间轴
    this.context.textAlign = 'center'
    this.context.fillStyle = '#666666'
    this.HourWeather.hourly?.forEach((item, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (this.HourWeather.hourly!.length - 1))
      this.context.fillText(`${item.fxTime ? extractTime(item.fxTime) : ''}`, x, height - 5)
    })
  }

}