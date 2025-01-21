import { Message } from './Message'

export class ReqEntity {
  messages: Message[] = []
  model: string = ''
  presence_penalty: number = 0
  frequency_penalty: number = 0
  stream = true
  temperature = 0.9
  max_tokens = 4096
  top_p = 0

  constructor(messages: Message[], model: string) {
    this.messages = messages
    this.model = model
  }
}