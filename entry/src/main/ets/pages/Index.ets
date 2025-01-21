import { lvMarkdownIn, lvText } from '@luvi/lv-markdown-in'
import { ActionBar } from '../components/ActionBar'
import { Message } from '../model/Message'
import { ChatViewModel } from './ChatViewModel'

@Entry
@ComponentV2
struct Index {
  pathStack: NavPathStack = AppStorage.get("PathStack") as NavPathStack
  textInputController?: TextInputController
  scroller = new ListScroller()
  @Local vm: ChatViewModel = new ChatViewModel()

  aboutToAppear(): void {
    this.vm.getChatInfo()
  }

  build() {
    Column() {
      ActionBar({
        title: this.vm.title,
        isLight: false,
        enableNavBack:false
      })
      List({
        scroller: this.scroller
      }) {
        LazyForEach(this.vm.dataSource, (item: Message) => {
          ListItem() {
            if (item.role === 'system') {
              Stack() {
                Text('请注意,智能体回复内容均由AI生成')
                  .padding({
                    top: '2vp',
                    bottom: '2vp',
                    left: '8vp',
                    right: '8vp'
                  })
                  .backgroundColor('#90ffffff')
                  .borderRadius($r('sys.float.corner_radius_level6'))
              }.width('100%').margin('10vp')
            } else if (item.role === 'assistant') {
              Row() {
                lvMarkdownIn({
                  text: item.content.toString(), // content为文本内容
                }).padding({
                  top: '8vp',
                  bottom: '8vp',
                  left: '12vp',
                  right: '12vp'
                })
                  .margin({
                    left: '12vp', right: '20%'
                  })
                  .backgroundColor(Color.White)
                  .borderRadius({
                    bottomLeft: '20vp', topRight: '20vp', bottomRight: '20vp'
                  })
              }.width('100%').margin('10vp')
            } else if (item.role === 'user') {
              Row() {
                Text(item.content)
                  .fontColor(Color.White)
                  .padding({
                    top: '8vp',
                    bottom: '8vp',
                    left: '12vp',
                    right: '12vp'
                  })
                  .margin({
                    right: '12vp', left: '20%'
                  })
                  .backgroundColor(Color.Blue)
                  .borderRadius({
                    topLeft: '20vp', topRight: '20vp', bottomLeft: '20vp'
                  })
              }.justifyContent(FlexAlign.End).margin('10vp')
            }
          }
        })
      }
      .height(0)
      .layoutWeight(1)
      .width('100%')
      .onClick(() => {
        this.getUIContext().getFocusController().clearFocus();
      })
      .onWillScroll(() => {
        this.getUIContext().getFocusController().clearFocus();
      })
      .onSizeChange(() => {
        this.scroller.scrollEdge(Edge.Bottom)
      })
      .alignListItem(ListItemAlign.End)

      Row() {
        TextInput({
          text: this.vm.inputText,
          controller: this.textInputController
        }).layoutWeight(1).backgroundColor('#90ffffff').onChange(e => {
          this.vm.inputText = e
        })
        Button() {
          Text('发送').fontColor(Color.White)
        }
        .width('60vp')
        .height('32vp')
        .margin({ left: '12vp' })
        .onClick(() => {
          this.vm.messageList.push({ role: 'user', content: this.vm.inputText })
          this.vm.dataSource.notifyDataAdd(this.vm.messageList.length - 1)
          this.vm.inputText = ''
          this.scroller.scrollEdge(Edge.Bottom)
          this.vm.sendMsg(() => {
            this.scroller.scrollEdge(Edge.Bottom)
          })
          this.getUIContext().getFocusController().clearFocus();
        })
      }
      .padding({
        left: '16vp',
        right: '16vp',
        top: '10vp',
        bottom: '10vp'
      })

      Stack().height(this.vm.keyboardHeight)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .backgroundBrightness({ rate: 0.2, lightUpDegree: 0 })
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.KEYBOARD], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}