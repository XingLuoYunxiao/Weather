export class WeatherDetail {
  fxDate?:string
  sunrise?: string
  moonrise?: string
  moonset?: string
  moonPhase?: string
  tempMax?: string
  tempMin?: string
  iconDay?: string
  textDay?: string
  iconNight?:string
  textNight?: string
  wind36Day?: string
  windDirDay?: string
  windScaleDay?: string
  windSpeedDay?: string
  wind360Night?: string
  humidity?: string
  precip?: string
  pressure?: string
  vis?: string
  cloud?: string
  uvIndex?: string

  constructor(fxDate: string, sunrise: string, moonrise: string, moonset: string, moonPhase: string, tempMax: string,
    tempMin: string, iconDay: string, textDay: string, iconNight: string, textNight: string, wind36Day: string,
    windDirDay: string, windScaleDay: string, windSpeedDay: string, wind360Night: string, humidity: string,
    precip: string, pressure: string, vis: string, cloud: string, uvIndex: string) {
    this.fxDate = fxDate
    this.sunrise = sunrise
    this.moonrise = moonrise
    this.moonset = moonset
    this.moonPhase = moonPhase
    this.tempMax = tempMax
    this.tempMin = tempMin
    this.iconDay = iconDay
    this.textDay = textDay
    this.iconNight = iconNight
    this.textNight = textNight
    this.wind36Day = wind36Day
    this.windDirDay = windDirDay
    this.windScaleDay = windScaleDay
    this.windSpeedDay = windSpeedDay
    this.wind360Night = wind360Night
    this.humidity = humidity
    this.precip = precip
    this.pressure = pressure
    this.vis = vis
    this.cloud = cloud
    this.uvIndex = uvIndex
  }


}