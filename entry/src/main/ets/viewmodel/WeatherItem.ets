import DayWeather from './DayWeather'
import HourWeather  from './HourWeather'

export default class WeatherItem{
  code?:string
  updateTime?: string
  fxLink?: string
  now?:WeatherDetail
  hourly?:HourWeather[]
  daily?:DayWeather[]
  refer?: Refer

  constructor(code?: string, updateTime?: string, fxLink?: string, weather?: WeatherDetail, hourly?:HourWeather[], daily?:DayWeather[], refer?: Refer) {
    this.code = code
    this.updateTime = updateTime
    this.fxLink = fxLink
    this.now = weather
    this.hourly = hourly
    this.daily = daily
    this.refer = refer
  }

}

export class WeatherDetail{
  obsTime?:string
  temp?:string
  feelsLike?: string
  icon?: string
  text?: string
  wind360?: string
  windDir?: string
  windScale?: string
  windSpeed?:string
  humidity?: string
  precip?: string
  pressure?:string
  vis?:string
  cloud?:string
  dew?:string

  constructor(obsTime?: string, temp?: string, feelsLike?: string, icon?: string, text?: string, wind360?: string,
    windDir?: string, windScale?: string, windSpeed?: string, humidity?: string, precip?: string, pressure?: string,
    vis?: string, cloud?: string, dew?: string) {
    this.obsTime = obsTime
    this.temp = temp
    this.feelsLike = feelsLike
    this.icon = icon
    this.text = text
    this.wind360 = wind360
    this.windDir = windDir
    this.windScale = windScale
    this.windSpeed = windSpeed
    this.humidity = humidity
    this.precip = precip
    this.pressure = pressure
    this.vis = vis
    this.cloud = cloud
    this.dew = dew
  }
}

class Refer{
  sources?: string[]
  license?: string[]

  constructor(sources?: string[], license?: string[]) {
    this.sources = sources
    this.license = license
  }

}