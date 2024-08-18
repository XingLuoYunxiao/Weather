
class  Weather{
  time:string
  temp:number
  weather: string
  wind:string
  airQuality:string

  constructor(time: string, temp: number, weather: string, wind: string, airQuality: string) {
    this.time = time
    this.temp = temp
    this.weather = weather
    this.wind = wind
    this.airQuality = airQuality
  }

}

interface GeneratedObjectLiteralInterface_1 {
  left: number;
  right: number;
  top: number;
  bottom: number;
}


@Entry
@Component
struct test1 {
  build() {
    Column(){
      MyComponent1()
    }
  }


}

@Component
struct MyComponent1{
  @State isShow: boolean = false
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  @State weatherData: Weather[] = [
    new Weather('现在', 24, '多云', '软风1级', '良'),
    new Weather('23:00', 26, '雨', '软风1级','良' ),
    new Weather('00:00', 25, '雨', '软风1级','良' ),
    new Weather('01:00', 23, '多云', '无风级','良'),
    new Weather('02:00', 22, '多云', '软风1级','良'),
    new Weather('03:00', 21, '小雨', '无风级','优'),
  ]

  build() {
    Column(){
      Text('点我')
    }
    .onClick( () => {
      this.isShow = !this.isShow
    })
    .bindSheet(this.isShow, this.myBuilder(),{
      detents:[ SheetSize.LARGE],
      backgroundColor: Color.White,
      blurStyle: BlurStyle.Thick,
      showClose: true,
      enableOutsideInteractive: false,
      dragBar: true
    })
    .width('100')
    .height('100')
    .backgroundColor('#ffff6767')
  }

  @Builder myBuilder(){
    /*Text('myBuilder--------------------------')
      .width('100%')
      .height(100)*/
    Column() {
      Canvas(this.context)
        .width('100%')
        .height(100)
        .onReady(() => {
          this.drawLineChart()
        })

      Grid() {
        ForEach(this.weatherData, (item:Weather) => {
          GridItem() {
            Column() {
              Text(item.time).fontSize(14)
              Image(this.getWeatherIcon(item.weather!))
                .width(24)
                .height(24)
              Text(`${item.temp}°`).fontSize(18).fontWeight(FontWeight.Bold)
              Text(item.wind).fontSize(12)
              Text(item.airQuality).fontSize(12)
            }
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
      .padding({ top: 16, bottom: 16 })

      Grid() {
        GridItem() {
          Column() {
            Text('体感温度').fontSize(14)
            Text('30°').fontSize(18).fontWeight(FontWeight.Bold)
          }
        }
        GridItem() {
          Column() {
            Text('紫外线').fontSize(14)
            Text('1级 很弱').fontSize(18).fontWeight(FontWeight.Bold)
          }
        }
        GridItem() {
          Column() {
            Text('降水概率').fontSize(14)
            Text('0%').fontSize(18).fontWeight(FontWeight.Bold)
          }
        }
        GridItem() {
          Column() {
            Text('湿度').fontSize(14)
            Text('90%').fontSize(18).fontWeight(FontWeight.Bold)
          }
        }
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .padding({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#F1F3F5')
    .borderRadius(16)
  }

  private drawLineChart() {
    //canvas的宽高
    const width = this.context.width
    const height = this.context.height
    const padding: GeneratedObjectLiteralInterface_1 = { left: 40, right: 40, top: 30, bottom: 20 }
    const dataPoints = this.weatherData.map(item => item.temp)
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
    this.weatherData.forEach((item, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (this.weatherData.length - 1))
      this.context.fillText(item.time, x, height - 5)
    })
  }

  private getWeatherIcon(weather: string): Resource {
    switch (weather) {
      case '多云':
        return $r('app.media.101')
      case '雨':
      case '小雨':
        return $r('app.media.150')
      default:
        return $r('app.media.103')
    }
  }
}

@Component
struct MyComponent2{
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  @State weatherData: Weather[] = [
    new Weather('现在', 24, '多云', '软风1级', '良'),
    new Weather('23:00', 26, '雨', '软风1级','良' ),
    new Weather('00:00', 25, '雨', '软风1级','良' ),
    new Weather('01:00', 23, '多云', '无风级','良'),
    new Weather('02:00', 22, '多云', '软风1级','良'),
    new Weather('03:00', 21, '小雨', '无风级','优'),
  ]

  build() {
    Column() {
      Canvas(this.context)
        .width('100%')
        .height(100)
        .onReady(() => {
          this.drawLineChart()
        })

      Grid() {
        ForEach(this.weatherData, (item:Weather) => {
          GridItem() {
            Column() {
              Text(item.time).fontSize(14)
              Image(this.getWeatherIcon(item.weather!))
                .width(24)
                .height(24)
              Text(`${item.temp}°`).fontSize(18).fontWeight(FontWeight.Bold)
              Text(item.wind).fontSize(12)
              Text(item.airQuality).fontSize(12)
            }
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
      .padding({ top: 16, bottom: 16 })

      Grid() {
        GridItem() {
          Column() {
            Text('体感温度').fontSize(14)
            Text('30°').fontSize(18).fontWeight(FontWeight.Bold)
          }
        }
        GridItem() {
          Column() {
            Text('紫外线').fontSize(14)
            Text('1级 很弱').fontSize(18).fontWeight(FontWeight.Bold)
          }
        }
        GridItem() {
          Column() {
            Text('降水概率').fontSize(14)
            Text('0%').fontSize(18).fontWeight(FontWeight.Bold)
          }
        }
        GridItem() {
          Column() {
            Text('湿度').fontSize(14)
            Text('90%').fontSize(18).fontWeight(FontWeight.Bold)
          }
        }
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .padding({ top: 16 })
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
    const dataPoints = this.weatherData.map(item => item.temp)
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
    this.weatherData.forEach((item, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (this.weatherData.length - 1))
      this.context.fillText(item.time, x, height - 5)
    })
  }

  private getWeatherIcon(weather: string): Resource {
    switch (weather) {
      case '多云':
        return $r('app.media.101')
      case '雨':
      case '小雨':
        return $r('app.media.150')
      default:
        return $r('app.media.103')
    }
  }
}