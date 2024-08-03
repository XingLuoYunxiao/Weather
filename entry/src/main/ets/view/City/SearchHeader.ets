import promptAction from '@ohos.promptAction';
import { CommonConstants } from '../../common/constants/CommonConstants';
import httpGet from '../../common/util/HttpGet';
import City from '../../viewmodel/City';

@Component
export default struct SearchHeader {
  @Link searchText: string;
  @Link searchResults: City[];
  @State isLoading: boolean = false;

  async searchCity(text: string) {
    if (!text.trim()) {
      promptAction.showToast({
        message: '请输入城市名称',
        duration: 2000,
      });
      return;
    }

    this.isLoading = true;
    try {
      this.searchResults = await httpGet.searchCity(text);
      if (this.searchResults.length === 0) {
        promptAction.showToast({
          message: '未找到相关城市',
          duration: 2000,
        });
      }
    } catch (error) {
      console.error('城市搜索失败:', error);
      let errorMessage = '搜索失败，请稍后重试';
      if (error instanceof Error) {
        errorMessage = error.message;
      }
      promptAction.showDialog({
        title: '搜索错误',
        message: errorMessage,
        buttons: [
          {
            text: '确定',
            color: '#3478f6',
          },
        ],
      });
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Row() {
      TextInput({ placeholder: '搜索城市' })
        .width('80%')
        .height(40)
        .backgroundColor('#f5f5f5')
        .borderRadius(20)
        .padding({ left: 20, right: 20 })
        .onChange((value: string) => {
          this.searchText = value;
        })
      Button(this.isLoading ? '搜索中...' : '搜索')
        .width('18%')
        .height(40)
        .backgroundColor(this.isLoading ? '#cccccc' : '#ff226aea')
        .borderRadius(20)
        .margin({ left: 10 })
        .enabled(!this.isLoading)
        .onClick(() => {
          this.searchCity(this.searchText);
        })
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
  }
}