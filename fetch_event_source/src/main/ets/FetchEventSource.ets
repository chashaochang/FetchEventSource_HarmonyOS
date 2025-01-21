import { http } from "@kit.NetworkKit";
import { EventSourceMessage, getBytes, getLines, getMessages } from "./parse";
import { BusinessError } from "@kit.BasicServicesKit";

const DefaultRetryInterval = 1000;
const LastEventId = 'last-event-id';

interface FetchEventSourceOptions extends http.HttpRequestOptions {
  onopen?: () => Promise<void>,
  onmessage?: (msg: EventSourceMessage) => void
  onclose?: () => void
  onerror?: (err: BusinessError) => number | undefined,
}

export async function fetchEventSource(url: string, options: FetchEventSourceOptions) {
  return new Promise<void>((resolve, reject) => {
    const headers: object = options.header ?? new Object()
    options.expectDataType = http.HttpDataType.ARRAY_BUFFER
    let httpRequest = http.createHttp();
    let retryInterval = DefaultRetryInterval;
    let retryTimer = 0;
    try {
      httpRequest.on('dataReceive', (res: ArrayBuffer) => {
        getBytes(res, getLines(getMessages(id => {
          if (id) {
            // store the id and send it back on the next retry:
            headers[LastEventId] = id;
          } else {
            // don't send the last-event-id header anymore:
            headers[LastEventId] = undefined
          }
        }, retry => {
          retryInterval = retry;
        }, options.onmessage)))
      })
      httpRequest.on('dataEnd', () => {
        options.onclose?.()
        httpRequest.off('dataReceive')
        httpRequest.off('dataEnd')
        resolve();
      })
      httpRequest.requestInStream(url, options)
      options.onopen?.()
    } catch (err) {
      try {
        // check if we need to retry:
        const interval = options.onerror?.(err) ?? retryInterval;
        clearTimeout(retryTimer);
        retryTimer = setTimeout(() => {
          httpRequest.requestInStream(url, options)
        }, interval);
      } catch (innerErr) {
        reject(innerErr);
      }
    }
  })
}