import CityItem from './CityItem'

export default class City{
  name:string
  id?: string
  detail?: CityItem

  constructor(name:string,id?:string, detail?:CityItem) {
    this.name = name
    this.id = id
    this.detail = detail
  }


}