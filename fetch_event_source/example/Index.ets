import { BusinessError } from "@kit.BasicServicesKit"
import { http } from "@kit.NetworkKit"
import { fetchEventSource } from "../Index"

const endPoint = 'https://api.openai.com'
const apiKey = 'sk-xxxxxxxxx'

export class Example {

  sendMsg(): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      fetchEventSource(endPoint + '/v1/chat/completions', {
        method: http.RequestMethod.POST,
        header: Object({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + apiKey
        }),
        extraData: JSON.stringify({
          'xxx':'xxx'
        }),
        onopen: async () => {

        },
        onmessage: (ev) => {
          if (ev.data == '[DONE]') {
            console.log('结束')
            resolve();
            return
          }
          console.log(ev.data);
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