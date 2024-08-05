import preferences from '@ohos.data.preferences'

class City{
  name:string
  id?: string

  constructor(name:string,id?:string) {
    this.name = name
    this.id = id
  }


}
class PreferencesUtil {
  prefMap: Map<string, preferences.Preferences> = new Map()

  async loadPreference(context, name: string) {
    try {
      let pref = await preferences.getPreferences(context, name)
      this.prefMap.set(name, pref)
      console.log('testTag', `加载Preferences[${name}]成功`)
    } catch (e) {
      console.log('testTag', `加载Preferences[${name}]失败`, JSON.stringify(e))
    }
  }

  async putCity(name: string, cityName: string, cityId: string) {
    if (!this.prefMap.has(name)) {
      console.log('testTag', `Preferences[${name}]尚未初始化`)
      return
    }
    try {
      let pref = this.prefMap.get(name)
      if (pref) {
        await pref.put(cityName, cityId)
        await pref.flush()
      }
      console.log('testTag', `保存城市[${cityName}:${cityId}]成功`)
    } catch (e) {
      console.log('testTag', `保存城市[${cityName}:${cityId}]失败`, JSON.stringify(e))
    }
  }

  async getCityId(name: string, cityName: string): Promise<string | null> {
    if (!this.prefMap.has(name)) {
      console.log('testTag', `Preferences[${name}]尚未初始化`)
      return null
    }
    try {
      let pref = this.prefMap.get(name)
      const cityId = await pref?.get(cityName, null)
      if (cityId) {
        console.log('testTag', `读取城市ID[${cityName}:${cityId}]成功`)
        return cityId as string
      }
      return null
    } catch (e) {
      console.log('testTag', `读取城市ID[${cityName}]失败`, JSON.stringify(e))
      return null
    }
  }

  async getAllCities(name: string): Promise<City[]> {
    if (!this.prefMap.has(name)) {
      console.log('testTag', `Preferences[${name}]尚未初始化`)
      return []
    }
    try {
      let pref = this.prefMap.get(name)
      const allEntries = await pref?.getAll()
      if (allEntries) {
        const cityMap = new Map<string, string>(Object.entries(allEntries))
        const cities:City[] = Object.entries(allEntries).map(([key,value]) => new City(key, value))
        console.log('testTag', `读取所有城市成功，共${cityMap.size}个城市`)
        return cities
      }
      return []
    } catch (e) {
      console.log('testTag', `读取所有城市失败`, JSON.stringify(e))
      return []
    }
  }

  async removeCity(name: string, cityName: string) {
    if (!this.prefMap.has(name)) {
      console.log('testTag', `Preferences[${name}]尚未初始化`)
      return
    }
    try {
      let pref = this.prefMap.get(name)
      if (pref) {
        await pref.delete(cityName)
        await pref.flush()
      }
      console.log('testTag', `删除城市[${cityName}]成功`)
    } catch (e) {
      console.log('testTag', `删除城市[${cityName}]失败`, JSON.stringify(e))
    }
  }

}

const preferencesUtil = new PreferencesUtil()
export default preferencesUtil as PreferencesUtil