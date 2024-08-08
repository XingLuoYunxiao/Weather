//除了天气预报外的其他指数
export default class OtherItem{
  code?:string
  updateTime?: string
  fxLink?: string
  warning?: Warn[]
  now?: AirQuality
  daily?:LifeItem[]
  refer?: Refer

  constructor(code?: string, updateTime?: string, fxLink?: string, warn?: Warn[], weather?: AirQuality, daily?:LifeItem[], refer?: Refer) {
    this.code = code
    this.updateTime = updateTime
    this.fxLink = fxLink
    this.warning = warn
    this.now = weather
    this.daily = daily
    this.refer = refer
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

export class LifeItem{
  data: string
  type: string
  name: string
  level: string
  category: string
  text: string

  constructor(data: string, type: string, name: string, level: string, category: string, text: string) {
    this.data = data
    this.type = type
    this.name = name
    this.level = level
    this.category = category
    this.text = text
  }
}

export class AirQuality{
  pubTime:string
  aqi:string
  level: string
  category: string
  primary: string
  pm10: string
  pm2p5: string
  no2: string
  so2: string
  co: string
  o3: string

  constructor(pubTime: string, aqi: string, level: string, category: string, primary: string, pm10: string, pm2p5: string, no2: string,
    so2: string, co: string, o3: string) {
    this.pubTime = pubTime
    this.aqi = aqi
    this.level = level
    this.category = category
    this.primary = primary
    this.pm10 = pm10
    this.pm2p5 = pm2p5
    this.no2 = no2
    this.so2 = so2
    this.co = co
    this.o3 = o3
  }
}

export class Warn{
  id:string
  sender:string
  pubTime:string
  title:string
  startTime:string
  endTime:string
  status:string
  level:string
  severity:string
  severityColor:string
  type:string
  typeName:string
  urgency:string
  certainty:string
  text:string
  related:string

  constructor(id: string, sender: string, pubTime: string, title: string, startTime: string, endTime: string,
    status: string, level: string, severity: string, severityColor: string, type: string, typeName: string,
    urgency: string, certainty: string, text: string, related: string) {
    this.id = id
    this.sender = sender
    this.pubTime = pubTime
    this.title = title
    this.startTime = startTime
    this.endTime = endTime
    this.status = status
    this.level = level
    this.severity = severity
    this.severityColor = severityColor
    this.type = type
    this.typeName = typeName
    this.urgency = urgency
    this.certainty = certainty
    this.text = text
    this.related = related
  }
}