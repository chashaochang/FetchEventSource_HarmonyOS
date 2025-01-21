import { BusinessError } from '@kit.BasicServicesKit'
import { BaseDataSourceWrapper } from '../model/BaseDataSourceWrapper'
import { Message } from '../model/Message'
import { ReqEntity } from '../model/ReqEntity'
import ChatService from '../network/ChatService'

@ObservedV2
export class ChatViewModel {
  @Trace sending: boolean = false
  messageList: Message[] = []
  @Trace dataSource: BaseDataSourceWrapper<Message> = new BaseDataSourceWrapper(this.messageList)
  @Trace inputText: string = ''
  @Trace keyboardHeight: number = 0; // 软键盘高度
  @Trace title: string = ''
  apiService = new ChatService()

  getChatInfo() {
    //假装从网络取到的
    this.title = "豆包"
    this.messageList.push({
      role: 'assistant',
      content: '嗨，我是你的新朋友豆包！初次见面很开心。我呢，可以回答你的各种问题，给你工作学习上提供帮助，还能随时陪你聊天。嗯，你想问点什么呢？'
    })
  }

  sendMsg(onchange: () => void) {
    if (this.sending === true) {
      return
    }
    this.sending = true
    this.title = "对方正在输入"
    let data = new ReqEntity(this.messageList, 'claude-3-5-sonnet')
    this.apiService.sendMsg(data, (msg) => {
      if (this.messageList[this.messageList.length -1].role !== 'assistant') {
        let message = new Message()
        message.role = 'assistant'
        this.messageList.push(message)
      }
      this.messageList[this.messageList.length -1].content = msg
      this.dataSource.notifyDataAdd(this.messageList.length - 1)
      onchange()
    }).then(() => {
      this.title = '豆包'
      this.sending = false
    }).catch((e: BusinessError) => {
      this.title = '豆包'
    })
  }
}