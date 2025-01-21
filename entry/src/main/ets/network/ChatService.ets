import { BusinessError } from "@kit.BasicServicesKit"
import { fetchEventSource } from "fetch_event_source"
import { http } from "@kit.NetworkKit"
import OpenAIResp from "../model/OpenAIResp"

const endPoint = 'https://xxx'
const apiKey = 'sk-xxx'

export default class ChatService {
  sendMsg(data: object, onMessage: (msg: string) => void): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      let respString = ''
      fetchEventSource(endPoint + '/v1/chat/completions', {
        method: http.RequestMethod.POST,
        header: Object({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + apiKey
        }),
        extraData: data,
        onopen: async () => {

        },
        onmessage: (ev) => {
          if (ev.data == '[DONE]') {
            console.log('结束')
            resolve();
            return
          }
          if (ev.data == '') {
            return
          }
          let resp = JSON.parse(ev.data) as OpenAIResp
          // 如果等于stop表示结束
          if (resp.choices?.[0]?.finish_reason === 'stop') {
            return
          }
          // 判断role存在，进行排除
          if (resp.choices?.[0]?.delta?.role !== undefined) {
            return
          }
          if (resp.choices?.[0]?.delta?.content !== undefined) {
            respString += resp.choices[0].delta.content
            onMessage(respString)
          }
        },
        onclose: () => {
          resolve()
        },
        onerror: (error) => {
          console.error('Error:', error)
          return undefined
        }
      }).catch((e: BusinessError) => {
        reject(e)
      })
    })
  }
}