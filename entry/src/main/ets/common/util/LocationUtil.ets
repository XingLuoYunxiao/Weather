import { geoLocationManager } from '@kit.LocationKit';
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';
import HttpGet from './HttpGet';
import City from '../../viewmodel/City'
import WeatherItem from '../../viewmodel/WeatherItem';


class Location{
  latitude:number
  longitude:number

  constructor(latitude: number, longitude: number) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

}

class LocationUtil {
  private  API_KEY = 'f6b4c31d80db485aabdbea8277545500';
  private  GEOCODING_API_URL = 'https://geoapi.qweather.com/v2/city/lookup';

  async getCurrentLocation(): Promise<Location> {
    /*return new Promise((resolve, reject) => {
      geoLocationManager.getCurrentLocation((err, location) => {
        if (err) {
          console.error('Failed to get current location:', err);
          reject(err);
        } else {
          resolve({
            latitude: location.latitude,
            longitude: location.longitude
          });
        }
      });
    });*/
    let loc:Location = new Location(0,0)
    let request: geoLocationManager.SingleLocationRequest = {
      locatingPriority:  0x502,
      locatingTimeoutMs: 10000
    };
     await geoLocationManager.getCurrentLocation(request).then((location: geoLocationManager.Location) => {
      console.log('current location: ' + JSON.stringify(location));
       loc = new Location(location.latitude, location.longitude)
     }).catch((err: Error) => {
      promptAction.showToast({
        message: JSON.stringify(err),
        duration: 2000
      });
    });
    return loc
  }

  async getCityInfoFromCoordinates(latitude: number, longitude: number): Promise<City<WeatherItem>> {
    let TheCity:City<WeatherItem> = new City<WeatherItem>('','')
    const location = `${longitude.toFixed(2)},${latitude.toFixed(2)}`

    await HttpGet.searchCity(location).then( city => {
      if( city.length > 0){
        TheCity = city.shift()!
      }

    })
    return TheCity
  }

  async getCurrentCityInfo(): Promise<City<WeatherItem>> {
    try {
      const location:Location = await this.getCurrentLocation();
      return await this.getCityInfoFromCoordinates(location.latitude, location.longitude);
    } catch (error) {
      console.error('Failed to get current city info:', error);
      throw new Error(error)
    }
  }
}

let locationUtil = new LocationUtil()
export default locationUtil as LocationUtil