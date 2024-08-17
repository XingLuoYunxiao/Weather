import { AnimatorResult } from '@ohos.animator'


@Entry
@Component
struct MovingCloudsBackground {
  @State right1:number = 10
  @State down1:number = 0

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 背景天空
      Image($r('app.media.sky_background'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)


      /*Button('开始')
        .onClick( () => {
          this.startCloudAnimation()
        })*/
      // 云朵1
      Image($r('app.media.cloud1'))
        .width('30%')
        .objectFit(ImageFit.Contain)
        .position({ x: this.down1, y: this.right1 })
        .onClick( () => {
          animateTo({
            duration: 2000,
            curve: Curve.EaseOut,
            iterations: -1,
            playMode: PlayMode.Normal,
            onFinish: () => {
              console.info('play end')
            }
          }, () => {
            this.right1 = 10
            this.down1 = 300
          })
        })

      // 云朵2
      Image($r('app.media.cloud2'))
        .width('20%')
        .objectFit(ImageFit.Contain)
        .position({ x: `0`, y: '30%' })

      // 页面内容
      Column() {
        Text('晴天动态背景')
          .fontSize(30)
          .fontColor(Color.White)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}