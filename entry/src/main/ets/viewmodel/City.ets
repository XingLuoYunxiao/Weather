import WeatherItem from './WeatherItem'

export default class City<Item>{
  name:string
  id?: string
  detail?:Item

  constructor(name:string,id?:string, detail?:Item) {
    this.name = name
    this.id = id
    this.detail = detail
  }
}