import City from '../../viewmodel/City'
import WeatherItem from '../../viewmodel/WeatherItem'

@Component
export default struct The24HoursDetail {
  @Prop city:City<WeatherItem>
  build() {
    Row(){

    }
  }
}