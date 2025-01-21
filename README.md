## 简介

由微软开源的<a>https://github.com/Azure/fetch-event-source</a>鸿蒙化

利用系统的http库实现，提供了更灵活、功能更全面的事件源请求接口。这个库兼容`Event Stream`格式，使您能轻松地与现有的`SSE`服务器进行交互，并拥有更多的控制权和定制性。

### 效果图

![效果图](/fetch_event_source/example/example.gif)

## 安装

通过 ohpm

``` shell
ohpm install fetch_event_source
```


## 示例

```typescript
import { fetchEventSource } from "fetch_event_source"

await fetchEventSource('/api/sse', {
  onmessage(ev) {
    console.log(ev.data);
  }
});
```

复杂一些的使用:

```typescript
import { fetchEventSource } from "fetch_event_source"

fetchEventSource('/api/sse', {
  method: http.RequestMethod.POST,
  header: Object({
    'Content-Type': 'application/json',
    'Authorization': 'Bearer sk-xxx'
  }),
  extraData: JSON.stringify({
    foo: 'bar'
  }),
  onopen: async () => {

  },
  onmessage: (ev) => {
    console.log(ev.data);
  },
  onclose: () => {

  },
  onerror: (error) => {
    console.error('Error:', error)
    return undefined
  }
})
```