import http from '@ohos.net.http';
import City from '../../viewmodel/City';
import WeatherItem from '../../viewmodel/WeatherItem';

interface CityApiResponse {
  location: Array<City<WeatherItem>>;
}


class HttpGet {
  private searchCityUrl: string = 'https://geoapi.qweather.com/v2/city/lookup';
  private searchIdUrl: string = 'https://devapi.qweather.com/v7/weather';
  //private searchIdUrl: string = 'https://devapi.qweather.com/v7/grid-weather/';
  private key: string = 'f6b4c31d80db485aabdbea8277545500';
  data:string = ""


  async searchCity(cityName: string): Promise<City<WeatherItem>[]> {
    let httpRequest = http.createHttp();
    try {
      let response = await httpRequest.request(
        this.searchCityUrl,
        {
          method: http.RequestMethod.GET,
          extraData: {
            location: cityName,
            key: this.key,
            gzip: 'n'
          },
          connectTimeout: 10000,
          readTimeout: 10000
        }
      );

      if (response.responseCode === 200) {
        let responseData = JSON.parse(response.result.toString()) as CityApiResponse;
        console.log('网络：城市搜索成功', JSON.stringify(responseData));

        let cities: City<WeatherItem>[] = responseData.location.map(loc => new City<WeatherItem>(loc.name, loc.id));
        return cities;
      } else {
        console.log('城市搜索失败：错误1', JSON.stringify(response));
        throw new Error(`服务器响应错误：${response.responseCode}`);
      }
    } catch (error) {
      console.log('城市搜索失败：错误2', JSON.stringify(error));
      if (error instanceof Error) {
        if (error.message.includes("Couldn't resolve host name")) {
          throw new Error('网络连接失败，请检查您的网络设置');
        } else if (error.message.includes("Timeout was reached")) {
          throw new Error('网络请求超时，请检查您的网络连接并重试');
        } else {
          throw new Error('搜索失败：' + error.message);
        }
      } else {
        throw new Error('未知错误发生，请稍后重试');
      }
    } finally {
      httpRequest.destroy();
    }
  }

  getCityWeatherData<T>(cityId: string | undefined, time: string):Promise<T> {
    /*let httpRequest = http.createHttp()
    try{
      let resp = await httpRequest.request(
        `${this.searchIdUrl}/${time}`,
        {
          method: http.RequestMethod.GET,
          extraData: {
            location: cityId,
            key: this.key,
          }
        }
      );

      console.log("resp:",resp)
      if( resp.responseCode === 200){
        console.log('获取天气信息成功', resp.result)
        let data:WeatherItem = JSON.parse(resp.result.toString()) as WeatherItem
        return data
      } else {
        console.log('获取天气信息失败 错误1:', JSON.stringify(resp))
        throw new Error(`服务器响应错误：${resp.responseCode}`);
      }
    }catch (error) {
      console.log('天气获取失败：错误2', JSON.stringify(error));
      if (error instanceof Error) {
        if (error.message.includes("Couldn't resolve host name")) {
          throw new Error('网络连接失败，请检查您的网络设置');
        } else if (error.message.includes("Timeout was reached")) {
          throw new Error('网络请求超时，请检查您的网络连接并重试');
        } else {
          throw new Error('搜索失败：' + error.message);
        }
      } else {
        throw new Error('未知错误发生，请稍后重试');
      }
    } finally {
      httpRequest.destroy();
    }*/
    return new Promise(async (resolve, reject) => {
      //创建http请求
      let httpRequest = http.createHttp()
      let resp = httpRequest.request(
        `${this.searchIdUrl}/${time}`,
        {
          method: http.RequestMethod.GET,
          extraData: {
            location: cityId,
            key: this.key,
            gzip: "n"
          }
        }
      )/*;
      if( resp.responseCode === 200){
        console.log('获取天气信息成功', resp.result)
        let data:WeatherItem = JSON.parse(resp.result.toString()) as WeatherItem
        resolve(data)
      } else {
        console.log('获取天气信息失败 error:', JSON.stringify(resp))
        reject(`获取${time}天气失败`)
      }*/
      await resp.then( resp => {
          if(resp.responseCode === 200){
            console.log('获取天气信息成功', resp.result)
            //resolve(JSON.parse(resp.result.toString()))
            let data:T = JSON.parse(resp.result.toString()) as T
            resolve(data)
          } else {
            console.log('获取天气信息失败 error:', JSON.stringify(resp))
            reject(`获取${time}天气失败`)
          }
        })
    })

  }
}

let httpGet = new HttpGet();
export default httpGet as HttpGet;