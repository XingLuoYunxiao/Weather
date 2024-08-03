export default class CityItem{
  temp?: number
  weather?: string
  airQuality?: string

  constructor(temp?: number, weather?: string, airQuality?: string) {
    this.temp = temp
    this.weather = weather
    this.airQuality = airQuality
  }


}