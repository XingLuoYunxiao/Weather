import CityItem from './CityItem'
import WeatherItem from './WeatherItem'

export default class City{
  name:string
  id?: string
  detail?: WeatherItem

  constructor(name:string,id?:string, detail?:WeatherItem) {
    this.name = name
    this.id = id
    this.detail = detail
  }


}