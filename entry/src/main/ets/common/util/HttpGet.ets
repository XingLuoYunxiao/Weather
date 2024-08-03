import http from '@ohos.net.http';
import City from '../../viewmodel/City';
//import CityItem from './CityItem';

interface GeneratedTypeLiteralInterface_1 {
  name: string;
  id: string;
}

interface CityApiResponse {
  location: Array<GeneratedTypeLiteralInterface_1>;
}

interface GeneratedTypeLiteralInterface_2 {
  temp: number;
  text: string;
  category: string;
}

interface WeatherApiResponse {
  now: GeneratedTypeLiteralInterface_2;
}

class HttpGet {
  private searchCityUrl: string = 'https://geoapi.qweather.com/v2/city/lookup';
  private searchIdUrl: string = 'https://devapi.qweather.com/v7/weather/';
  private key: string = 'f6b4c31d80db485aabdbea8277545500';

  async searchCity(cityName: string): Promise<City[]> {
    let httpRequest = http.createHttp();
    try {
      let response = await httpRequest.request(
        this.searchCityUrl,
        {
          method: http.RequestMethod.GET,
          extraData: {
            location: cityName,
            key: this.key
          },
          connectTimeout: 10000,
          readTimeout: 10000
        }
      );

      if (response.responseCode === 200) {
        let responseData = JSON.parse(response.result.toString()) as CityApiResponse;
        console.log('网络：城市搜索成功', JSON.stringify(responseData));

        let cities: City[] = responseData.location.map(loc => new City(loc.name, loc.id));
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

  // getCityWeatherData 方法保持不变...
}

let httpGet = new HttpGet();
export default httpGet as HttpGet;