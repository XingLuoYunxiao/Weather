export class HourWeather {
  fxTime?: string
  temp?: string
  icon?: string
  text?: string
  wind360?: string
  windDir?: string
  windScale?: string
  windSpeed?: string
  humidity?: string
  pop?: string
  precip?: string
  pressure?: string
  cloud?: string
  dew?: string

  constructor(fxTime: string, temp: string, icon: string, text: string, wind360: string, windDir: string,
    windScale: string, windSpeed: string, humidity: string, pop: string, precip: string, pressure: string,
    cloud: string, dew: string) {
    this.fxTime = fxTime
    this.temp = temp
    this.icon = icon
    this.text = text
    this.wind360 = wind360
    this.windDir = windDir
    this.windScale = windScale
    this.windSpeed = windSpeed
    this.humidity = humidity
    this.pop = pop
    this.precip = precip
    this.pressure = pressure
    this.cloud = cloud
    this.dew = dew
  }

  
}