@Entry
@Component
struct Index {
  @StorageLink('count') count: number = 0;
  @StorageLink('count') anotherCount: number = 0;

  build() {
    Column() {
      Text(`Count: ${this.count}`)
      Button('Increment Count')
        .onClick(() => {
          this.count++;
        })

      Text(`Another Count: ${this.anotherCount}`)
      Button('Increment Another Count')
        .onClick(() => {
          this.anotherCount++;
        })
    }
  }
}